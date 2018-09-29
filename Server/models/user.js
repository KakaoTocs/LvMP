const mongoose = require('mongoose');

var user = mongoose.Schema({
  id: Number,
  logs: [{
    processId: Number,
    processName: String,
    time: String,
    action: Number,
    _type: Number
  }],
});

module.exports = mongoose.model('users', user);
