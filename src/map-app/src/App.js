import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import "./index.css";
import Pallas from "./Pallas";
import SnowTypes from "./SnowTypes";
import WeatherTab from "./weather/WeatherTab";
import WelcomeView from "./WelcomeView";
import MobileView from "./MobileView";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Pallas />} />
        <Route path="/saa" element={<WeatherTab />} />
        <Route path="/selitteet" element={<SnowTypes />} />
        <Route path="/tietoasovelluksesta" element={<WelcomeView />} />
        <Route path="/mobiili" element={<MobileView />} />
      </Routes>
    </Router>
  );
}

export default App;
