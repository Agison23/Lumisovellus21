

describe("Map-app database API test", () => {

    //Snow quality path
    const snowQualitiesPath = "api/lumilaadut";

    describe("Test snow quality API",()=>{
        it(`GET ${snowQualitiesPath} should return all snow types`, ()=>{
            cy.request({
                method: "GET",
                url: snowQualitiesPath,
            }).then(response => {
                expect(response.body).to.be.an("array").to.have.lengthOf(21);
                cy.wrap(response.body)
                  .each(($element) =>{
                    cy.wrap($element).should("have.property", "ID").and("be.a", "number");
                    cy.wrap($element).should("have.property", "Nimi").and("be.a", "string");
                    cy.wrap($element).should("have.property", "Vari").and("be.a", "string");
                    cy.wrap($element).should("have.property", "Hiihdettavyys").should((value) => {
                      expect(value).to.satisfy((val) => val === null || !isNaN(val), "Value is not a number or null");
                    });            
                    cy.wrap($element).should("have.property", "Kategoria_ID").should((value) => {
                      expect(value).to.satisfy((val) => val === null || !isNaN(val), "Value is not a number or null");
                    });
                    cy.wrap($element).should("have.property", "Lumityyppi_selite").and("be.a", "string");
                  });
                });
        });
    });

});
  
