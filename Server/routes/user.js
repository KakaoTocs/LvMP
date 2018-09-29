const express = require('express');
const router = express.Router();
const newID = require('./../models/newID');
const user = require('./../models/user');

module.exports = (db) => {
  // Client에서 사용할 ID 부여
  router.get('/new', (req, res) => {
    newID.find((err, ids) => {

      if(err) {
        console.log(">>newID: " + err);
        res.status(400).json({code: 400, message: "fail"});
      } else {
        var query = {id: ids[0].id};
        var operator = {id: ids[0].id + 1};
        var option = {upsert: true};
        db.collection('newids').update(query, operator, option, (err, upserted) => {
          if(err){
            console.log(">>newID Update: " + err);
            res.status(400).json({code: 400, message: "fail"});
          }else{
            console.log('give newID: ' + ids);
            const result = {
              id: ids[0].id
            };
            res.status(200).json(result);
          }
        });
      }
    });
  });

  router.post('/create', (req, res) => {
    var newUser = new user();
    newUser.id = req.body.id;

    newUser.save((err) => {
      if(err){
        console.log(">>new user create: "+err);
        res.status(400).json({code: 400, message: "fail"});
      }else{
        console.log('new user Inserted!');
        res.status(200).json({code: 200, message: "succese"});
      }
    });
  });

  router.get('/log/:id', (req, res) => {
    user.findOne({id: req.params.id}, (err, users) => {
      console.log(users);
      if(err){
        console.log(">>userLog: " + err);
        res.status(400).json({code: 400, message: "fail"});
      }else{
        if(users == null) {
          console.log("give user log: No User ID");
          res.status(400).json({code: 400, message: "fail"});
        } else {
          console.log('give user log: '+users);
          const result = {
            log: users.logs
          };
          res.status(200).json(result);
        }
      }
    });
  });

  router.post('/log/add', (req, res) => {
    user.findOne({id: req.body.id}, (err, users) => {
      if(err){
        console.log(">>userLog add: " + err);
        res.status(400).json({code: 400, message: "fail"});
      }else{
        if(users == null) {
          console.log("add user log: No User ID");
          res.status(400).json({code: 400, message: "fail"});
        } else {
          for(var i=0; i<req.body.logs.length; i++) {
            users.logs.push(req.body.logs[i]);
          }
          var query = {id: users.id};
          var operator = {id: users.id, logs: users.logs};
          var option = {upsert: true};
          db.collection('users').update(query, operator, option, (err, upserted) => {
            if(err) {
                console.log(">>Update User log: " + err);
                res.status(400).json({code: 400, message: "fail"});
            } else {
              console.log("Update User log:");
              for(var i=0; i<req.body.logs.length; i++) {
                console.log("id: "+req.body.logs[i].processId + " name: " + req.body.logs[i].processName + " time: " + req.body.logs[i].time + " action: " + req.body.logs[i].action + " _type: " + req.body.logs[i]._type);
              }
              res.status(200).json({code: 200, message: "succese"});
            }
          });
        }
      }
    });
  });

  return router;
};
