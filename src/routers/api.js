/**
API kutsut tietokannalle


Päivityshistoria
Arttu Lakkala 15.11 Lisätty segmentit delete
Arttu Lakkala 22.11 Lisätty segmentit muutos
Arttu Lakkala 25.11 Lisätty segmentit lisäys
Arttu Lakkala 1.12  Rollback lisätty segmentin muutokseen
Arttu Lakkala 5.12 Rollback lisätty segmentin lisäykseen
Arttu Lakkala 5.12 uudelleennimettiin api.js
Arttu Lakkala 6.12 Refactoroitiin object Routtereihin
Arttu Lakkala 12.01 Käyttäjän teko viety

*/
const express = require("express");
const router = express.Router();
const database = require("./objectRouters/database");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const users = require("./objectRouters/users");
const updates = require("./objectRouters/updates");
const segments = require("./objectRouters/segments");
// Init secrets
const saltRounds = 15;
const secret = "Lumihiriv0";
// Init validation
const { body, validationResult } = require("express-validator");

router.post("/user/login", function (req, res) {
  database.query(
    "SELECT * FROM users WHERE email = ?",
    [req.body.email],
    function (err, result) {
      if (err) throw err;
      if (result.length == 1) {
        let user = result[0];
        bcrypt.compare(req.body.password, user.password, function (err, login) {
          if (login) {
            jwt.sign(
              { id: user.id, email: user.email },
              secret,
              { algorithm: "HS256" },
              function (err, token) {
                res.json({
                  token: token,
                  user: {
                    firstName: user.firstName,
                    surname: user.surname,
                    id: user.id,
                    role: user.role,
                    email: user.email,
                  },
                });
                res.status(200);
              }
            );
          } else {
            res.json("incorrect password");
            res.status(401);
          }
        });
      } else {
        res.json("No User Found");
        res.status(401);
      }
    }
  );
});

router.get("/segments", function (req, res) {
  //get points from database
  database.query(
    "SELECT * FROM coordinates ORDER BY segment",
    function (err, points, fields) {
      if (err) throw err;
      //transfere needed data to array
      const coordsForSegments = points.map((item) => {
        item.location.lat = item.location.x;
        item.location.lng = item.location.y;
        delete item.location.x;
        delete item.location.y;
        return [item.segment, item.location];
      });

      database.query("SELECT * FROM segments", function (err, result) {
        let pointsDict = [];
        //create dictionary of arrays
        result.forEach((obj) => {
          pointsDict[obj.id] = [];
        });
        //Fill points to it
        coordsForSegments.forEach((obj) => {
          pointsDict[obj[0]].push(obj[1]);
        });
        //add arrays from dict to result as object properties
        result.forEach((obj) => {
          obj.Points = pointsDict[obj.id];
        });
        res.setHeader("Access-Control-Allow-Origin", "http://localhost:3002");
        res.json(result);
        res.status(200);
      });
    }
  );
});

router.get("/segments/update/:id", function (req, res) {
  database.query(
    `SELECT *
  FROM updates
  WHERE (segment, time)
  IN
  (SELECT segment, MAX(time)
    FROM updates
    WHERE segment = ?
    GROUP BY(segment)
   )
   ORDER BY(segment)`,
    [req.params.id],
    function (err, result, fields) {
      if (err) throw err;
      res.json(result);
      res.status(200);
    }
  );
});

router.get("/segments/update", function (req, res) {
  database.query(
    `SELECT P.segment, P.time, P.description, P.snowTypeId1, P.snowTypeId2, P.secondaryId1, P.secondaryId2, 
      a1.time AS a1Time, a1.snowType AS a1SnowType, a1.details AS a1Details,
      a2.time AS a2Time, a2.snowType AS a2SnowType, a2.details AS a2Details,
      a3.time AS a3Time, a3.snowType AS a3SnowType, a3.details AS a3Details
      FROM updates P
      LEFT JOIN userReviews a1 ON P.reviewId1 = a1.id
      LEFT JOIN userReviews a2 ON P.reviewId2 = a2.id
      LEFT JOIN userReviews a3 ON P.reviewId3 = a3.id
      WHERE (P.segment, P.time)
      IN
      (SELECT segment, MAX(time)
        FROM updates
        GROUP BY(segment)
       )
       AND P.time > NOW() - INTERVAL 3 DAY
       ORDER BY(P.segment);`,
    function (err, result, fields) {
      if (err) throw err;
      res.json(result);
      res.status(200);
    }
  );
});

router.get("/reviews", function (req, res) {
  database.query(
    `SELECT id, time, segment, snowType, details, comment
  FROM userReviews
  WHERE (segment, time)
  IN
  (SELECT segment, MAX(time)
    FROM userReviews
    GROUP BY(segment)
   )
   AND time > NOW() - INTERVAL 3 DAY
   ORDER BY(segment)`,
    function (err, result, fields) {
      if (err) throw err;
      res.json(result);
      res.status(200);
    }
  );
});

router.get("/allReviews", function (req, res) {
  database.query(
    `SELECT userReviews.time, userReviews.details, userReviews.snowType, userReviews.comment, snowTypes.name AS snow, segments.name AS segment
    FROM userReviews
    LEFT JOIN snowTypes ON userReviews.snowType=snowTypes.id
    LEFT JOIN segments ON userReviews.segment=segments.id
    WHERE time > NOW() - INTERVAL 1 WEEK
    ORDER BY (time) DESC`,
    function (err, result, fields) {
      if (err) throw err;
      res.json(result);
      res.status(200);
    }
  );
});

router.get("/lumilaadut", function (req, res) {
  database.query("Select * FROM snowTypes", function (err, result, fields) {
    if (err) throw err;
    res.json(result);
    res.status(200);
  });
});

router.post("/review/:id", function (req, res) {
  if (req.body.segment != req.params.id) {
    res.json("Segment id did not match any id in the database.");
    res.status(400);
  }
  database.query(
    "INSERT INTO userReviews(time, segment, snowType, details, comment) VALUES(NOW(), ?, ?, ?, ?)",
    [req.body.segment, req.body.snowType, req.body.details, req.body.comment],
    function (err) {
      if (err) throw err;

      database.query("SELECT LAST_INSERT_id()", function (err, result) {
        if (err) throw err;

        res.json(result);
        res.status(204);
      });
    }
  );
});

router.post("/updateReview/:id", function (req, res) {
  database.query(
    `UPDATE userReviews 
    SET comment = ?
    WHERE id = ? `,
    [req.body.comment, req.params.id],
    function (err, result) {
      if (err) throw err;
      res.json(result);
      res.status(200);
    }
  );
});

//password check
router.use(function (req, res, next) {
  if (req.headers.authorization) {
    if (req.headers.authorization.startsWith("Bearer ")) {
      var token = req.headers.authorization.slice(
        7,
        req.headers.authorization.length
      );
      jwt.verify(token, secret, function (err, decoded) {
        if (err) res.sendStatus(401);
        else {
          //if login succeeds log the data
          req.decoded = decoded;
          next();
        }
      });
    } else {
      res.sendStatus(401);
    }
  } else {
    res.sendStatus(401);
  }
});

router.use("/user/", users);
router.use("/segment/", segments);
router.use("/update/", updates);

module.exports = router;
