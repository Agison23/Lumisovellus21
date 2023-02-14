// React automatically created file

import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import "./styles/index.css";
import App from "./pages/Pallas";
import reportWebVitals from "./reportWebVitals";
import SnowTypes from "./pages/SnowTypes";
import WeatherTab from "./weather/WeatherTab";
import WelcomeView from "./pages/WelcomeView";
import MobileView from "./pages/MobileView";

ReactDOM.render(
  <Router>
    <Routes>
      <Route path="/" element={<App language="fi" />} />
      <Route path="/en" element={<App language="en" />} />
      <Route path="/saa" element={<WeatherTab language="fi" />} />
      <Route path="/saa-en" element={<WeatherTab language="en" />} />
      <Route path="/selitteet" element={<SnowTypes language="fi" />} />
      <Route path="/selitteet-en" element={<SnowTypes language="en" />} />
      <Route
        path="/tietoasovelluksesta"
        element={<WelcomeView language="fi" />}
      />
      <Route
        path="/tietoasovelluksesta-en"
        element={<WelcomeView language="en" />}
      />
      <Route path="/mobiili" element={<MobileView language="fi" />} />
      <Route path="/mobiili-en" element={<MobileView language="en" />} />
    </Routes>
  </Router>,
  document.getElementById("root")
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
