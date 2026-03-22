const express = require('express');
const bodyParser = require('body-parser');
const {port} = require('./config.json');
const authRouter = require('./auth');
const fileRouter = require('./file');
const app = express();
const PORT = port || 3000;
app.use(bodyParser.json());
app.use('/auth', authRouter);
app.use('/file', fileRouter);
app.listen(PORT, () => {
console.log(`Server is running on port ${PORT}`);
});