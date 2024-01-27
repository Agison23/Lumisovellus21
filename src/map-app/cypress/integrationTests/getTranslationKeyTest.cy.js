import getTranslationKey from "../../src/translations/getTranslationKey";

describe("Calling getTranslationKey", function () {
  it("testing getTranslationKey", function () {
    cy.wrap({ get: getTranslationKey })
      .invoke("get", "Uusi lumi")
      .should("eq", "newSnow");
    cy.wrap({ get: getTranslationKey })
      .invoke("get", "New snow", "en")
      .should("eq", "newSnow");
    cy.wrap({ get: getTranslationKey })
      .invoke("get", "Uusi lumi", "en")
      .should("eq", "error");
    cy.wrap({ get: getTranslationKey })
      .invoke("get", "uNkNoWnStRiNg")
      .should("eq", "error");
  });
});
