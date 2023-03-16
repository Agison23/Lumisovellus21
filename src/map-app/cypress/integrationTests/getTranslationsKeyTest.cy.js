import getTranslationsKey from "../../src/translations/gettranslationskey"

describe("Calling getTranslationdKey", function(){

    it("testing getTranslationsKey", function(){

        cy.wrap({get: getTranslationsKey}).invoke('get','Uusi lumi').should('eq','newSnow');
        cy.wrap({get: getTranslationsKey}).invoke('get','New snow','en').should('eq','newSnow');
        cy.wrap({get: getTranslationsKey}).invoke('get','Uusi lumi','en').should('eq','error');
        cy.wrap({get: getTranslationsKey}).invoke('get','uNkNoWnStRiNg').should('eq','error');
  });
});
  
