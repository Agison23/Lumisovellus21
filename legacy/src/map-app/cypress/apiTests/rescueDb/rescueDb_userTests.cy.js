const crypto = require("crypto");
//sha256.convert(utf8.encode(editedpassword1)).toString();
describe("Rescue database API test", () => {
  const adminPassword = "admin";
  const operatorPassword = "operator";
  // admin password hashed: 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
  // operator password hashed: 06e55b633481f7bb072957eabcf110c972e86691c3cfedabe088024bffe42f23
  const headersAdmin = {
    "Content-Type": "application/json",
    Authorization: `admin:${crypto
      .createHash("sha256")
      .update(Buffer.from(adminPassword, "utf8"))
      .digest("hex")}`,
  };
  const headersOperator = {
    "Content-Type": "application/json",
    Authorization: `operator:${crypto
      .createHash("sha256")
      .update(Buffer.from(operatorPassword, "utf8"))
      .digest("hex")}`,
  };

  const wrongAuthHeaderFormat = {
    "Content-Type": "application/json",
    Authorization: "Bearer test",
  };

  const wrongAuthHeaderInfo = {
    "Content-Type": "application/json",
    Authorization: "asdasfadgshfd3425/1af:test",
  };
  const getUsersPath = "/users";
  // const postUsersPath = "/register";
  // const putUserPath = "/modify";
  // const deleteUserPath = "/delete";
  before(() => {
    Cypress.config("baseUrl", "http://localhost:3002");
  });

  describe("Test user API", () => {
    describe("Test with wrong authorization", () => {
      it(`GET ${getUsersPath} with wrong Auth format, return 500 Internal Server Error`, () => {
        cy.request({
          method: "GET",
          url: getUsersPath,
          headers: wrongAuthHeaderFormat,
          failOnStatusCode: false,
        }).then((response) => {
          expect(response.status).to.equal(500);
        });
      });

      it(`GET ${getUsersPath} with right Auth format, return 401 Unauthorized`, () => {
        cy.request({
          method: "GET",
          url: getUsersPath,
          headers: wrongAuthHeaderInfo,
          failOnStatusCode: false,
        }).then((response) => {
          expect(response.status).to.equal(401);
          expect(response.body)
            .to.be.an("object")
            .to.have.property("message")
            .to.equal("Unauthorized");
        });
      });
    });

    describe("Test invalid request params/body", () => {});

    describe("Test normal functionalities", () => {
      it(`GET ${getUsersPath} with admin, return all users list`, () => {
        cy.request({
          method: "GET",
          url: getUsersPath,
          headers: headersAdmin,
          failOnStatusCode: false,
        }).then((response) => {
          expect(response.status).to.equal(200);
          cy.wrap(response.body)
            .should("be.an", "array")
            .and("to.have.lengthOf.at.least", 2)
            .each((user) => {
              expect(user).to.be.an("object");
              expect(user).to.have.property("is_admin").to.be.oneOf([0, 1]);
              expect(user).to.have.property("user_id").to.be.a("number");
              expect(user).to.have.property("username").to.be.a("string");
            });
        });
      });

      it(`GET ${getUsersPath} with operator, return list with that user`, () => {
        cy.request({
          method: "GET",
          url: getUsersPath,
          headers: headersOperator,
          failOnStatusCode: false,
        }).then((response) => {
          expect(response.status).to.equal(200);
          cy.wrap(response.body)
            .should("be.an", "array")
            .and("to.have.lengthOf", 1);
          expect(response.body[0]).to.be.an("object");
          const operator = response.body[0];
          expect(operator).to.have.property("is_admin").to.equal(0);
          expect(operator).to.have.property("user_id").to.equal(4);
          expect(operator).to.have.property("username").to.equal("operator");
        });
      });
    });
  });
});
