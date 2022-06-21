const fs = require('fs');
const QRCode = require('easyqrcodejs-nodejs');

// Options
var options = {
    text: "https://linweigao.github.io/guess/#/info",
    width: 900,
    height: 900,
    logo: "./images/icon2.png",
    // logoWidth: 150,
    // logoHeigth: 150,

    colorDark: "#0583d2",
    colorLight: "#ffffff",
    correctLevel: QRCode.CorrectLevel.H,

    quietZone: 50,
    quietZoneColor: "rgba(0,0,0,0)",

    dotScale: 0.5,
    dotScaleTiming_H: 0.5,
    dotScaleTiming_V: 0.5,

    dotScaleA: 1,
    dotScaleA: 0.5,
    dotScaleAO: 0.5,

    // timing: '#0583d2', // Global Timing color.

    PO_TL: '#0583d2', // Posotion Outer color - Top Left 
    PI_TL: '#fc8955', // Posotion Inner color - Top Left 
    PO_TR: '#fc8955', // Posotion Outer color - Top Right 
    PI_TR: '#0583d2', // Posotion Inner color - Top Right 
    PO_BL: '#fc8955', // Posotion Outer color - Bottom Left 
    PI_BL: '#0583d2', // Posotion Inner color - Bottom Left 

    AO: '#0583d2', // Alignment Outer.
    AI: '#0583d2', // Alignment Inner.
};

// New instance with options
var qrcode = new QRCode(options);

// Save QRCode image
qrcode.saveImage({
    path: 'assets/images/qrcode.png' // save path
});

fs.copyFileSync('assets/images/qrcode.png', 'assets/images/2.0x/qrcode.png', fs.constants.COPYFILE_FICLONE);
fs.copyFileSync('assets/images/qrcode.png', 'assets/images/3.0x/qrcode.png', fs.constants.COPYFILE_FICLONE);
