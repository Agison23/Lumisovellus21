import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import "./index.css";
import Pallas from "./Pallas";
import SnowTypes from "./SnowTypes";
import WeatherTab from "./weather/WeatherTab";
import WelcomeView from "./WelcomeView";
import MobileView from "./MobileView";
// import GlobalContext from "./context/GlobalContext";

function App() {
  //   const { language } = useContext(GlobalContext);
  return (
    <Router>
      <Routes>
        {/* <Route path="/" element={<Pallas language={language} />} />
        <Route path="/saa" element={<WeatherTab language={language} />} />
        <Route path="/selitteet" element={<SnowTypes language={language} />} />
        <Route
          path="/tietoasovelluksesta"
          element={<WelcomeView language={language} />}
        />
        <Route path="/mobiili" element={<MobileView language={language} />} /> */}

        <Route path="/" element={<Pallas language="fi" />} />
        <Route path="/en" element={<Pallas language="en" />} />
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
    </Router>
  );
}

export default App;
