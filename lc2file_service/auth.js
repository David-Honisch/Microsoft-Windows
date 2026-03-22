const express = require('express');
const jwt = require('jsonwebtoken');
const { users } = require('./users.json');
// const { SECRET_KEY } = require('./.env');
const  SECRET_KEY  = process.env.lc2file_service_secret_key
const { encrypt, decrypt } = require('./crypto');
const router = express.Router();
// console.log('SECRET_KEY:', SECRET_KEY);
console.log('SECRET_KEY:', process.env.lc2file_service_secret_key);
console.log('Loaded users:', users);
// Dummy function to simulate user authentication
router.post('/login', (req, res) => {
    console.log('Loaded users:', users);
    const { username, password } = req.body;
    console.log('searched user:', username);
    const user = users.users.find(u => u.username === username);
    console.log('user:', user);
    const pwd = decrypt(password, SECRET_KEY);
    console.log('pwd:', pwd);
    if (user && user.password === pwd) {
        const token = jwt.sign({ username: user.username }, SECRET_KEY, { expiresIn: '1h' });
        res.json({ token });
    } else {
        res.status(401).json({ message: 'Invalid credentials' });
    }
});
module.exports = router;