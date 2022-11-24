const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('cadiaz.online.key'),
  cert: fs.readFileSync('cadiaz.online.crt')
};

https.createServer(options, function (req, res) {
  res.writeHead(200);
  res.end("hello world\n");
}).listen(443);