const express = require('express');
const app = express();
const server = require('http').Server(app);
var io = require('socket.io').listen(server);

app.get("/", (req, res) => {
  res.status(200).json({test: "Server is running like hard."});
})

io.on('connection', (socket) => {
  console.log("New Socket connected: " + socket.id);

  socket.on('input', (data) => {
    console.log("input: " + data);
  });

  socket.on('disconnect', () => {
    console.log("Client disconnected: " + socket.id);
  });
});

server.listen(80, () => {
  console.log('Server is running...');
});
