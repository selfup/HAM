const express = require('express'),
      http = require('http'),
      clri = require('clri'),
      bodyParser = require('body-parser')
      app = express(),
      server = http.createServer(app)
      port = 5000
      ip = '0.0.0.0'

app.use(bodyParser.urlencoded({ extended: true }))

app.post('/', (req, res) => {
  const payload = req.headers.payload
  clri.exec(`cd ~/HAM && python dial.py ${payload}`)
  res.send('GOT IT - RUNNING GPIO SCRIPT')
})

server.listen(port, ip, () => {
 console.log(`PORT ${port}, IP ${ip}`)
})
