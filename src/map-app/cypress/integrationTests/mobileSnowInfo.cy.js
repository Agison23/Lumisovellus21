

  // eslint-disable-next-line no-undef
describe("Snow information", () => {
  
      //Mobile tests
  
    // eslint-disable-next-line no-undef
    it("admin navigates to add new snow estimation",() => {
      const email = "admin@gmail.com";
      const password = "admin";
  
      cy.visit("/");
      cy.viewport('iphone-5');
      cy.findByRole('button', {  name: /tutustu lumitilanteeseen/i}).click();
      cy.findByRole("button", {  name: /openloginwindow/i}).click();
      cy.findByRole("textbox", {  name: /sähköposti/i}).type(email);
      cy.findByLabelText(/salasana/i).type(password);
      cy.findByRole("button", { name: /kirjaudu/i }).click();
      cy.findByRole("button", { name: /hallitse/i },{timeout: 15000}).should("be.visible");
      cy.wait(5000)
      cy.findByRole("region", {name: /Map/i}).click(200, 300);
      cy.findByRole("button", {  name: /päivitä/i}).click();
      cy.findByRole("button", {  name: /lisää/i}).click();
      cy.findByRole("option", {  name: /ensisijainen/i}).click();
      cy.findByRole("option", {  name: /Puuterilumi/i});

    });


    
    it("admin adds snow condition estimation and goes to check that estimation exists in feedbacks tab",() => {
  
      const email = "admin@gmail.com";
      const password = "admin";

        cy.visit('/');
        cy.viewport('iphone-5');
        cy.findByRole('button', {  name: /tutustu lumitilanteeseen/i}).click();
        cy.wait(5000);
        cy.findByRole("region", {name: /Map/i}).click(150, 300);
        cy.findByText(/kyllä, lisää/i).click();
        cy.wait(3000);
        cy.findByRole('button', {name: /märkää/i} ).click();
        cy.findByText( /lähetä/i ).click();
        cy.get('[placeholder="Kiitos palautteesta!"]').type("Hello world!");
        cy.findByText( />Lähetä/i ).click();
        cy.findByRole("button", {  name: /openloginwindow/i}).click();
        cy.findByRole("textbox", {  name: /sähköposti/i}).type(email);
        cy.findByLabelText(/salasana/i).type(password);
        cy.findByRole("button", { name: /kirjaudu/i }).click();
        cy.findByRole("button", { name: /hallitse/i },{timeout: 15000}).click();
        cy.findByText(/PALAUTTEET/i).should("be.visible").click();
        cy.contains(/Sohjo/i).should("be.visible");
        cy.contains(/Hello world!/i).should("be.visible");;
  
    });
  
  });

