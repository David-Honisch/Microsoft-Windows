var hostName = "http://localhost:5000";
var pluginName = "LC2ShortCutCLI";
const installDirectories = [
    'resources\\plugins\\lcwebclient_final',
    'resources\\plugins\\lcwebclient_final\\lcwebclient_final_lib',
    'resources\\plugins\\org.letztechance.domain.web.GrabUrls',
    'resources\\plugins\\org.letztechance.domain.web.GrabUrls\\org.letztechance.domain.web.GrabUrls_lib',

];
const rlibs = [
    'jquery',
    'https',
    'stream',
    'line-reader',
    'fs',
    'request',
    'runtime-npm-install',
    'decompress-zip',
    // 'extract-zip',
    'csv',
    'jszip',
    'sax',
    'xlsx',
    'xlsx-to-json',
    'xlsx-to-json-lc',
    'xml2js',
    'xmlbuilder',
    'xmldom',
    'xml-js',
    'xmljson'
];

var downloadUrls = [{
        path: "https://www.letztechance.org/LC2Intro.v.4.0/assets/",
        file: "lclogo.png",
    },
    {
        path: "https://raw.githubusercontent.com/David-Honisch/Microsoft-Windows/master/LC2Navigator2022/plugins/",
        file: "apache-maven.zip",
    },
    {
        path: "https://raw.githubusercontent.com/David-Honisch/Microsoft-Windows/master/LC2Navigator2022/plugins/",
        file: "apache-ant.zip",
    }

];