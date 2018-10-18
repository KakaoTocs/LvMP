const express = require('express');
const app = express();
const server = require('http').Server(app);
var io = require('socket.io').listen(server);
const bodyParser = require('body-parser');

// 초기 설정
app.use(bodyParser.json({limit: '500mb'}) );
app.use(bodyParser.urlencoded({
  limit: '500mb',
  extended: true,
  parameterLimit:50000
}));

// 프로퍼티
var filesData;
var typesData;
var connectTable = ["", ""];
const result = {
  code: 200,
  message: "Good"
};

// 서버작동 확인용
app.get("/", (req, res) => {
  res.status(200).send("<h1>Server is running...</h1>");
});

// Mac -> Server로 파일 전송
// app.post("/uploadFiles", upload.array('files'), (req, res) => {
app.post("/uploadFiles", (req, res) => {
  filesData = req.body.files;
  typesData = req.body.types;
  io.emit("uploadReady", "");
  console.log("Upload Finishi");
  res.status(200).json(result);
});

// iPhone -> Server로 파일 요청
app.get("/receiveFiles", (req, res) => {
    console.log("Download Finishi");
    res.status(200).json({files: filesData, types: typesData});
});

// 서버 실행
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
