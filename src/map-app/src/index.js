// React automatically created file

import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import "./index.css";
import App from "./Pallas";
import reportWebVitals from "./reportWebVitals";
import SnowTypes from "./SnowTypes";
import WeatherTab from "./weather/WeatherTab";
import WelcomeView from "./WelcomeView";
import MobileView from "./MobileView";

ReactDOM.render(
  <Router>
    <Routes>
      <Route path="/" element={<App />} />
      <Route path="/saa" element={<WeatherTab />} />
      <Route path="/selitteet" element={<SnowTypes />} />
      <Route path="/tietoasovelluksesta" element={<WelcomeView />} />
      <Route path="/mobiili" element={<MobileView />} />
    </Routes>
  </Router>,
  document.getElementById("root")
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
