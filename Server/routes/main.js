const express = require('express');
const router = express.Router();

module.exports = (db, io) => {

  router.get("/", (req, res) => {
    res.status(200).json({test: "서버 열심히 일하고 있습니다."});
  });

  // const processSocket = io('/process', {forceNew: true});
  io.on('connection', (socket) => {

    data = {
      "id": 79,
      "processName": "크롬"
    };

    socket.on('conn', (data) => {
      console.log("-Socket Info: " + socket.id);
      console.log("-New Client: "+data);
    });

    socket.on('process/list', (data) => {
      console.log('processList: '+data);
      // var temp = {
      //   "id":data.id,
      //   "processId":data.processInfo[0].processId,
      //   "processName":data.processInfo[0].processName
      // };
      // console.log("kill- id: " + temp.id + " processId: " + temp.processId + " processName: " + temp.processName);
      // io.emit('process/kill', temp);
      io.emit('process/list', data);
    });

    socket.on('user/state/on', (data) => {
      console.log('userStateOn: '+data);
      io.emit('user/state/on', data);
    });

    socket.on('user/state/off', (data) => {
      console.log('userStateOff: '+data);
      io.emit('user/state/off', data);
    });

    socket.on('process/kill', (data) => {
      console.log("processKill");
      io.emit('process/kill', data);
    });

/*
    socket.on('hi', () => {
      console.log("C# Client connected");
    });

    socket.emit('direct', 'many client');
    socket.on('join', (data) => {
      socket.join(data.id);
      console.log("Join client");
      socket.in(data.id).emit('direct', 'one client');
    });
*/
    socket.on('disconnect', () => {
      console.log("-Client disconnected!");
      console.log("-Socket Info: " + socket.id);
    });
  });

  return router;
};
