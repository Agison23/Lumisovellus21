import React, { useContext, useState} from 'react'
import BottomNav from '../../src/components/BottomNav'

// This is an example file with no actual tests
describe("<BottomNav />", () => {
  it("renders", () => {
    // see: https://on.cypress.io/mounting-react
    cy.mount(<BottomNav />);
  });
});
