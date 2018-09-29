const mongoose = require('mongoose');

var admin = mongoose.Schema({
  id: String,
  pw: String,
  userList: [{
    id: Number,
    name: String
  }]
});

module.exports = mongoose.model('admins', admin);
