const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const secret = "Lumihiriv0";

describe("Map-app database API test", () => {
  const jwtToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiU2Foa29wb3N0aSI6InRlc3RAZ21haWwuY29tIiwiaWF0IjoxNjc2MDM1NDIyfQ.UptAF_RccRC7d52zxv0J50MVUu53MVlh9LYL1f5luRY";
  const headers = {
    "Content-Type": "application/json",
    Authorization: `Bearer ${jwtToken}`,
  };
  const wrongAuthHeader = {
    "Content-Type": "application/json",
    Authorization: "Bearer test",
  };
  // User path
  const allUserPath = "api/user/all";
  const userPath = "api/user";
  const loginUserPath = "api/user/login";

  describe("Test user API", () => {
    describe("Test with wrong authorization", () => {
      it(`GET ${allUserPath} should return 401 unauthorized`, () => {
        cy.request({
          method: "GET",
          url: allUserPath,
          failOnStatusCode: false,
          headers: wrongAuthHeader,
        }).then((response) => {
          expect(response.status).to.eq(401);
          expect(response.body).to.equal("Unauthorized");
        });
      });

      it(`POST ${userPath} should return 401 unauthorized`, () => {
        cy.request({
          method: "POST",
          url: userPath,
          failOnStatusCode: false,
          headers: wrongAuthHeader,
        }).then((response) => {
          expect(response.status).to.eq(401);
          expect(response.body).to.equal("Unauthorized");
        });
      });

      it(`PUT ${userPath} should return 401 unauthorized`, () => {
        cy.request({
          method: "PUT",
          url: userPath,
          failOnStatusCode: false,
          headers: wrongAuthHeader,
        }).then((response) => {
          expect(response.status).to.eq(401);
          expect(response.body).to.equal("Unauthorized");
        });
      });

      it(`DELETE ${userPath} should return 401 unauthorized`, () => {
        cy.request({
          method: "DELETE",
          url: userPath,
          failOnStatusCode: false,
          headers: wrongAuthHeader,
        }).then((response) => {
          expect(response.status).to.eq(401);
          expect(response.body).to.equal("Unauthorized");
        });
      });
    });

    describe("Test invalid request params/body", () => {
      it(`GET ${userPath}/1000000 should return a list of 0 user`, () => {
        cy.request({
          method: "GET",
          url: `${userPath}/1000000`,
          headers: headers,
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.be.an("array").to.have.lengthOf(0);
        });
      });

      it(`POST ${userPath} should return error object`, () => {
        cy.request({
          method: "POST",
          url: userPath,
          headers: headers,
          body: {
            Salasana: "hello",
          },
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.be.an("object");
          expect(response.body).to.have.property("errors");
          const errors = response.body.errors;
          expect(errors).to.be.an("array").to.have.lengthOf(4);

          const emailError = errors[0];
          expect(emailError)
            .to.have.property("msg")
            .to.equal("Ei toimiva shäköposti");
          expect(emailError).to.have.property("param").to.equal("Sähköposti");
          expect(emailError).to.have.property("location").to.equal("body");

          const firstNameError = errors[1];
          expect(firstNameError)
            .to.have.property("msg")
            .to.equal("Puuttuva etunimi");
          expect(firstNameError).to.have.property("param").to.equal("Etunimi");
          expect(firstNameError).to.have.property("location").to.equal("body");

          const lastNameError = errors[2];
          expect(lastNameError)
            .to.have.property("msg")
            .to.equal("Puuttuva sukunimi");
          expect(lastNameError).to.have.property("param").to.equal("Sukunimi");
          expect(lastNameError).to.have.property("location").to.equal("body");

          const passwordError = errors[3];
          expect(passwordError)
            .to.have.property("msg")
            .to.equal("Salasanan oltava vähintään 7 merkkiä");
          expect(passwordError).to.have.property("param").to.equal("Salasana");
          expect(passwordError).to.have.property("location").to.equal("body");
        });
      });

      it(`PUT ${userPath}/1000000 should return no field change in database`, () => {
        cy.request({
          method: "PUT",
          url: `${userPath}/1000000`,
          headers,
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.be.an("object");
          expect(response.body).to.have.property("fieldCount").to.equal(0);
          expect(response.body).to.have.property("affectedRows").to.equal(0);
          expect(response.body).to.have.property("insertId").to.equal(0);
          expect(response.body)
            .to.have.property("info")
            .to.equal("Rows matched: 0  Changed: 0  Warnings: 0");
          expect(response.body).to.have.property("serverStatus").to.equal(2);
          expect(response.body).to.have.property("warningStatus").to.equal(0);
          expect(response.body).to.have.property("changedRows").to.equal(0);
        });
      });

      it(`DELETE ${userPath}/1000000 should return 200 Poistettavaa ei löytynyt`, () => {
        cy.request({
          method: "DELETE",
          url: `${userPath}/1000000`,
          headers,
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.equal("Poistettavaa ei löytynyt");
        });
      });

      it(`POST ${loginUserPath} should return 200 no user found`, () => {
        cy.request({
          method: "POST",
          url: loginUserPath,
          headers: wrongAuthHeader,
          body: {
            Sähköposti: "ajfhasuohaww0412041234",
            Salasana: "password1",
          },
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.equal("No User Found");
        });
      });

      it(`POST ${loginUserPath} should return 200 incorrect password`, () => {
        cy.request({
          method: "POST",
          url: loginUserPath,
          headers: wrongAuthHeader,
          body: {
            Sähköposti: "admin@gmail.com",
            Salasana: "asfs123412sgas",
          },
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.equal("incorrect password");
        });
      });
    });

    describe("Test normal functionalities", () => {
      const cypressTestUser = {
        Etunimi: "testCypress",
        Sukunimi: "lastName",
        Sähköposti: "testCypress@gmail.com",
        Salasana: "password",
        Rooli: "operator",
      };

      const cypressPutUser = {
        Etunimi: "testCypressPut",
        Sukunimi: "lastNameCypress",
        Sähköposti: "testCypressPut@gmail.com",
        Salasana: "cypress",
        Rooli: "admin",
      };

      it(`GET ${allUserPath} should return a list of users`, () => {
        cy.request({
          method: "GET",
          url: allUserPath,
          headers: headers,
        }).then((response) => {
          cy.wrap(response.body)
            .should("be.an", "array")
            .and("to.have.lengthOf.at.least", 4)
            .each((user) => {
              expect(user).to.have.property("ID").to.be.a("number");
              expect(user).to.have.property("Etunimi").to.be.a("String");
              expect(user).to.have.property("Sukunimi").to.be.a("String");
              expect(user).to.have.property("Rooli").to.be.a("String");
              expect(user).to.have.property("Sähköposti").to.be.a("String");
              expect(user).to.have.property("Salasana").to.be.a("String");
            });
        });
      });

      it(`GET ${userPath} should return a list of 1 user`, () => {
        cy.request({
          method: "GET",
          url: `${allUserPath}`,
          headers: headers,
        }).then((response) => {
          const cypressGetUserID = response.body[response.body.length - 1].ID;
          cy.request({
            method: "GET",
            url: `${userPath}/${cypressGetUserID}`,
            headers: headers,
          }).then((response) => {
            expect(response.body).to.be.an("array").to.have.lengthOf(1);
            const cypressGetUser = response.body[0];
            expect(cypressGetUser).to.have.property("ID");
            expect(cypressGetUser).to.have.property("Etunimi");
            expect(cypressGetUser).to.have.property("Sukunimi");
            expect(cypressGetUser).to.have.property("Sähköposti");
            expect(cypressGetUser).to.have.property("Rooli");
            expect(cypressGetUser).to.have.property("Salasana");
          });
        });
      });

      it(`POST ${userPath} should return Insert was succesfull`, () => {
        cy.request({
          method: "POST",
          url: `${userPath}`,
          body: cypressTestUser,
          headers: headers,
        }).then((response) => {
          expect(response.status).to.eq(200);
          expect(response.body).to.equal("Insert was succesfull");
        });
      });

      it(`PUT ${userPath} should return update information`, () => {
        cy.request({
          method: "GET",
          url: `${allUserPath}`,
          headers: headers,
        }).then((response) => {
          const cypressGetUser = response.body[response.body.length - 1];
          const passwordMatch = bcrypt.compareSync(
            cypressTestUser.Salasana,
            cypressGetUser.Salasana
          );
          expect(passwordMatch).to.be.true;
          expect(cypressGetUser).to.have.property("ID");
          expect(cypressGetUser)
            .to.have.property("Etunimi")
            .to.equal(cypressTestUser.Etunimi);
          expect(cypressGetUser)
            .to.have.property("Sukunimi")
            .to.equal(cypressTestUser.Sukunimi);
          expect(cypressGetUser)
            .to.have.property("Sähköposti")
            .to.equal(cypressTestUser.Sähköposti);
          expect(cypressGetUser)
            .to.have.property("Rooli")
            .to.equal(cypressTestUser.Rooli);

          cy.request({
            method: "PUT",
            url: `${userPath}/${cypressGetUser.ID}`,
            body: cypressPutUser,
            headers: headers,
          }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body).to.have.property("fieldCount").to.equal(0);
            expect(response.body).to.have.property("affectedRows").to.equal(1);
            expect(response.body).to.have.property("insertId").to.equal(0);
            expect(response.body)
              .to.have.property("info")
              .to.equal("Rows matched: 1  Changed: 1  Warnings: 0");
            expect(response.body).to.have.property("serverStatus").to.equal(2);
            expect(response.body).to.have.property("warningStatus").to.equal(0);
            expect(response.body).to.have.property("changedRows").to.equal(1);
          });
        });
      });

      it(`DELETE ${userPath} should return delete information`, () => {
        cy.request({
          method: "GET",
          url: `${allUserPath}`,
          headers: headers,
        }).then((response) => {
          const cypressCurrentUser = response.body[response.body.length - 1];

          expect(cypressCurrentUser).to.have.property("ID");
          expect(cypressCurrentUser)
            .to.have.property("Etunimi")
            .to.equal(cypressPutUser.Etunimi);
          expect(cypressCurrentUser)
            .to.have.property("Sukunimi")
            .to.equal(cypressPutUser.Sukunimi);
          expect(cypressCurrentUser)
            .to.have.property("Sähköposti")
            .to.equal(cypressPutUser.Sähköposti);
          // because the credential should not change
          expect(cypressCurrentUser)
            .to.have.property("Rooli")
            .to.equal(cypressTestUser.Rooli);
          expect(cypressCurrentUser).to.have.property("Salasana");

          cy.request({
            method: "DELETE",
            url: `${userPath}/${cypressCurrentUser.ID}`,
            headers: headers,
          }).then((response) => {
            expect(response.status).to.eq(200);
            expect(response.body).to.have.property("fieldCount").to.equal(0);
            expect(response.body).to.have.property("affectedRows").to.equal(1);
            expect(response.body).to.have.property("insertId").to.equal(0);
            expect(response.body).to.have.property("info").to.equal("");
            expect(response.body).to.have.property("serverStatus").to.equal(2);
            expect(response.body).to.have.property("warningStatus").to.equal(0);
          });
        });
      });

      it(`POST ${loginUserPath} should login user, return user info`, () => {
        cy.request({
          method: "POST",
          url: loginUserPath,
          headers: wrongAuthHeader,
          body: {
            Sähköposti: "admin@gmail.com",
            Salasana: "admin",
          },
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.be.an("object");
          expect(response.body).to.have.property("token").to.be.a("string");
          const decodedJWT = jwt.verify(response.body.token, secret);
          expect(decodedJWT).to.be.an("object");
          expect(decodedJWT).to.have.property("id");
          expect(decodedJWT)
            .to.have.property("Sahkoposti")
            .to.equal("admin@gmail.com");

          expect(response.body).to.have.property("user").to.be.an("object");
          expect(response.body.user)
            .to.have.property("Etunimi")
            .to.equal("admin");
          expect(response.body.user)
            .to.have.property("Sukunimi")
            .to.equal("admin");
          expect(response.body.user)
            .to.have.property("Rooli")
            .to.equal("admin");
          expect(response.body.user)
            .to.have.property("Sähköposti")
            .to.equal("admin@gmail.com");
        });
      });
    });
  });
});
