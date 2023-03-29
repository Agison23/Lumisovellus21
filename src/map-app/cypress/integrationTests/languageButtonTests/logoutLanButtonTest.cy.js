///<reference types="cypress"/>

describe("Test that the language changes in all pages", ()=>{

    //Mobile application tests
    it("user logs in and scrolls through almost every page. Then swithces languge to english and scrolls through almost every page", ()=>{

      const email = "admin@gmail.com";
      const password = "admin";

        cy.visit("/");
        cy.findByRole("button", {  name: /openloginwindow/i}).click();
        cy.findByRole("textbox", {  name: /sähköposti/i}).type(email);
        cy.get('input').eq(2).type(password);
        cy.findByRole("button", { name: /kirjaudu/i }).click();
        cy.wait(2000);


        cy.findByRole('button', {  name: /selitteet/i}).click();
        cy.contains(/lumivyöryvaroitus/i);
        cy.get('.snow_tab').scrollTo('bottom');
        cy.contains( /saturoitunut lumi/i).should("be.visible");
        cy.contains( /Vähäinen lumi/i);
        cy.contains( /Sohjo/i);
        cy.contains( /Kastuva lumi/i);
        cy.contains( /Uusi lumi/i);
        cy.contains( /Märkä uusi lumi/i);
        cy.contains( /Puuterilumi/i);
        cy.contains( /Vitilumi/i);
        cy.contains( /Korppu/i);
        cy.contains( /Kantava korppu/i);
        cy.contains( /Ohut korppu/i);
        cy.contains( /Rikkoutuva korppu/i);
        cy.contains( /Tuulen pieksemä lumi/i);
        cy.contains( /Aaltoileva lumi/i);
        cy.contains( /Sastrugi/i);
        cy.contains( /Tuiskulumi/i);
        cy.contains( /Rikkoutuva jää/i);
        cy.contains( /Jää/i);




        cy.findByRole('button', {  name: /sää/i}).click();
        cy.findByText(/toissapäivänä/i).should("be.visible");
        cy.findByText(/eilen/i).should("be.visible");
        cy.findByText(/nyt/i).should("be.visible");
        cy.contains( /Lämpötila/i).should("be.visible");
        cy.contains( /Lumen syvyys/i).should("be.visible");
        cy.contains( /Tuuli/i).should("be.visible");
        cy.contains( /Ilmanpaine/i).should("be.visible");



        cy.findByRole('button', {  name: /lisätietoja/i}).click();
        cy.contains( /lähipäivien sää/i).should("be.visible");
        cy.contains( /talven säähavainnot/i).should("be.visible");
        cy.contains( /Tuuli/i).should("be.visible");
        cy.contains( /Lämpötila/i).should("be.visible");
        cy.contains( /kpl/i).should("be.visible");
        cy.contains( /LÄMPÖTILA 3 VUOROKAUDEN AIKANA/i).should("be.visible");
        cy.contains( /TUULI 3 VUOROKAUDEN AIKANA/i).should("be.visible");
        cy.contains( /LUMENSYVYYDEN KASVU/i).should("be.visible");
        cy.findByRole('button', {  name: /takaisin/i}).click();


        cy.findByRole('button', {  name: /hallitse/i},{timeout: 15000}).click();
        cy.contains(/segmentit/i).should("be.visible");
        cy.contains(/palautteet/i).should("be.visible");
        cy.contains(/Lisää alasegmentti/i).should("be.visible");
        cy.contains(/Lisää uusi yläsegmentti/i).should("be.visible");
        cy.findByText(/käyttäjät/i).should("be.visible").click();
        cy.contains(/Lisää käyttäjä/i).should("be.visible");



        cy.findByRole('button', {  name: /kartta/i}).click();
        cy.findByText(/näytä ainoastaan.../i).should("be.visible").click();
        cy.findByText(/vain laskualueet/i).should("be.visible");
        cy.findByText(/näytä ainoastaan.../i).should("be.visible").click();        

        cy.get('[data-testid="languageDropDown2"]',{value: /fi/i}).click();
        cy.findByText(/English/i).click();

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
  
