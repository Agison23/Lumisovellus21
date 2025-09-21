describe("Test that the language changes in all pages", ()=>{

    //Mobile application tests
    it("user swithces languge to english before logging in and scrolls through almost every page. Then back to finish and same thing", ()=>{

      const email = "admin@gmail.com";
      const password = "admin";

        cy.visit("/");
        cy.get('[data-testid="languageDropDown"]',{value: /fi/i}).click();
        cy.findByText(/English/i).click();
        cy.findByRole("button", {  name: /openloginwindow/i}).click();
        cy.findByRole("textbox", {  name: /email/i}).type(email);
        cy.get('input').eq(2).type(password);
        cy.findByRole("button", { name: /log/i }).click();
        cy.wait(2000);

        
        cy.findByRole('button', {  name: /Definitions/i}).click();
        cy.contains(/Avalanche warning/i);
        cy.get('.snow_tab').scrollTo('bottom');
        cy.contains( /Saturated snow/i).should("be.visible");
        cy.contains( /Little snow/i).should("be.visible");
        cy.contains( /Slush/i).should("be.visible");
        cy.contains( /Wetting snow/i).should("be.visible");
        cy.contains( /New snow/i);
        cy.contains( /Powder snow/i);
        cy.contains( /Fresh wet snow/i);
        cy.contains( /Fresh snow/i);
        cy.contains( /Crust/i);
        cy.contains( /Concrete/i);
        cy.contains( /Thin crust/i);
        cy.contains( /Collapsing crust/i);
        cy.contains( /Windpacked snow/i);
        cy.contains( /Wavy snow/i);
        cy.contains( /Sastrug/i);
        cy.contains( /Windblown snow/i);
        cy.contains( /Brekable ice/i);
        cy.contains( /Ice/i);


        cy.findByRole('button', {  name: /weather/i}).click();
        cy.contains(/The day before yesterday/i).should("be.visible");
        cy.contains(/yesterday/i).should("be.visible");
        cy.contains(/now/i).should("be.visible");
        cy.contains( /Temperature/i).should("be.visible");
        cy.contains( /Depth Of snow/i).should("be.visible");
        cy.contains( /Wind/i).should("be.visible");
        cy.contains( /Air pressure/i).should("be.visible");



        cy.findByRole('button', {  name: /More info/i}).click();
        cy.contains( /Weather of the last few days/i).should("be.visible");
        cy.contains( /Winter's weather observationst/i).should("be.visible");
        cy.contains( /Wind/i).should("be.visible");
        cy.contains( /Temperature/i).should("be.visible");
        cy.contains( /pcs/i).should("be.visible");
        cy.contains( /TEMPERATURE DURING THREE DAYS/i).should("be.visible");
        cy.contains( /WIND DURING THREE DAYS/i).should("be.visible");
        cy.contains( /INCREASE IN SNOW DEPTH/i).should("be.visible");
        cy.findByRole('button', {  name: /back/i}).click();


        cy.findByRole('button', {  name: /manage/i},{timeout: 15000}).click();
        cy.contains(/segments/i).should("be.visible");
        cy.contains(/feedbacks/i).should("be.visible");
        cy.contains(/Add a subsegment/i).should("be.visible");
        cy.contains(/Add a parent segment/i).should("be.visible");
        cy.findByText(/users/i).should("be.visible").click();
        cy.contains(/Add an user/i).should("be.visible");



        cy.findByRole('button', {  name: /Map/i}).click();
        cy.findByText(/show only.../i).should("be.visible").click();
        cy.findByText(/Skiing areas only/i).should("be.visible");
        cy.findByText(/show only.../i).should("be.visible").click(); 

        cy.findByRole('button', {  name: /map/i}).click();
        cy.findByText(/show only.../i).should("be.visible").click();
        cy.findByText(/skiing areas only/i).should("be.visible").click();
    });


});
  
