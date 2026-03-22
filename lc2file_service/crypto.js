const CryptoJS = require('crypto-js');
function encrypt(text, secretKey) {
    return CryptoJS.AES.encrypt(text, secretKey).toString();
}
function decrypt(text, secretKey) {
    const bytes = CryptoJS.AES.decrypt(text, secretKey);
    return bytes.toString(CryptoJS.enc.Utf8);
}
module.exports = { encrypt, decrypt };