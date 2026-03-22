const express = require('express');
const fs = require('fs');
const path = require('path');
const { files } = require('./config.json');
const router = express.Router();
router.get('/check', (req, res) => {
    const { filename } = req.query;
    const file = files.find(f => f.path === filename);
    if (!file) {
        return res.status(404).json({ message: 'File not found' });
    }
    if (fs.existsSync(file.path)) {
        res.json({ message: 'File exists', path: file.path });
    } else {
        res.json({ message: 'File does not exist', path: file.path });
    }
});
router.get('/download', (req, res) => {
    const { filename } = req.query;
    const file = files.find(f => f.path === filename);
    if (!file) {
        return res.status(404).json({ message: 'File not found' });
    }
    if (!fs.existsSync(file.path)) {
        // Simulate file download
        const targetPath = path.join(file.target, filename);
        fs.writeFileSync(targetPath, 'File content here');
        res.json({ message: 'File downloaded', path: targetPath });
    } else {
        res.json({ message: 'File already exists', path: file.path });
    }
});
module.exports = router;