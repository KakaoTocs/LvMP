const mongoose = require('mongoose');

var newID = mongoose.Schema({
  id: Number
});

module.exports = mongoose.model('newids', newID);
