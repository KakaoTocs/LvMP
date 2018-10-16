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
  limits: { fieldSize: 200 * 1024 *1024}
});
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
let uploadDirectoryPath = path.join(__dirname, '/uploads');

// 서버작동 확인용
app.get("/", (req, res) => {
  res.status(200).send("<h1>Server is running...</h1>");
});

// Mac -> Server로 파일 전송
app.post("/uploadFiles", upload.array('files'), (req, res) => {
  filesData = req.files;
  typesData = req.body.types;
  // console.log(req.files);
  // console.log(req.body.types);
  console.log("- Received data count: " + filesData.length);
  io.emit("uploadReady", "");
  const result = {
    code: 200,
    message: "Good"
  };
  res.status(200).json(result);
});

// iPhone -> Server로 파일 요청
app.get("/receiveFiles", (req, res) => {
  var filesTemp = [];
  fs.readdir(uploadDirectoryPath, (err, result) => {
    if (err) {
      return console.log("Unable to scan directory: " + err);
    }
    console.log("Sending files...");
    result.forEach((file) => {
      console.log(file);
      var temp = fs.readFileSync(uploadDirectoryPath + "/" + file);
      var temp1 = temp.toString('base64');
      console.log(temp1.length);
      // console.log(temp);
      // var file = JSON.parse(temp);
      filesTemp.push(temp1);
    });
    console.log(filesTemp.length);
    const JSONData = {
      files: filesTemp,
      types: typesData
    };
    console.log("- Send Data count: " + JSONData.files.length);
    res.status(200).json(JSONData);
  });
  console.log("Finsish");
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
