// function print_action(url_heise) {
//     console.log(url_heise);
// }

print_action('external script is running...');
// alert("test");
setTimeout(() => {
    try {
        const nav_home = document.getElementById("nav_home");
        const nav_homecnt = document.getElementById("nav_homecnt");
        const nav_news = document.getElementById("nav_news");
        const nav_newscnt = document.getElementById("nav_newscnt");
        const nav_download = document.getElementById("nav_downloads");
        const nav_downloadscnt = document.getElementById("nav_downloadscnt");
        const nav_imprint = document.getElementById("nav_imprint");
        const nav_imprintcnt = document.getElementById("nav_imprintcnt");
        const newsMessage = document.getElementById("newsMessage");
        const extnewsMessage = document.getElementById("extnewsMessage");
        // var url_heise = "https://www.letztechance.org/webservices/getcontent.php?ext_url=https://www.golem.de/";
        const url_list2 = "https://www.letztechance.org/webservices/getcontent.php?ext_url=https://www.letztechance.org/webservices/client.php?q=getListJSON&value1=1&value2=1";
        const url_list = "https://www.letztechance.org/webservices/client.php?q=getListJSON&value1=1&value2=1";
        const url_heise = "https://www.letztechance.org/webservices/getcontent.php?ext_url=https://www.letztechance.org/srss.html?query=https://www.heise.de/newsticker/heise.rdf";
        const url_golem = "https://www.letztechance.org/webservices/getcontent.php?ext_url=https://www.letztechance.org/srss.html?query=https://rss.golem.de/rss.php?feed=RSS0.91";
        generateHrefs(url_heise, newsMessage);
        generateHrefs(url_golem, extnewsMessage);
        add_to_menu();

    } catch (error) {
        console.error(error);
        alert(error);
        alert(error.stack);
        nav_newscnt.innerHTML += "<h1>ERROR:</h1>" + error + "";
    }

}, 5000);


async function getJsonData(api, id) {
    try {
        const response = await fetch(api);
        if (!response.ok) {
            document.getElementById(id).innerHTML = `HTTP-Fehler! Status: ${response.status}`;
            throw new Error(`HTTP-Fehler! Status: ${response.status}`);
        }
        const data = await response.json();
        document.getElementById(id).innerHTML += JSON.stringify(data);
    } catch (error) {
        console.error("Fehler beim Abrufen der Daten:", error);
        alert(error);
        document.getElementById(id).innerHTML = error;
    }
}
async function add_to_menu() {

    nav_homecnt.innerHTML = "";
    nav_newscnt.innerHTML = "";
    nav_downloadscnt.innerHTML = "";
    nav_imprintcnt.innerHTML = "";

    nav_home.innerHTML += "<li><a href=\"\">" + "About" + "</a></li>";

    nav_newscnt.innerHTML = "<h1>Loading:" + url_list + "</h1>";
    // getJsonData(url_list,"nav_news") 
    // alert("test");
    httpfetch("GET", url_list).then((response) => {
        console.log("fetching external url: " + url_list);
        nav_newscnt.innerHTML = "<h1>Init:" + url_list + "</h1>";
        var txt = response.text();
        nav_newscnt.innerHTML = "<h1>" + JSON.stringify(text) + "</h1>";
        for (var v in txt) {
            var item = text[v];
            nav_news.innerHTML += "<li><a href=\"#\">" + JSON.stringify(item) + "</a></li>";
        }
        nav_newscnt.innerHTML = "";
    }).catch((error) => {
        console.error(error);
        alert(error);
        nav_newscnt.innerHTML += "<h1>ERROR:</h1>" + error + "";
    });
    nav_homecnt.innerHTML = "";
    nav_newscnt.innerHTML = "";
    nav_downloadscnt.innerHTML = "";
    nav_imprintcnt.innerHTML = "";

}

function generateHrefs(url_heise, divout) {
    const urlHREFRegex = /<a href="([^"]*)">([^<]+)<\/a>/g;
    var urlRegex = /(https?:\/\/[^\s]+)/g;
    httpfetch('POST', url_heise, "url", url_heise).then((response) => {
        console.log("fetching external url: " + url_heise);
        var txt = response.text();
        return txt;
    }).then((text) => {
        // print_action("news successfully fetched from: " + url);
        try {
            if (text !== undefined) {
                var matches = extractUrlsFromHtml(text);
                // console.log(matches);
                var urls = [];
                for (var v in matches) {
                    var item = ("" + matches[v]).split("\">");
                    urls.push({
                        "url": (item[0]).replace(/<[^>]*>/g, ''),
                        "title": ("" + item[0]).replace(/<[^>]*>/g, ''),

                    });
                }
                // console.log("URLS:\n" + JSON.stringify(urls));
                var count = 0;
                var out = "<ul class=\"listul\">";
                for (var v in urls) {
                    var item = urls[v];
                    if (item.url !== undefined && item.url !== null && item.url.length > 5 && !item.url.includes(".jpeg") && !item.url.includes(".jpg") && !item.url.includes(".png")) {
                        out += "<li><a href=\"https://www.letztechance.org/openlink?" + item.url + "\" target=\"_blank\">" + item.url + "</a></li>";
                    }
                    count++;
                    if (count > 25)

                        break;
                }
                out += "</ul>";
                // console.log("URLS:\n" + out);
                divout.innerHTML += "<hr/>NEWS Links:<br/>" + out + "<hr/>";

                // alert(text);
            } else {
                alert("URL is not fetchable:", url);
                print_action("news NOT fetched from: " + url);
            }
        } catch (error) {
            console.error(error);
            alert(error);
        }
    });
    print_action('external script is done.');
}

function urlify(text) {
    var urlRegex = /(http?:\/\/[^\s]+)/g;
    //   return text.replace(urlRegex, function(url) {
    //     return '<a href="' + url + '">' + url + '</a>';
    //   })
    // or alternatively
    return ("" + text).replace(urlRegex, '<a href="$1">$1</a>')
}

function replace_urls(str) {
    let urls = ["https://www.letztechance.org"];
    let words = str.split(/\s+/); // Using a regex to split by whitespace    
    for (let word of words) {
        let url = null; // Initialize url to null
        try {
            let potentialUrl = new URL(word);
            url = potentialUrl.href;
            urls.push(urlify(url));
        } catch (e) {
            // If the word is not a valid URL, it will throw an error which we ignore
        }
    }
    return urls;
};
/**
 * Extracts URLs from an HTML string and returns an array of unique URLs.
 * Tries to use DOM parsing when available, falls back to attribute regex.
 *
 * @param {string} html - The HTML string to scan.
 * @param {Object} [opts] - Options.
 * @param {boolean} [opts.includeMailto=false] - If true, include mailto: links.
 * @returns {string[]} Array of unique URL strings (order preserved).
 */
function extractUrlsFromHtml(html, { includeMailto = false } = {}) {
    if (!html || typeof html !== "string") return [];

    const urls = [];
    const seen = new Set();

    function push(u) {
        if (!u) return;
        const s = String(u).trim();
        if (!s) return;
        if (!includeMailto && s.toLowerCase().startsWith("mailto:")) return;
        if (!seen.has(s)) {
            seen.add(s);
            urls.push(s);
        }
    }

    // Prefer DOM parsing when available (browser/webview)
    try {
        if (typeof DOMParser !== "undefined") {
            const doc = new DOMParser().parseFromString(html, "text/html");
            // common attributes that contain URLs
            const attrSelectors = [
                "a[href]",
                "area[href]",
                "link[href]",
                "img[src]",
                "script[src]",
                "iframe[src]",
                "source[src]",
                "video[src]",
                "audio[src]",
            ].join(",");
            const nodes = doc.querySelectorAll(attrSelectors);
            nodes.forEach((node) => {
                const href = node.getAttribute("href");
                const src = node.getAttribute("src");
                push(href || src);
            });

            // also capture srcset attribute values (multiple comma-separated urls)
            const srcsetNodes = doc.querySelectorAll("[srcset]");
            srcsetNodes.forEach((n) => {
                const ss = n.getAttribute("srcset");
                if (!ss) return;
                ss.split(",").forEach(part => {
                    const u = part.trim().split(/\s+/)[0];
                    push(u);
                });
            });

            return urls;
        }
    } catch (e) {
        // fall through to regex fallback
    }

    // Fallback: attribute regex (works in non-DOM environments)
    const attrRegex = /(?:href|src|data-src|data-href|srcset)\s*=\s*(['"])(.*?)\1/gi;
    let m;
    while ((m = attrRegex.exec(html)) !== null) {
        const attr = m[2].trim();
        if (!attr) continue;
        if (m[0].toLowerCase().includes("srcset")) {
            // srcset may contain multiple urls separated by commas
            attr.split(",").forEach(part => {
                const u = part.trim().split(/\s+/)[0];
                push(u);
            });
        } else {
            push(attr);
        }
    }

    // Extra pass: plain http/https urls in text nodes
    const plainUrlRegex = /https?:\/\/[^\s"'<>]+/gi;
    while ((m = plainUrlRegex.exec(html)) !== null) {
        push(m[0]);
    }

    return urls;
}
// Example usage: const text = '<a href="https://www.example.com">Example</a> <a href="https://www.google.com">Google</a>'; 
// const urlRegex = /<a href="([^"]*)">([^<]+)<\/a>/g; const urls = extractUrls(text); const html = generateHtml(urls); const generatedUrlLink = generateUrlLink(text, urlRegex); console.log(generatedUrlLink);
function extractUrls(text) {
    const urlRegex = /<a href="([^"]*)">([^<]+)<\/a>/g;
    const urls = [];
    let match;
    while ((match = urlRegex.exec(text)) !== null) { urls.push({ url: match[1], label: match[2] }); }
    return urls;
}

function generateHtml(urls) { let html = ''; for (const url of urls) { html += `<a href="${url.url}">${url.label}</a> `; } return html.trim(); }

function generateUrlLink(text, urlRegex) { const urls = extractUrls(text); const html = generateHtml(urls); return html; }