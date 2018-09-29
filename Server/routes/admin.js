const express = require('express');
const router = express.Router();
const admin = require('./../models/admin');

module.exports = (db) => {

  router.post('/login', (req, res) => {
    admin.findOne({id: req.body.id}, (err, admins) => {
      if(err){
        console.log(">>Admin login: " + err);
        res.status(400).json({code: 400, message: "fail"});
      }else{
        if(admins == null) {
          console.log("Admin login: No ID");
          res.status(400).json({code: 400, message: "no id"});
        }else{
          if(admins.pw == req.body.pw){
            console.log("Admin login Succese");
            res.status(200).json({code: 200, message: "succese"});
          }else{
            console.log("Admin login: No PW");
            res.status(400).json({code: 400, message: "no pw"});
          }
        }
      }
    });
  });

  router.post('/create', (req, res) => {
    var newAdmin = new admin();
    newAdmin.id = req.body.id;
    newAdmin.pw = req.body.pw;

    newAdmin.save((err) => {
      if(err){
        console.log(">>New Admin create: " + err);
        res.status(400).json({code: 400, message: "fail"});
      }else{
        console.log('New Admin Inserted!');
        res.status(200).json({code: 200, message: "succese"});
      }
    });
  });

  router.post('/user/add', (req, res) => {
    admin.findOne({id: req.body.adminID}, (err, admins) => {
      if(err) {
        console.log(">>Add User to Admin: " + err);
        res.status(400).json({code: 400, message: "fail"});
      } else {
        if(admins == null) {
          console.log(">>Add User to Admin: No Admin ID");
          res.status(400).json({code: 400, message: "fail"});
        } else {
          var user = {
            id: req.body.userID,
            name: req.body.userName
          };
          // var list = ;
          // list.concat(user);
          admins.userList.push(user);
          // console.log(admins.userList);
          var query = {id: req.body.adminID};
          var operator = {id: admins.id, pw: admins.pw, userList: admins.userList};
          var option = {upsert: true};
          db.collection('admins').update(query, operator, option, (err, upserted) => {
            if(err) {
                console.log(">>Add User to Admin: " + err);
                res.status(400).json({code: 400, message: "fail"});
            } else {
              console.log("Add User to Admin: " + user);
              res.status(200).json({code: 200, message: "succese"});
            }
          });
        }
      }
    });
  });

  router.get('/user/list/:id', (req, res) => {
    admin.findOne({id: req.params.id}, (err, admins) => {
      if(err) {
        console.log(">>Admin in User list: " + err);
        res.status(400).json({code: 400, message: "fail"});
      } else {
        if(admins == null) {
          console.log("Admin in User list: No Admin ID");
          res.status(400).json({code: 400, message: "fail"});
        } else {
          console.log("Admin in User list: " + admins.userList);
          const result = {
            userList: admins.userList
          };
          res.status(200).json(result);
        }
      }
    });
  });

  return router;
};
