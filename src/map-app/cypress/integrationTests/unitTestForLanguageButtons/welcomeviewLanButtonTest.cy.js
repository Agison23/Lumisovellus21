describe("Test that the value of 'language' actually changes when language is switched in welcomeview", ()=>{

    //Mobile application tests
    it("user opens app with phone, changes language back and forth , and presses 'GET TO KNOW THE SNOW CONDITIONS' button", ()=>{

        cy.visit("/");
        cy.viewport('iphone-5');
        cy.get('[data-testid="languageDropDown3"]',{value: /fi/i}).click();
        cy.get('[data-testid="fiButton3"]').click();
        cy.contains(/Suomi/i).should("be.visible")
        cy.get('[data-testid="languageDropDown3"]',{value: /fi/i}).click();
        cy.get('[data-testid="enButton3"]').click();
        cy.get('[data-testid="languageDropDown3"]',{value: /en/i})
  });
});
  
