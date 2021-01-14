var http = require('http');
var fs = require('fs')
//var wantfile = 	'var healthfoods = require("./proofOfConcept")' + "\r\n" + 'module.exports = {Want: [healthfoods.Apple,healthfoods.Banana]}'
//fs.writeFile('want.js', 
//wantfile, function (err) {
//  	if (err) throw err;
//  console.log('Saved!');
//});
//console.log(wanted.Want[1])
/*var requested = "";
var i
for (i = 0; i < wanted.Want.length; i++) {
requested += wanted.Want[i] + "\r\n"
}
console.log(requested)
*/
function getFilesizeInBytes(filename) {
    var stats = fs.statSync(filename)
    var fileSizeInBytes = stats["size"]
    return fileSizeInBytes
}
var bigFile = getFilesizeInBytes('foodinfo.txt');
var bigFileInt = bigFile

http.createServer(function (req, res) {
fs.readFile('foodinfo.txt', function(err, data) {
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write(data + bigFile);
    return res.end();
  });
}).listen(8080);
//var timeWait = setInterval(fileChange, 1000)
var bigFile = getFilesizeInBytes('want.js');
var bigFileInt = bigFile
var requested = "";
function fileChange() {
bigFile = getFilesizeInBytes('want.js');


for (const path in require.cache) {
   if (path.endsWith('.js')) { // only clear *.js, not *.node
      delete require.cache[path]
    }
}


//if (bigFileInt != bigFile) {
console.log("File changed!")
var wanted = require('./want')
requested = ""
var i
for (i = 0; i < wanted.Want.length; i++) {
requested += wanted.Want[i] + "\r\n"
//}
fs.writeFile('foodinfo.txt', 
requested, function (err) {
  	if (err) throw err;
  console.log('Saved!');
});
console.log(requested)
bigFileInt = bigFile
}
console.log(bigFile)
}
fileChange();
