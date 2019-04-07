var hostName = "http://localhost:5000";

function utf8_encode(s) {
    return unescape(encodeURIComponent(s));
}

function utf8_decodee(s) {
    return decodeURIComponent(escape(s));
}

function utf8_decode(s) {
    var result;
    try {
        result = decodeURIComponent(escape(s));
    } catch (e) {
        // console.log(e);
    }
    result = (result !== null && result !== undefined && result.length > 0) ? result : s;
    return result;
}

function HttpRequest() {
    this.token = '';
    this.anonymous = "anonymous";
    this.NotLoggedInText = "Invalid login. Please try again with different credentials.<br/>Result:";
    this.url = hostName + '/';
}
HttpRequest.prototype.execCMD = function (text, id) {
    const {
        exec
    } = require('child_process');
    document.getElementById("error").innerHTML = "";
    document.getElementById(id).innerHTML = "<div class=\"preload\"></div>";
    // alert('OUT:'+text.length);
    exec('' + text, (err, stdout, stderr) => {
    
        if (err) {
            console.error(err);
            document.getElementById("error").innerHTML = "" + JSON.stringify(err);
            document.getElementById(id).innerHTML = "" + stdout;
            return;
        }
        console.log(stdout);
        document.getElementById(id).innerHTML = "" + stdout;
    });
}
HttpRequest.prototype.printHTML = function (id, text) {
    document.getElementById(id).innerHTML = text;
}
HttpRequest.prototype.getIndex = function () {
    var request = window.nodeRequire("request");
    var url = hostName + '/indextools';
    request({
        url: url,
        json: true
    }, function (error, response, body) {

        if (!error && response.statusCode === 200) {
            var result = '';
            for (var v in body) {
                var s = utf8_decode(body[v]);
                result += "<a href=\"#out\" onclick=\"new HttpRequest().execCMD('" + s + "','homecnt')\" target=\"_parent\">" + s + "</a><br/>";
            }
            document.getElementById("homeresult").innerHTML = "" + result;
        }
    })
}
HttpRequest.prototype.getCheck = function () {
    var request = window.nodeRequire("request");
    var url = hostName + '/check';
    request({
        url: url,
        json: true
    }, function (error, response, body) {

        if (!error && response.statusCode === 200) {
            var result = '';
            for (var v in body) {
                var s = utf8_decode(body[v]);
                if (s.includes("check") || s.includes("verify"))
                    result += "<a href=\"#checkcnt\" onclick=\"new HttpRequest().execCMD('" + s + "','checkcnt')\" target=\"_parent\">" + s + "</a><br/>";
            }
            document.getElementById("out").innerHTML = "" + result;
        }
    })
}
HttpRequest.prototype.getSearch = function () {
    var request = window.nodeRequire("request");
    var url = hostName + '/index';
    request({
        url: url,
        json: true
    }, function (error, response, body) {

        if (!error && response.statusCode === 200) {
            var result = '';
            for (var v in body[0]) {
                result += "<a href=\"#\" target=\"_blank\">" + utf8_decode(body[0][v]) + "</a><br/>";
            }
            document.getElementById("searchresult").innerHTML += "" + result;
        }
    })
}
HttpRequest.prototype.getTools = function () {
    var request = window.nodeRequire("request");
    var url = hostName + '/tools';
    request({
        url: url,
        json: true
    }, function (error, response, body) {

        if (!error && response.statusCode === 200) {
            var result = '';
            for (var v in body) {
                var s = utf8_decode(body[v]);
                result += "<a href=\"#toolscnt\" onclick=\"new HttpRequest().execCMD('" + s + "','toolscnt')\" target=\"_parent\">" + s + "</a><br/>";
                // result += "<a href=\"cmd " + s + "\" target=\"_blank\">" + s + "</a><br/>";
            }
            document.getElementById("toolsresult").innerHTML = "" + result;
        }
    })
}
HttpRequest.prototype.getImport = function () {
    var request = window.nodeRequire("request");
    var url = hostName + '/importtools';
    request({
        url: url,
        json: true
    }, function (error, response, body) {

        if (!error && response.statusCode === 200) {
            var result = '';
            for (var v in body) {
                var s = utf8_decode(body[v]);
                result += "<a href=\"#toolscontent\" onclick=\"new HttpRequest().execCMD('" + s + "','importcnt')\" target=\"_parent\">" + s + "</a><br/>";
            }
            document.getElementById("importresult").innerHTML = "" + result;
        }
    })
}
HttpRequest.prototype.getDocs = function () {
    var request = window.nodeRequire("request");
    var url = hostName + '/docs';
    request({
        url: url,
        json: true
    }, function (error, response, body) {

        if (!error && response.statusCode === 200) {
            var result = '';
            for (var v in body) {
                var s = utf8_decode(body[v]);
                result += "<a href=\"#toolscontent\" onclick=\"new HttpRequest().execCMD('" + s + "','toolscontent')\" target=\"_parent\">x</a>|";
                result += "<a href=\"#toolscontent\" onclick=\"new HttpRequest().execCMD('" + s + "','importcnt')\" target=\"_parent\">s</a>|";
                result += "<a href=\"javascript:alert('" + s + "');javascript:createChild('" + s + "');\" target=\"_blank\">" + s + "</a><br/>";
            }
            document.getElementById("docsresult").innerHTML = "" + result;
        }
    })
}
HttpRequest.prototype.getFaq = function () {
    var request = window.nodeRequire("request");
    var url = hostName + '/faq';
    request({
        url: url,
        json: true
    }, function (error, response, body) {

        if (!error && response.statusCode === 200) {
            var result = '';
            for (var v in body) {
                var s = utf8_decode(body[v]);
                result += "<a href=\"#faqcontent\" onclick=\"new HttpRequest().execCMD('" + s + "','faqcontent')\" target=\"_parent\">x</a>|";
                result += "<a href=\"#faqscontent\" onclick=\"new HttpRequest().execCMD('" + s + "','faqcnt')\" target=\"_parent\">s</a>|";
                result += "<a href=\"javascript:createChild('" + s + "');\" target=\"_blank\">" + s + "</a><br/>";
            }
            document.getElementById("faqresult").innerHTML = "" + result;
        }
    })
}
HttpRequest.prototype.extractHTML = function (id) {
    var request = window.nodeRequire("request");
    var url = hostName + '/';
    request({
        url: url,
        json: true
    }, function (error, response, body) {
        if (!error && response.statusCode === 200) {
            var Extrator = window.nodeRequire("html-extractor");
            var myExtrator = new Extrator();
            var result = '';
            myExtrator.extract(body, function (err, data) {
                if (err) {
                    throw (err)
                } else {
                    console.log(JSON.stringify(data));
                    document.getElementById(id).innerHTML = "" + utf8_decode(data.body);
                }
            });



        }
    })
}

function ifExists(obj) {
    return (obj !== "N/A" ? obj : "");
}

function toggle_visibility(className) {
    $('.' + className).toggle();
}