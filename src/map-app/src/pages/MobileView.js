/**
Kopio Pallas.js filusta BottomNavia ja WelcomeViewiä Flutter mobiiliappia varten.

**/

import * as React from "react";
import { useEffect } from "react";
import "../styles/App.css";
import "../styles/style.css";
import Map from "../components/map/NewMap";
import Info from "../components/Info";
import { useMediaQuery } from "react-responsive";
// eslint-disable-next-line no-unused-vars
import SnowIcon from "@material-ui/icons/AcUnit";
// eslint-disable-next-line no-unused-vars
import IconButton from "@material-ui/core/IconButton";

var refreshInterval = setInterval(
  window.location.reload.bind(window.location),
  30 * 60000
);

function App() {
  // Use state hookit
  const [token, setToken] = React.useState(null);
  const [segments, setSegments] = React.useState([]);
  const [segmentColors, setSegmentColors] = React.useState(null);
  const [woodsSegment, setWoodsSegment] = React.useState(null);
  const [shownSegment, setShownSegment] = React.useState(null);
  const [snowtypes, setSnowtypes] = React.useState([]);
  const [selectedSegment, setSelectedSegment] = React.useState(null);

  //imported hook. Kysely näyttöportin koosta
  const isMobile = useMediaQuery({ query: "(max-width:900px)" });

  /*
   * Haetaan renderöinnin jälkeen aina tiedot lumilaaduista, päivityksistä ja segmenteistä
   * Tallennetaan ne hookkeihin
   *
   */
  useEffect(() => {
    const fetchData = async () => {
      const snow = await fetch("api/lumilaadut", { mode: "no-cors" });
      const snowdata = await snow.json();
      const updates = await fetch("api/segments/update", { mode: "no-cors" });
      const updateData = await updates.json();
      const response = await fetch("api/segments", { mode: "no-cors" });
      const data = await response.json();

      setSnowtypes(snowdata);

      // Taulukko käytettäville väreille kartassa. Musta väri oletuksena, jos tietoa ei ole
      // Muut värit suoraan kannasta. Taulukko on olennainen NewMap.js:n toiminnan kannalta (kartan värit)
      // emptyColor.name kirjoitusmuoto on olennainen myös NewMap.js:n updateHighlighted -funktiossa
      // Mikäli muutetaan, muutettava myös siellä.
      // const emptyColor = [{color: "#000000", name: "Ei tietoa"}];
      const snowcolors = snowdata.map((item) => {
        return { colour: item.colour, name: item.name, id: item.id };
      });
      // Yhdistetään olemassa olevat värit ja "ei tietoa" (viimeiseksi)
      setSegmentColors(snowcolors);

      await updateData.forEach((update) => {
        snowdata.forEach((snow) => {
          if (snow.id === update.snowTypeId1) {
            update.snow1 = snow;
          }
          if (snow.id === update.snowTypeId2) {
            update.snow2 = snow;
          }
          if (snow.id === update.secondaryId1) {
            update.snow3 = snow;
          }
          if (snow.id === update.secondaryId2) {
            update.snow4 = snow;
          }
          if (snow.id === update.a1SnowType) {
            update.snow5 = snow;
          }
          if (snow.id === update.a2SnowType) {
            update.snow6 = snow;
          }
          if (snow.id === update.a3SnowType) {
            update.snow7 = snow;
          }
        });
      });

      setWoodsSegment(null);
      data.forEach((segment) => {
        segment.update = null;
        updateData.forEach((update) => {
          if (update.segment === segment.id) {
            segment.update = update;
          }
        });
        if (segment.isLowerSegment != null) {
          data.forEach((possibleHigherSegment) => {
            if (possibleHigherSegment.id === segment.isLowerSegment) {
              segment.isLowerSegment = possibleHigherSegment.name;
            }
          });
        }
        if (segment.name === "Metsä") {
          setWoodsSegment(segment);
        }
      });
      updateSegments(data);

      console.log("Segments updated");
    };

    fetchData();
    const interval = setInterval(() => {
      fetchData();
    }, 15000);

    return () => clearInterval(interval);
  }, []);

  /*
   * Event handlerit
   */
  useEffect(() => {
    if (selectedSegment !== null) {
      let selectedId = selectedSegment - 1;

      if (selectedId >= 0 && selectedId < segments.length) {
        if (selectedSegment === segments[selectedId].id) {
          setChoice(segments[selectedId]);
        } else {
          console.log("Could not find segment with reference");
          segments.forEach((segment) => {
            if (segment.id === selectedSegment) {
              setChoice(segment);
            }
          });
        }
      }
    } else {
      setChoice(null);
    }
  }, [segments, selectedSegment]);

  // Segmentin valinta
  function chooseSegment(choice) {
    setSelectedSegment(choice);
  }
  function setChoice(choice) {
    setShownSegment(choice);
  }

  // Token tallennetaan reactin stateen
  // eslint-disable-next-line no-unused-vars
  function updateToken(token) {
    if (typeof token !== "undefined") {
      clearInterval(refreshInterval);
    }
    setToken(token);
  }

  // Kaikkien segmenttien päivittäminen
  function updateSegments(data) {
    setSegments(data);
  }

  function updateWoods(data) {
    setWoodsSegment(data);
  }
  // TODO: Komponenttien tyylejä ja asetteluja voi vielä parannella
  return (
    <div className="root">
      <div className="app">
        <div className="map_container mobile">
          <Map
            shownSegment={shownSegment}
            segmentColors={segmentColors}
            segments={segments}
            onClick={chooseSegment}
            isMobile={isMobile}
            woodsSegment={woodsSegment}
          />
        </div>
        {/* <div className="guide"></div> */}

        {/* Sovelluksen sivupalkki, jossa näytetään kartalta valitun segmentin tietoja
            Näytetään, kun jokin segmentti valittuna, eikä olla hallintanäkymässä */}
        <div className="segment_info">
          {shownSegment !== null ? (
            <Info
              //segments={segments}
              segmentdata={shownSegment}
              token={token}
              updateSegments={updateSegments}
              onUpdate={chooseSegment}
              onClose={chooseSegment}
              updateWoods={updateWoods}
              snowtypes={snowtypes}
            />
          ) : (
            <div />
          )}
        </div>
      </div>
    </div>
  );
}

export default App;
