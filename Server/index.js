const express = require('express');
const app = express();
const server = require('http').Server(app);
var io = require('socket.io').listen(server);
const fs = require('fs');
const path = require('path');
const bodyParser = require('body-parser');
const multer = require('multer');
const upload = multer({
  storage: multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
      cb(null, file.originalname);
    }
  }),
  limits: { fieldSize: 100 * 1024 *1024}
});
// const multiparty = require('multiparty');

// app.use(bodyParser.json());
app.use(bodyParser.json({limit: '500mb'}) );
app.use(bodyParser.urlencoded({
  limit: '500mb',
  extended: true,
  parameterLimit:50000
}));

var data = true;
var filesData;
var typesData;

var connectTable = ["", ""];

app.get("/", (req, res) => {
  res.status(200).send("<h1>Server is running...</h1>");
});

app.post("/test", (req, res) => {
  console.log(req.body.item);
  res.status(200).json({code: 200, message: "Success"});
});

app.post("/uploadFiles", upload.array('files'), (req, res) => {
  filesData = req.files;
  typesData = req.body.types;
  // console.log(req.files);
  // console.log(req.body.types);
  console.log("Received data count: " + filesData.length);
  io.emit("uploadReady", "");
  const result = {
    code: 200,
    message: "Good"
  };
  res.status(200).json(result);
});

var directoryPath = path.join(__dirname, '/uploads');
app.get("/receiveFiles", (req, res) => {
  var files = [];
  fs.readdir(directoryPath, (err, result) => {
    if (err) {
      return console.log("Unable to scan directory: " + err);
    }
    console.log("Sending files...");
    result.forEach((file) => {
      console.log(file);
      var temp = fs.readFileSync(directoryPath + "/" + file);
      files.push(temp);
    });
    const JSONData = {
      files: files,
      types: typesData
    };
    console.log("Send Data count: " + files.length);
    res.status(200).json(JSONData);
  });
});

// app.post("")

server.listen(3000, () => {
  console.log('Server is running...');
});

io.on('connection', (socket) => {
  socket.emit("kind", "");

  socket.on("kind", (data) => {
    connectTable[data] = socket.id;
    if(data == 0) {
      console.log("Mac connected: %s", socket.id);
    } else if(data == 1) {
      console.log("iPhone connected: %s", socket.id);
    } else {
      console.log("Error connected: %s", socket.id);
    }
    if(connectTable[0] != "" && connectTable[1] != "") {
      io.emit("paring", true);
    } else {
      io.emit("paring", false);
    }
  });

  socket.on("data", (data) => {
    console.log("Received data: " + data[0].count);
    io.emit("clientData", data);
  });

  socket.on("server_test", (data) => {
    console.log("Test success: " + data);
    socket.emit("client_test", "Hello Socket.io");
  });

  socket.on('disconnect', () => {
    if(connectTable[0] == socket.id) {
      connectTable[0] = "";
      console.log("Mac disconnected: " + socket.id);
    } else if(connectTable[1] == socket.id) {
      connectTable[1] = "";
      console.log("iPhone disconnected: " + socket.id);
    } else {
      console.log("Error disconnected: " + socket.id);
    }

    if(connectTable[0] != "" && connectTable[1] != "") {
      io.emit("paring", true);
    } else {
      io.emit("paring", false);
    }
  });
});
