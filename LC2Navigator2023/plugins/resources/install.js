try {
    document.getElementById("appcnt").innerHTML = "";
    document.getElementById("modcnt").innerHTML = "";
    for (var v in installDirectories) {
        createDir(installDirectories[v]);
    }
    var opath = window.nodeRequire('path');
    var resDir = opath.join(__dirname, '../../resources/');
    var pluginDir = opath.join(__dirname, '../../resources/plugins/' + pluginName + '/');
    var downloadDir = opath.join(__dirname, '../../');
    console.log(resDir);
    console.log(pluginDir);
    console.log(downloadDir);
    InstallModules(resDir);


    doDownload(downloadUrls, pluginDir);
    execCMD('.\\resources\\plugins\\' + pluginName + '\\mvninstall.bat install', 'mvncnt');

    // doUnzip(downloadUrls, targetDir);
} catch (e) {
    alert(e.stack);
}