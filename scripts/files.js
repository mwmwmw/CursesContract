const fs = require('fs');


function writeFile(pathToFile, data) {
    let json = JSON.stringify(data);
    fs.writeFileSync(pathToFile, json);
}

function readFile(pathToFile) {
    let rawdata = fs.readFileSync(pathToFile);
    return JSON.parse(rawdata);
}

function copyFile(src, dest) {
    return new Promise((resolve, reject)=>{
        fs.copyFile(src, dest, fs.constants.COPYFILE_FICLONE_FORCE, resolve)
    })
}

module.exports = {
    writeFile, readFile, copyFile
}
