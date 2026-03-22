const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');
const { promisify } = require('util');
const axios = require('axios');
const readFileAsync = promisify(fs.readFile);
const writeFileAsync = promisify(fs.writeFile);
const mkdirAsync = promisify(fs.mkdir);
const port = 3000;
const filesJsonPath = path.join(__dirname, 'files.json');
const downloadsDir = path.join(__dirname, 'downloads');
// Create the downloads directory if it doesn't exist
(async () => {
    try {
        await mkdirAsync(downloadsDir, { recursive: true });
        console.log('Downloads directory created or already exists');
    } catch (err) {
        console.error('Error creating downloads directory:', err);
    }
})();
const checkAndDownloadFiles = async () => {
    try {
        const filesData = await readFileAsync(filesJsonPath, 'utf8');
        const files = JSON.parse(filesData).files;
        for (const file of files) {
            const { url, targetPath } = file;
            // Check if the file already exists
            if (fs.existsSync(targetPath)) {
                console.log(`File already exists: ${targetPath}`);
                continue;
            }
            // Download the file
            const response = await axios({
                url,
                responseType: 'stream',
            });
            const writer = fs.createWriteStream(targetPath);
            response.data.pipe(writer);
            return new Promise((resolve, reject) => {
                writer.on('finish', resolve);
                writer.on('error', reject);
            });
        }
        console.log('All files checked and downloaded successfully');
    } catch (err) {
        console.error('Error checking and downloading files:', err);
    }
};
const server = http.createServer(async (req, res) => {
    const { pathname } = url.parse(req.url, true);
    if (pathname === '/check-files') {
        await checkAndDownloadFiles();
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('Files checked and downloaded');
    } else {
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('Not Found');
    }
});
server.listen(port, () => {
    console.log(`Server running at http://localhost:${port}/`);
});