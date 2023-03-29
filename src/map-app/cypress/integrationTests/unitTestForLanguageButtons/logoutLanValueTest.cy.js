///<reference types="cypress"/>

describe("Test that the value of 'language' actually changes when language is switched after logging in", () => {

  //Desktop
  it("User logs in and changes the language back and forth", ()=>{
    const email = "admin@gmail.com";
    const password = "admin";

    cy.visit("/");
    cy.findByRole("button", {  name: /openloginwindow/i}).click();
    cy.findByRole("textbox", {  name: /sähköposti/i}).type(email);
    cy.findByLabelText(/salasana/i).type(password);
    cy.findByRole("button", { name: /kirjaudu/i }).click();
    cy.wait(5000);
    cy.get('[data-testid="languageDropDown2"]',{value: /fi/i}).click();
    cy.get('[data-testid="fiButton2"]').click();
    cy.contains(/Suomi/i).should("be.visible");
    cy.get('[data-testid="languageDropDown2"]',{value: /fi/i}).click();
    cy.get('[data-testid="enButton2"]').click();
    cy.get('[data-testid="languageDropDown2"]',{value: /en/i})
  });    
});