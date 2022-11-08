const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('contoso.com.key'),
  cert: fs.readFileSync('contoso.com.crt')
};

https.createServer(options, function (req, res) {
  res.writeHead(200);
  res.end("hello world\n");
}).listen(443);