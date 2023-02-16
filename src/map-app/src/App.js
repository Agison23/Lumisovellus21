import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import "./styles/index.css";
import Pallas from "./pages/Pallas";
import SnowTypes from "./pages/SnowTypes";
import WeatherTab from "./pages/WeatherTab";
import WelcomeView from "./pages/WelcomeView";
import MobileView from "./pages/MobileView";

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
