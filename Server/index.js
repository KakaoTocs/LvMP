const express = require('express');
const app = express();
const server = require('http').Server(app);
var io = require('socket.io').listen(server);
var data = true;

app.get("/", (req, res) => {
  res.status(200).send("<h1>Server is running...</h1>");
})

server.listen(3000, () => {
  console.log('Server is running...');
});

io.on('connection', (socket) => {
  console.log("Socket connected: " + socket.id);
  io.emit('paringMac', data)
  io.emit('paringiPhone', data)

  socket.on("data", (data) => {
    console.log("Received data: " + data.count);
    io.emit("clientData", data);
  });

  socket.on("server_test", (data) => {
    console.log("Test success: " + data);
    socket.emit("client_test", "Hello Socket.io");
  });

  socket.on('disconnect', () => {
    console.log("Client disconnected: " + socket.id);
  });
});
