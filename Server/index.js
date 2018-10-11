const express = require('express');
const app = express();
const server = require('http').Server(app);
var io = require('socket.io').listen(server);
const bodyParser = require('body-parser');

app.use(bodyParser.json());
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

app.post("/uploadFiles", (req, res) => {
  console.log("Get files");
  const data = req.body.data;
  console.log(data);
  var obj = JSON.parse(data);
  console.log(obj.types);
  console.log(obj)
  filesData = obj.files;
  typesData = obj.types;
  console.log(typesData);
  io.emit("uploadReady", "");
});

app.get("/receiveFiles", (req, res) => {
  const result = {
    files: filesData,
    types: typesData
  };
  res.status(200).json(result);
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
