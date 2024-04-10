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
  //Segments path
  const allSegmentsPath = "api/segments";
  const segmentPath = "api/segment";
  const segmentUpdatesPath = "api/segments/update";

  describe("Test segment API", () => {
    describe("Test with wrong authorization", () => {
      it(`POST ${segmentPath} should return 401 unauthorized`, () => {
        cy.request({
          method: "POST",
          url: segmentPath,
          failOnStatusCode: false,
          headers: wrongAuthHeader,
        }).then((response) => {
          expect(response.status).to.eq(401);
          expect(response.body).to.equal("Unauthorized");
        });
      });

      it(`PUT ${segmentPath} should return 401 unauthorized`, () => {
        cy.request({
          method: "PUT",
          url: segmentPath,
          failOnStatusCode: false,
          headers: wrongAuthHeader,
        }).then((response) => {
          expect(response.status).to.eq(401);
          expect(response.body).to.equal("Unauthorized");
        });
      });

      it(`DELETE ${segmentPath} should return 401 unauthorized`, () => {
        cy.request({
          method: "DELETE",
          url: segmentPath,
          failOnStatusCode: false,
          headers: wrongAuthHeader,
        }).then((response) => {
          expect(response.status).to.eq(401);
          expect(response.body).to.equal("Unauthorized");
        });
      });
    });

    describe("Test invalid request params/body", () => {});

    describe("Test normal functionalities", () => {
      it(`GET ${segmentUpdatesPath} should return a list the put in segment update`, () => {
        cy.request({
          method: "GET",
          url: segmentUpdatesPath,
          headers: headers,
        }).then((response) => {
          cy.wrap(response.body)
            .should("be.an", "array")
            .and("to.have.lengthOf.at.least", 2)
            .each((segment) => {
              expect(segment).to.have.property("segment").to.be.a("number");
              expect(segment).to.have.property("time").to.be.a("string");
              const aika = new Date(segment.Aika);
              expect(aika instanceof Date).to.be.true;
              expect(segment).to.have.property("description");
              expect(segment).to.have.property("snowTypeId1");
              expect(segment).to.have.property("snowTypeId2");
              expect(segment).to.have.property("secondaryId1");
              expect(segment).to.have.property("secondaryId2");
              expect(segment).to.have.property("a1Time");
              expect(segment).to.have.property("a1SnowType");
              expect(segment).to.have.property("a1Details");
              expect(segment).to.have.property("a2Time");
              expect(segment).to.have.property("a2SnowType");
              expect(segment).to.have.property("a2Details");
              expect(segment).to.have.property("a3Time");
              expect(segment).to.have.property("a3SnowType");
              expect(segment).to.have.property("a3Details");
            });
        });
      });
      // this information took from the file Paivitykset.sql in th testSql folder of src/
      it(`GET ${segmentUpdatesPath}/5 should return a list the put in segment update`, () => {
        cy.request({
          method: "GET",
          url: `${segmentUpdatesPath}/5`,
          headers: headers,
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.be.an("array").to.have.lengthOf(1);

          expect(response.body).to.have.property("segment").to.equal(5);
          expect(response.body).to.have.property("time").to.be.a("string");
          const aika = new Date(response.body.Aika);
          expect(aika instanceof Date).to.be.true;
          expect(response.body)
            .to.have.property("description")
            .to.equal("comment test");
          expect(response.body).to.have.property("creator").to.be.a("number");
          expect(response.body).to.have.property("snowTypeId1").to.equal(1);
          expect(response.body).to.have.property("snowTypeId2").to.equal(2);
          expect(response.body)
            .to.have.property("secondaryId1")
            .to.equal(3);
          expect(response.body)
            .to.have.property("secondaryId2")
            .to.equal(4);
          expect(response.body).to.have.property("a1Time");
          expect(response.body).to.have.property("a1SnowType");
          expect(response.body).to.have.property("a1Details");
          expect(response.body).to.have.property("a2Time");
          expect(response.body).to.have.property("a2SnowType");
          expect(response.body).to.have.property("a2Details");
          expect(response.body).to.have.property("a3Time");
          expect(response.body).to.have.property("a3SnowType");
          expect(response.body).to.have.property("a3Details");
        });
      });

      it(`GET ${allSegmentsPath}`);
    });
  });
});
