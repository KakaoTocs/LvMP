const io = require('socket.io-client');

const socket = io("http://127.0.0.1:3000");
// const socket = io('http://localhost');

socket.on('connect', () => {
  console.log("Socket connected:", socket.connected);

  socket.emit('server_test', "HelloWorld");
});

socket.on('client_test', (data) => {
  console.log("Test success: " + data);
});
