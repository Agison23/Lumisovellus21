const mysql = require("mysql2");

//modify if database changes
const con = mysql.createConnection({
  host: "localhost",
  // Update this password to be the same as the one in the VM instance
  user: "pallas",
  password: "u9szFQcsGV",
  database: "pallas",
});

module.exports = con;
