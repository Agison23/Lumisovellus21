///<reference types="cypress"/>

describe("Login", () => {
  //Desktop
  it("Administrator login and get access to user managing tab", ()=>{
    const email = "admin@gmail.com";
    const password = "admin";

    cy.visit("/");
    cy.findByRole("button", {  name: /openloginwindow/i}).click();
    cy.findByRole("textbox", {  name: /sähköposti/i}).type(email);
    cy.findByLabelText(/salasana/i).type(password);
    cy.findByRole("button", { name: /kirjaudu/i }).click();
    cy.findByRole("button", { name: /hallitse/i }, { timeout: 15000 }).click();
    cy.findByRole("button", { name: /käyttäjät/i }).click();
    cy.findByText(/lisää käyttäjä/i).should("be.visible");
  });

  it("Operator login and doesn't have admin rights", ()=> {
    const email = "blank@gmail.com";
    const password = "operator";

    cy.visit("/");
    cy.findByRole("button", {  name: /openloginwindow/i}).click();
    cy.findByRole("textbox", {  name: /sähköposti/i}).type(email);
    cy.findByLabelText(/salasana/i).type(password);
    cy.findByRole("button", { name: /kirjaudu/i }).click();
    cy.findByRole("button", { name: /hallitse/i },{timeout: 15000}).click();
    cy.findByRole("button", {  name: /käyttäjät/i}).click();
    cy.findByText( /Käyttäjähallinta vaatii admin-oikeude/i).should("be.visible");
  });
});
