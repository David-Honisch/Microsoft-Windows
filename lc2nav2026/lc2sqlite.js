print_action('external script is running...');

const RSS_PROXY = "https://www.letztechance.org/webservices/getcontent.php?ext_url=";
const RSS_VIEWER = "https://www.letztechance.org/srss.html?query=";

const createNEWUI = (url, title) => {
    window.createTauriWindow(url, title);
};
//css fix
window.addEventListener('scroll', function () {
    const element = document.querySelector('.clock-container');

    if (window.scrollY >= 100) {
        element.classList.add('scrolled-past');
    } else {
        element.classList.remove('scrolled-past');
    }
});
//eof css fix

createNEWUI("https://www.letztechance.org/tools/lc2webllmchat", "LC2WebLLM-Chat");
/**
 * Build the full proxied URL for an RSS feed entry from the config.
 * @param {string} rss - Raw RSS feed URL from config.
 * @returns {string}
 */
function buildFeedUrl(rss) {
    return RSS_PROXY + encodeURIComponent(RSS_VIEWER + rss);
}

setTimeout(function () {
    try {
        /** @type {Array<{id:string, label:string, rss:string, target?:string, marquee?:boolean}>} */
        var feeds = (typeof window.__news_api === 'undefined' || !Array.isArray(window.__news_api)) ? [] :
            window.__news_api;

        if (feeds.length === 0) {
            console.warn('lc2sqlite.js: window.__news_api is empty or not set');
            return;
        }

        var newsMessage = document.getElementById("news_Message");
        var extnewsMessage = document.getElementById("extnewsMessage");

        // Inject placeholder <pre> elements for feeds that target #newsMessage
        var inlineFeeds = feeds.filter(function (f) {
            return !f.target;
        });
        if (inlineFeeds.length >= 0 && newsMessage) {
            var placeholders = inlineFeeds.map(function (f) {
                return '<pre id="' + f.id + '">Loading ' + f.label + '...</pre>';
            }).join('');
            newsMessage.innerHTML += placeholders;
        }

        feeds.forEach(function (feed) {
            var url = buildFeedUrl(feed.rss);
            var outEl;
            if (feed.target) {
                outEl = document.getElementById(feed.target);
            } else {
                outEl = document.getElementById(feed.id);
            }
            if (!outEl) {
                console.warn('lc2sqlite.js: output element not found for feed', feed.id);
                newsMessage.innerHTML += "lc2sqlite.js: output element not found for feed:" + feed.id;
                return;
            }
            outEl.innerHTML = "Reading:" + url;
            _generateHrefs(url, outEl, 25, feed.rss);
            if (feed.marquee) {
                addCssCLS(feed.id, "marquee");
            }
        });

    } catch (error) {
        console.error('lc2sqlite.js init error:', error);
    }
}, 5000);
async function fetchHtml(url) {
    return await window.invokeTauriCommand('fetch_html', {
        url
    });
}
/**
 * Fetch HTML from a proxied URL and render links into divout.
 * @param {string} url
 * @param {HTMLElement} divout
 * @param {number} [maxItems=25]
 * @param {string} [baseUrl]
 */
function _generateHrefs(url, divout, maxItems, baseUrl) {
    if (divout === undefined) return;
    maxItems = maxItems || 25;
    divout.innerHTML = "Fetching:" + url;
    console.log("fetching external url: " + url);
    try {
        fetchHtml(url)
            .then(function (response) {
                try {
                    console.log("response: " + response);
                    // divout.innerHTML = "Rendering:" + JSON.stringify(response);
                    var txt = response && response.html ? response.html : response;
                    divout.innerHTML = "" + url; // response && response.html ? "RESPONSE:" + response.html : "TEXT:" + txt;
                    print_generateHrefs(txt, divout, maxItems, baseUrl);
                } catch (error) {
                    console.error("Error printing HTML:", error);
                    divout.innerHTML = "Error: " + error;
                }
            })
            .catch(function (error) {
                console.error("Error fetching HTML:", error);
                divout.innerHTML = "Error: " + error;
            });
    } catch (error) {

    }
}

/**
 * Parse fetched HTML, extract links, and append a <ul> to divout.
 * @param {string} text
 * @param {HTMLElement} divout
 * @param {number} [maxItems=25]
 * @param {string} [baseUrl]
 */
function print_generateHrefs(text, divout, maxItems, baseUrl) {
    maxItems = maxItems || 25;
    try {
        var matches = parseHtmlAndExtractUrls(text, baseUrl);
        var ul = document.createElement("ul");
        ul.className = "listul";
        var count = 0;
        for (var i = 0; i < matches.length; i++) {
            var item = matches[i];
            if (
                !item.url || item.url.length <= 5 ||
                !item.innerHtml || item.innerHtml.trim().length <= 1 ||
                /\.(jpe?g|png)$/i.test(item.url)
            ) {
                continue;
            }

            // Filter out "Comment" (case-insensitive) from innerHtml
            var filteredInnerHtml = item.innerHtml.replace(/comments\b/gi, '');

            if (filteredInnerHtml.trim().length <= 1) {
                continue;
            }

            var li = document.createElement("li");
            var a = document.createElement("a");
            a.href = item.url;
            a.target = "_blank";
            a.textContent = i + "-" + filteredInnerHtml;
            li.appendChild(a);
            ul.appendChild(li);
            if (++count >= maxItems) break;
        }
        divout.appendChild(ul);
    } catch (error) {
        console.error("Error parsing HTML:", error);
        divout.appendChild(document.createTextNode("Error: " + error));
    }
}

// function print_generateHrefs(text, divout, maxItems, baseUrl) {
//     // divout.innerHTML = text;
//     maxItems = maxItems || 25;
//     try {
//         var matches = parseHtmlAndExtractUrls(text, baseUrl);
//         var ul = document.createElement("ul");
//         ul.className = "listul";
//         var count = 0;
//         for (var i = 0; i < matches.length; i++) {
//             var item = matches[i];
//             if (
//                 !item.url || item.url.length <= 5 ||
//                 !item.innerHtml || item.innerHtml.trim().length <= 1 ||
//                 /\.(jpe?g|png)$/i.test(item.url)
//             ) {
//                 continue;
//             }
//             var li = document.createElement("li");
//             var a = document.createElement("a");
//             a.href = item.url;
//             a.target = "_blank";
//             a.textContent = i + "-" + item.innerHtml;
//             li.appendChild(a);
//             ul.appendChild(li);
//             if (++count >= maxItems) break;
//         }
//         divout.appendChild(ul);
//     } catch (error) {
//         console.error("Error parsing HTML:", error);
//         divout.appendChild(document.createTextNode("Error: " + error));
//     }
// }

/**
 * Parse an HTML string and return [{url, innerHtml}] for every <a> found.
 * @param {string} html
 * @param {string} [baseUrl]
 * @returns {Array<{url:string, innerHtml:string}>}
 */
function parseHtmlAndExtractUrls(html, baseUrl) {
    var parser = new DOMParser();
    var doc = parser.parseFromString(html, 'text/html');
    var links = doc.querySelectorAll('a');
    var result = [];
    links.forEach(function (link) {
        var href = link.getAttribute('href');
        if (href) {
            var absoluteUrl;
            try {
                absoluteUrl = new URL(href, baseUrl || window.location.href).href;
            } catch (e) {
                absoluteUrl = href;
            }
            result.push({
                url: absoluteUrl,
                innerHtml: link.textContent
            });
        }
    });
    return result;
}

/**
 * Add a CSS class to the element with the given id.
 * @param {string} id
 * @param {string} cls
 */
function addCssCLS(id, cls) {
    var el = document.getElementById(id);
    if (el) el.classList.add(cls);
}
//filter executables
// const executables = [
//     "LC2DL.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\LC2DL.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\lc2extract.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\lc2navigator2027.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\lc2navigator2027.start.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\LC2RedirectOutput.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\uninst.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\app\\sqlite\\SQLite3.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\jextract\\runtime\\bin\\java.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\jextract\\runtime\\bin\\javaw.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\jextract\\runtime\\bin\\keytool.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2aiagent\\app.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2apache\\lc2apache.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\LC2CRC32\\LC2CRC.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\LC2CRC32\\LC2CRC32CLI.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2crud\\lc2crud.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2dirmarkup\\lc2dirmarkup.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2dl-cli\\lc2dl.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\LC2EncrypDecrypt\\LC2Encryp.Decrypt.CLI.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\LC2EncrypDecrypt\\LC2Encryp.Decrypt.Main.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2extract-cli\\lc2extract-cli.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2gitreadme\\lc2gitreadme.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2import_json2sqlite\\lc2import_json2sqlite.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2indexpc\\lc2indexpc.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2ircclient\\lc2ircclient.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2json2xml2json\\lc2csv_xslt_to_json.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2json2xml2json\\lc2dirmarkup.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2json2xml2json\\lc2json2xml2json.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2licensing_server\\lc2licensing_server.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2memory\\lc2memory.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2nav2026\\lc2nav2026.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2nav2026\\bin\\lc2nav2026.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2replaceinfile\\lc2replaceinfile.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2runasadmin\\lc2mysql.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2runasadmin\\lc2patcher.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2runasadmin\\lc2runasadmin.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2sfv\\lc2dirmarkup.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2sfv\\lc2sfv.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2sfv\\lc2sfv_v1_0.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\LC2ShortCutCLI\\LC2ShortCutCLI.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2sqlite\\lc2sqlite.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2streamripper\\lc2streamripper.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2ttfps\\lc2ttfps.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2webllm\\lc2indexpc.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2webllm\\lc2webllm.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2ytdl\\lc2ytdl.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\lc2ytdl\\yt-dlp.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\app\\yt-dlp\\yt-dlp.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\resources\\app\\sqlite\\SQLite3.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\resources\\plugins\\lc2container\\dbgpClient.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\resources\\plugins\\LC2ShortCutCLI\\app\\LC2ShortCutCLI\\LC2ShortCutCLI.exe",
//     "D:\\tools\\LETZTECHANCE.ORG\\LC2Navigator2027\\resources\\_app\\sqlite\\SQLite3.exe"
// ];

// function getFileName(path) {
//     return path.split('\\').pop();
// }

// function renderCards(filter = '') {
//     const grid = document.getElementById('exeGrid');
//     grid.innerHTML = '';

//     const filtered = executables.filter(exe =>
//         getFileName(exe).toLowerCase().includes(filter.toLowerCase()) ||
//         exe.toLowerCase().includes(filter.toLowerCase())
//     );

//     filtered.forEach(exe => {
//         const name = getFileName(exe);
//         const card = document.createElement('div');
//         card.className = 'col-md-3 col-sm-4 col-6 mb-4';
//         card.innerHTML = `
//           <div class="card exe-card shadow-sm" onclick="runExe('${exe}')">
//             <div class="card-body text-center">
//               <div class="exe-icon"><i class="fas fa-file-code"></i></div>
//               <h5 class="card-title">${name}</h5>
//               <p class="card-text text-truncate">${exe}</p>
//             </div>
//           </div>
//         `;
//         grid.appendChild(card);
//     });
// }

// function runExe(exePath) {
//     // Use the provided redirect_cmd pattern from the original file
//     // The user mentioned 'exec.bat start lc2sqliteeditor.exe' in their attempt
//     // Since we want to execute 'all other executables', we should use the path.
//     // The original file used javascript:redirect_cmd('exec.bat start lc2sqliteeditor.exe');
//     // I'll assume redirect_cmd is defined globally or similar.
//     // I'll use a safer way to call it if it's available.

//     const cmd = `exec.bat "${exePath}"`;
//     console.log('Running:', cmd);

//     if (typeof redirect_cmd === 'function') {
//         redirect_cmd(cmd);
//     } else {
//         // Fallback if redirect_cmd is not defined (it seems to be a custom function provided by the environment)
//         window.location.href = `javascript:redirect_cmd('${cmd}')`;
//     }
// }

// document.getElementById('searchBar').addEventListener('input', (e) => {
//     renderCards(e.target.value);
// });
// // Initial render
// renderCards();
// // Mocking redirect_cmd for the demo if it doesn't exist, 
// // but in the real environment it should be provided.
// if (typeof redirect_cmd !== 'function') {
//     window.redirect_cmd = function (cmd) {
//         alert('Executing: ' + cmd + '\\n(This would call the redirect_cmd in the actual environment)');
//     };
// }