/**
API kutsut käyttäjälle

Päivityshistoria
Arttu Lakkala 15.11 Lisätty segmentit delete
Arttu Lakkala 22.11 Lisätty segmentit muutos
Arttu Lakkala 25.11 Lisätty segmentit lisäys
Arttu Lakkala 1.12  Rollback lisätty segmentin muutokseen
Arttu Lakkala 5.12 Rollback lisätty segmentin lisäykseen
Arttu Lakkala 5.12 uudelleennimettiin api.js
Arttu Lakkala 4.01 Poistettiin mahdollisuus poistaa admin
Arttu Lakkala 12.01 Siirrettiin käyttäjän teko tänne salasanatarkistuksen taakse
-----------------------------------------
Arttu Lakkala 6.12 Refactoroitiin API:sta

*/

const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const database = require("./database");

const saltRounds = 15;
//const secret = "Lumihiriv0";
//alusta tarkistus
const { body, validationResult } = require("express-validator");

//kaikkien käyttäjien haku
router.get("/all", function (req, res) {
  database.query("SELECT * FROM users", function (err, result) {
    if (err) throw err;
    res.json(result);
    res.status(200);
  });
});

//yhden käyttäjän haku
router.get("/", function (req, res) {
  database.query(
    "SELECT * FROM users WHERE id = ?",
    [req.decoded.id],
    function (err, result) {
      if (err) throw err;
      res.json(result);
      res.status(200);
    }
  );
});

//käyttäjän teko
router.post(
  "/",
  [
    // tarkista sähköposti
    body("email").isEmail().withMessage("Not a working email"),

    body("firstName").exists().withMessage("Missing first name"),
    body("surname").exists().withMessage("Missing surname"),

    // tarkista salasanan pituus
    body("password")
      .isLength({ min: 7 })
      .withMessage("Password has to be atleast 7 characters long"),
  ],
  function (req, res) {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      res.json({ errors: errors.array() });
      res.status(400);
    } else {
      //salataan salasana
      database.beginTransaction(function (err) {
        if (err) throw err;
        bcrypt.hash(req.body.Salasana, saltRounds, function (err, hash) {
          database.query(
            "INSERT INTO users(firstName, surname, email, password, role) VALUES(?, ?, ?, ?, ?)",
            [
              req.body.firstName,
              req.body.surname,
              req.body.email,
              hash,
              req.body.role ? req.body.role : "operator",
            ],
            function (err) {
              if (err) {
                database.rollback(function () {
                  throw err;
                });
              }
              database.commit(function (err) {
                if (err) {
                  database.rollback(function () {
                    throw err;
                  });
                }
                res.json("Insert was succesfull");
                res.status(204);
              });
            }
          );
        });
      });
    }
  }
);

router.put("/:id", function (req, res) {
  if (req.body.password) {
    bcrypt.hash(req.body.password, saltRounds, function (err, hash) {
      database.query(
        `UPDATE users
       SET 
       firstName=?,
       surname=?,
       email=?,
       password=?
       WHERE id = ?
      `,
        [
          req.body.firstName,
          req.body.surname,
          req.body.email,
          hash,
          req.params.id,
        ],
        function (err, result) {
          if (err) throw err;
          res.json(result);
          res.status(200);
        }
      );
    });
  } else {
    database.query(
      `UPDATE users
      SET 
      firstName=?,
      surname=?,
      email=?
      WHERE id = ?
    `,
      [req.body.firstName, req.body.surname, req.body.email, req.params.id],
      function (err, result) {
        if (err) throw err;
        res.json(result);
        res.status(200);
      }
    );
  }
});

router.delete("/:id", function (req, res) {
  database.query(
    `SELECT * FROM users
   WHERE id = ?
  `,
    [req.params.id],
    function (err, result) {
      if (err) throw err;
      console.log(result.length);
      if (result.length < 1) {
        res.end("Nothing to delete found");
        res.status(404);
      } else if (result[0].Rooli == "admin") {
        res.end("can't delete admin");
        res.status(401);
      } else {
        database.query(
          `DELETE FROM users
         WHERE id = ?
        `,
          [req.params.id],
          function (err, result) {
            if (err) throw err;
            res.json(result);
            res.status(200);
          }
        );
      }
    }
  );
});

module.exports = router;
