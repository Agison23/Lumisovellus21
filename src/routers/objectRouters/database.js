const mysql = require("mysql2");

//modify if database changes
const con = mysql.createConnection({
  host: "localhost",
  user: "pallas",
  // Update this password to be the same as the one in the VM instance
  password: "u9szFQcsGV",
  database: "pallas",
});

module.exports = con;
