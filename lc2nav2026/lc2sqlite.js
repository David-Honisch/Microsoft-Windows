print_action('external script is running...');

const RSS_PROXY = "https://www.letztechance.org/webservices/getcontent.php?ext_url=";
const RSS_VIEWER = "https://www.letztechance.org/srss.html?query=";
const createNEWUI = (url, title) => {
    const webview = new WebviewWindow('unique-label', {
        url: url,
        title: title,
        width: 600,
        height: 400,
    });

    webview.once('tauri://created', () => {
        console.log('Window successfully created');
    });
};
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
        var feeds = (typeof window.__news_api === 'undefined' || !Array.isArray(window.__news_api))
            ? []
            : window.__news_api;

        if (feeds.length === 0) {
            console.warn('lc2sqlite.js: window.__news_api is empty or not set');
            return;
        }

        var newsMessage = document.getElementById("newsMessage");
        var extnewsMessage = document.getElementById("extnewsMessage");

        // Inject placeholder <pre> elements for feeds that target #newsMessage
        var inlineFeeds = feeds.filter(function (f) { return !f.target; });
        if (inlineFeeds.length > 0 && newsMessage) {
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
                return;
            }
            _generateHrefs(url, outEl);
            if (feed.marquee) {
                addCssCLS(feed.id, "marquee");
            }
        });

    } catch (error) {
        console.error('lc2sqlite.js init error:', error);
    }
}, 5000);

/**
 * Fetch HTML from a proxied URL and render links into divout.
 * @param {string} url
 * @param {HTMLElement} divout
 * @param {number} [maxItems=25]
 */
function _generateHrefs(url, divout, maxItems) {
    if (!divout) return;
    maxItems = maxItems || 25;

    fetchHtml(url)
        .then(function (response) {
            console.log("fetching external url: " + url);
            var txt = response && response.html ? response.html : response;
            print_generateHrefs(txt, divout, maxItems);
        })
        .catch(function (error) {
            console.error("Error fetching HTML:", error);
            divout.appendChild(document.createTextNode("Error: " + error));
        });
}

/**
 * Parse fetched HTML, extract links, and append a <ul> to divout.
 * @param {string} text
 * @param {HTMLElement} divout
 * @param {number} [maxItems=25]
 */
function print_generateHrefs(text, divout, maxItems) {
    maxItems = maxItems || 25;
    try {
        var matches = parseHtmlAndExtractUrls(text);
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
            var li = document.createElement("li");
            var a = document.createElement("a");
            a.href = item.url;
            a.target = "_blank";
            a.textContent = item.innerHtml;
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

/**
 * Parse an HTML string and return [{url, innerHtml}] for every <a> found.
 * @param {string} html
 * @returns {Array<{url:string, innerHtml:string}>}
 */
function parseHtmlAndExtractUrls(html) {
    var parser = new DOMParser();
    var doc = parser.parseFromString(html, 'text/html');
    var links = doc.querySelectorAll('a');
    var result = [];
    links.forEach(function (link) {
        result.push({ url: link.href, innerHtml: link.textContent });
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
