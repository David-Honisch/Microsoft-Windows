function doUnzip(link, target) {
    console.log('Extract' + link);
    // alert('Extract' + link);
    var DecompressZip = require('decompress-zip');
    // for (var v in links) {
    var ZIP_FILE_PATH = link;
    var DESTINATION_PATH = target;
    var unzipper = new DecompressZip(ZIP_FILE_PATH);

    // Add the error event listener
    unzipper.on('error', function(err) {
        console.log('Caught an error' + link, err);
        document.getElementById("appcnt").innerHTML += 'Caught an error' + link + '' + err;
    });

    // Notify when everything is extracted
    unzipper.on('extract', function(log) {
        console.log('Finished extracting', log);
        document.getElementById("appcnt").innerHTML += 'Finished extracting' + log;
    });

    // Notify "progress" of the decompressed files
    unzipper.on('progress', function(fileIndex, fileCount) {
        console.log('Extracted file ' + (fileIndex + 1) + ' of ' + fileCount);
        document.getElementById("appcnt").innerHTML += '<br>Extracted file ' + (fileIndex + 1) + ' of ' + fileCount;
    });

    // Start extraction of the content
    unzipper.extract({
        path: DESTINATION_PATH
            // You can filter the files that you want to unpack using the filter option
            //filter: function (file) {
            //console.log(file);
            //return file.type !== "SymbolicLink";
            //}
    });
    // }

}

function InstallModules(tmpDir) {
    try {
        const { npmImportAsync, npmInstallAsync } = require('runtime-npm-install');
        npmInstallAsync(rlibs, tmpDir)
            .then(function() {
                document.getElementById('modcnt').innerHTML += '<h1>Successfully Installed to:</h1>' + tmpDir + '<br>';
                document.getElementById('modcnt').innerHTML += '<h2>Done. Close window now and start main plugin.</h2>';

            });
        printDir(path.join(tmpDir, 'node_modules'));
    } catch (error) {
        alert(error);
    }
}

function createDir(dir) {
    const fs = window.nodeRequire('fs');
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir);
    }
}

function printDir(dir_path) {
    const path = require('path');
    const fs = require('fs');
    console.log('DIR:' + dir_path);
    fs.readdir(dir_path, function(err, files) {
        //handling error
        if (err) {
            return console.log('Unable to find or open the directory: ' + err);
        }
        //Print the array of images at one go
        // console.log(files);
        //listing all files using forEach
        files.forEach(function(file) {
            var isValid = false;
            console.log(file);
            document.getElementById("modcnt").innerHTML += "<br>" + file;
            for (v in rlibs) {
                if (file.includes(v)) {
                    isValid = true;
                }
            }
            if (isValid) {
                document.getElementById("modcnt").innerHTML += "<br>" + file + " <strong>found</strong>.";
            }
        });
    });
}

function doDownload(links, target) {
    // console.log("Target:" + target);
    for (var v in links) {
        getDownloadFile(links[v].path, links[v].file, target + links[v].file, target);
        // downloadAppBinaries(links[v].path, links[v].file, target);
        // bulkDownloadAppBinaries(links, target);
    }
}

function getDownloadFile(baseUrl, link, targetFile, target) {
    const https = window.nodeRequire('https');
    const { pipeline } = window.nodeRequire('stream');
    const fs = window.nodeRequire('fs');
    var url = baseUrl + link;

    const file = fs.createWriteStream(targetFile);

    https.get(url, response => {
        pipeline(
            response,
            file,
            err => {
                if (err) {
                    console.error('Pipeline failed.', err);
                    alert('Pipeline failed.', err);
                } else {
                    // alert('Pipeline succeeded.');
                    console.log('Pipeline succeeded.');
                    document.getElementById("appcnt").innerHTML += "<br>" + url + " File succesfully downloaded";
                    if (('' + targetFile).includes('.zip'))
                        doUnzip(targetFile, target);
                }
            }
        );
    });
}

function getDownloadFileProgress(baseUrl, link, targetFile, target) {
    var request = window.nodeRequire('request');
    var fs = window.nodeRequire('fs');
    // Save variable to know progress
    var received_bytes = 0;
    var total_bytes = 0;
    var url = baseUrl + link;
    console.log('DL:' + url)
    var req = request({
        method: 'GET',
        uri: url
    });

    var out = fs.createWriteStream(targetFile);
    req.pipe(out);

    req.on('response', function(data) {
        // Change the total bytes value to get progress later.
        total_bytes = parseInt(data.headers['content-length']);
    });

    req.on('data', function(chunk) {
        // Update the received bytes
        received_bytes += chunk.length;

        showProgress(received_bytes, total_bytes);
    });

    req.on('end', function() {
        // alert("File succesfully downloaded");
        document.getElementById("appcnt").innerHTML += "<br>" + url + " File succesfully downloaded";
        document.getElementById("appcnt").innerHTML += "<br>" + targetFile + " File succesfully written.";
        document.getElementById("appcnt").innerHTML += "<br>Path:" + target + ".";
        if (('' + link).includes('.zip'))
            doUnzip(targetFile, target);
    });
}

function showProgress(received, total) {
    var percentage = (received * 100) / total;
    console.log(percentage + "% | " + received + " bytes out of " + total + " bytes.");
    document.getElementById("appcntprogress").innerHTML = percentage + "% | " + received + " bytes out of " + total + " bytes.";
}
try {
    document.getElementById("appcnt").innerHTML = "";
    document.getElementById("modcnt").innerHTML = "";
    for (var v in installDirectories) {
        createDir(installDirectories[v]);
    }
    var path = window.nodeRequire('path');
    var modDir = path.join(__dirname, '../../../resources/');
    InstallModules(modDir);
    var downloadDir = path.join(__dirname, '../../../');
    // InstallModules(targetDir);

    doDownload(downloadUrls, downloadDir);
    new HttpRequest().execCMD('.\\resources\\plugins\\graburls\\mvninstall.bat install', 'mvncnt');

    // doUnzip(downloadUrls, targetDir);
} catch (e) {
    alert(e.stack);
}
// try {
//     // updateApp(links);
//     const targetDir = path.join(__dirname, '../../../../');
//     // alert(targetDir + " <strong>found.</strong>.<br>");
//     //downloadAppBinaries(downloadUrls[0], targetDir);
//     downloadAppBinaries(downloadUrls[0], targetDir);
//     // bulkDownloadAppBinaries(downloadUrls, targetDir);
// } catch (error) {
//     alert(error.stack);
// }