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
  // Reviews path
  const adminReviewUpdatePath = "api/update";
  const recentReviewsPath = "api/reviews";
  const allReviewsPath = "api/allReviews";
  const userReviewPath = "api/review";
  const userOtherObservationPath = "/api/updateReview";

  describe("Test reviews API", () => {
    describe("Test with wrong authorization", () => {
      it(`POST ${userOtherObservationPath} should return 401 unauthorized`, () => {
        cy.request({
          method: "POST",
          url: userOtherObservationPath,
          failOnStatusCode: false,
          headers: wrongAuthHeader,
        }).then((response) => {
          expect(response.status).to.eq(401);
          expect(response.body).to.equal("Unauthorized");
        });
      });

      it(`POST ${adminReviewUpdatePath} should return 401 unauthorized`, () => {
        cy.request({
          method: "POST",
          url: adminReviewUpdatePath,
          failOnStatusCode: false,
          headers: wrongAuthHeader,
        }).then((response) => {
          expect(response.status).to.eq(401);
          expect(response.body).to.equal("Unauthorized");
        });
      });

      it(`POST ${userReviewPath} should return 401 unauthorized`, () => {
        cy.request({
          method: "POST",
          url: userReviewPath,
          failOnStatusCode: false,
          headers: wrongAuthHeader,
        }).then((response) => {
          expect(response.status).to.eq(401);
          expect(response.body).to.equal("Unauthorized");
        });
      });
    });

    // doesn't work yet because bad error handling in api.js, only throw js error, didn't send back response cause server to crash
    describe.skip("Test invalid request params/body", () => {
      it(`POST ${userReviewPath}/10000 should return Segmentti numerot eivät täsmää`, () => {
        cy.request({
          method: "POST",
          url: `${userReviewPath}/10000`,
          headers: headers,
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.equal("Segmentti numerot eivät täsmää");
        });
      });

      it.skip(`POST ${userOtherObservationPath}/10000 should return database object with no change`, () => {
        cy.request({
          method: "POST",
          url: `${userOtherObservationPath}/10000`,
          headers: headers,
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

      it(`POST ${adminReviewUpdatePath}/10000 should return Segmentti numerot eivät täsmää`, () => {
        cy.request({
          method: "POST",
          url: `${adminReviewUpdatePath}/10000`,
          headers: headers,
        }).then((response) => {
          expect(response.body).to.equal("Segmentti numerot eivät täsmää");
          expect(response.status).to.equal(200);
        });
      });

      it(`POST ${adminReviewUpdatePath}/1 should return Segmentti numerot eivät täsmää because request param and body segment id mismatch`, () => {
        cy.request({
          method: "POST",
          url: `${adminReviewUpdatePath}/1`,
          headers: headers,
          body: {
            segment: 2,
          },
        }).then((response) => {
          expect(response.body).to.equal("Segmentti numerot eivät täsmää");
          expect(response.status).to.equal(200);
        });
      });
    });

    describe("Test normal functionalities", () => {
      it(`GET ${allReviewsPath} should return array of all reviews`, () => {
        cy.request({
          method: "GET",
          url: allReviewsPath,
        }).then((response) => {
          cy.wrap(response.body)
            .should("be.an", "array")
            .and("to.have.lengthOf.at.least", 2)
            .each((review) => {
              expect(review).to.have.property("time").to.be.a("string");
              const time = new Date(review.time);
              expect(time instanceof Date).to.be.true;
              expect(review).to.have.property("details");
              expect(review).to.have.property("snowType");
              expect(review).to.have.property("comment");
              expect(review).to.have.property("snow");
              expect(review).to.have.property("segment");
            });
        });
      });

      it(`GET ${recentReviewsPath} should return array of recent < 3days reviews`, () => {
        cy.request({
          method: "GET",
          url: recentReviewsPath,
        }).then((response) => {
          cy.wrap(response.body)
            .should("be.an", "array")
            .each((review) => {
              expect(review).to.have.property("time").to.be.a("string");
              const time = new Date(review.time);
              expect(time instanceof Date).to.be.true;
              expect(review).to.have.property("details");
              expect(review).to.have.property("snowType");
              expect(review).to.have.property("comment");
              expect(review).to.have.property("segment");
            });
        });
      });

      it(`POST ${userReviewPath}/1 should return object with LAST_INSERT_ID()`, () => {
        const body = {
          segment: "1",
          snowType: 1,
          details: 1,
          comment: "test",
        };
        cy.request({
          method: "POST",
          url: `${userReviewPath}/1`,
          headers: headers,
          body: body,
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.be.an("array").to.have.lengthOf(1);
          expect(response.body[0])
            .to.be.an("object")
            .to.have.property("LAST_INSERT_ID()")
            .to.be.a("number");
        });

        cy.request({
          method: "GET",
          url: recentReviewsPath,
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.be.an("array").to.have.lengthOf.at.least(1);
          const insertedReview = response.body[0];
          expect(insertedReview).to.have.property("time").to.be.a("string");
          const time = new Date(insertedReview.time);
          expect(time instanceof Date).to.be.true;
          expect(insertedReview)
            .to.have.property("details")
            .to.equal(body.details);
          expect(insertedReview)
            .to.have.property("snowType")
            .to.equal(body.snowType);
          expect(insertedReview)
            .to.have.property("comment")
            .to.equal(body.comment);
          expect(insertedReview)
            .to.have.property("segment")
            .to.equal(parseInt(body.segment));
        });
      });

      it(`POST ${userOtherObservationPath}/1 should return database object`, () => {
        const randomString = Cypress._.random(0, 1e9)
          .toString(36)
          .substr(0, 10);
        const body = {
          comment: randomString,
        };

        cy.request({
          method: "POST",
          url: `${userOtherObservationPath}/1`,
          headers: headers,
          body: body,
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.be.an("object");
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

        cy.request({
          method: "POST",
          url: `${userOtherObservationPath}/1`,
          headers: headers,
          body: body,
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.be.an("object");
          expect(response.body).to.have.property("fieldCount").to.equal(0);
          expect(response.body).to.have.property("affectedRows").to.equal(1);
          expect(response.body).to.have.property("insertId").to.equal(0);
          expect(response.body)
            .to.have.property("info")
            .to.equal("Rows matched: 1  Changed: 0  Warnings: 0");
          expect(response.body).to.have.property("serverStatus").to.equal(2);
          expect(response.body).to.have.property("warningStatus").to.equal(0);
          expect(response.body).to.have.property("changedRows").to.equal(0);
        });
      });

      it(`POST ${adminReviewUpdatePath}/1 should return Insert Was successful`, () => {
        const body = {
          segment: 1,
          description: "testing",
          snowTypeId1: 1,
          snowTypeId2: 2,
          secondaryId1: 3,
          secondaryId2: 4,
        };
        cy.request({
          method: "POST",
          url: `${adminReviewUpdatePath}/1`,
          headers: headers,
          body: body,
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.equal("Insert was succesfull");
        });
        cy.request({
          method: "GET",
          url: "api/segments/update",
        }).then((response) => {
          expect(response.status).to.equal(200);
          expect(response.body).to.be.an("array").to.have.lengthOf.at.least(1);
          expect(response.body[0]).to.be.an("object");
          const currentSegmentUpdate = response.body[0];
          expect(currentSegmentUpdate)
            .to.have.property("segment")
            .to.equal(body.segment);
          expect(currentSegmentUpdate)
            .to.have.property("time")
            .to.be.a("string");
          const time = new Date(currentSegmentUpdate.time);
          expect(time instanceof Date).to.be.true;
          expect(currentSegmentUpdate)
            .to.have.property("description")
            .to.equal(body.description);
          expect(currentSegmentUpdate)
            .to.have.property("snowTypeId1")
            .to.equal(body.snowTypeId1);
          expect(currentSegmentUpdate)
            .to.have.property("snowTypeId2")
            .to.equal(body.snowTypeId2);
          expect(currentSegmentUpdate)
            .to.have.property("secondaryId1")
            .to.equal(body.secondaryId1);
          expect(currentSegmentUpdate)
            .to.have.property("secondaryId2")
            .to.equal(body.secondaryId2);
          expect(currentSegmentUpdate).to.have.property("a1Time").to.be.null;
          expect(currentSegmentUpdate).to.have.property("a1SnowType").to.be
            .null;
          expect(currentSegmentUpdate).to.have.property("a1Details").to.be
            .null;
          expect(currentSegmentUpdate).to.have.property("a2Time").to.be.null;
          expect(currentSegmentUpdate).to.have.property("a2SnowType").to.be
            .null;
          expect(currentSegmentUpdate).to.have.property("a2Details").to.be
            .null;
          expect(currentSegmentUpdate).to.have.property("a3Time").to.be.null;
          expect(currentSegmentUpdate).to.have.property("a3SnowType").to.be
            .null;
          expect(currentSegmentUpdate).to.have.property("a3Details").to.be
            .null;
        });
      });
    });
  });
});
