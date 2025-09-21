///<reference types="cypress"/>

describe("Test that the value of 'language' actually changes when language is switched before logging in", () => {

  //Desktop
  it("User changes the language back and forth", ()=>{
    cy.visit("/");
    cy.get('[data-testid="languageDropDown"]',{value: /fi/i}).click();
    cy.get('[data-testid="fiButton"]').click();
    cy.contains(/Suomi/i).should("be.visible");
    cy.get('[data-testid="languageDropDown"]',{value: /fi/i}).click();
    cy.get('[data-testid="enButton"]').click();
    cy.get('[data-testid="languageDropDown"]',{value: /en/i});
  });    
});