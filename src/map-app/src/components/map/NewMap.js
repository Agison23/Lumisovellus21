/**
Kartan ja sen päällä olevien elementtien piirto käyttöliittymään
Viimeisin päivitys

Markku Nirkkonen 9.1.2021
Lisätty metsään viittaavat markerit, joista voi valita myös metsäsegmentin lumitilanteen näkyviin

Markku Nirkkonen 30.12.2020
Värit tulevat nyt päivityksistä

Markku Nirkkonen 26.11.2020
Segmenttien värien selitteen kutistamis/laajentamis -mahdollisuus lisätty
Pieni korjaus segmenttien hoverin toimintaan.

Markku Nirkkonen 25.11.2020
Värit muutettu asiakkaan pyytämiksi
Ensimmäinen versio värien selitteistä lisätty kartan päälle
Tummennus segmentiltä poistuu, jos sen tiedot näyttävä kortti suljetaan

Markku Nirkkonen 17.11.2020
Segmenttien väri määräytyy nyt lumilaadun mukaan

Markku Nirkkonen 16.11.2020
Lisätty "Vain laskualueet" checkbox suodattamaan segmenttejä

Arttu Lakkala 15.11.2020
Lisätty päivitys värin valintaan

Emil Calonius 18.10.2021
Changed map from Google Maps to Maanmittauslaitos map

Emil Calonius 24.10.2021
Added drawing of segments on map

Emil Calonius 31.10.2021
Added highlighting to segments

Emil Calonius 4.11
Stopped using react-maplibre-ui library because of limitations
now creation of the map happens in PallasMap.js that is imported in this file

Emil Calonius 26.11.2021
Remove old infobox and checkbox
Add a filter feature

Emil Calonius 9.12.2021
Edited layout of filter feature for mobile

23.2 2023 otso tikkkanen
Added english version

**/

import React, { useContext, useState, useEffect } from "react";
import Box from "@material-ui/core/Box";
import { makeStyles } from "@material-ui/core/styles";
import PallasMap from "./PallasMap";
import Button from "@material-ui/core/Button";
import Collapse from "@material-ui/core/Collapse";
import List from "@material-ui/core/List";
import VisibilityIcon from "@material-ui/icons/Visibility";
import VisibilityOffIcon from "@material-ui/icons/VisibilityOff";
import IconButton from "@material-ui/core/IconButton";
import Dialog from "@material-ui/core/Dialog";
import FilterIcon from "@material-ui/icons/FilterList";
import GlobalContext from "../../context/GlobalContext.js";
import translations from "../../translations/translations";
import getTranslationKey from "../../translations/getTranslationKey";
// Tyylimäärittelyt kartan päälle piirrettäville laatikoille
const useStyles = makeStyles((theme) => ({
  menuContainer: {
    display: "flex",
    padding: theme.spacing(1),
    flexDirection: "column-reverse",
    flex: 6,
  },
  menu: {
    display: "block",
    backgroundColor: "white",
    borderRadius: 8,
  },
  buttonsCntainer: {
    display: "flex",
    padding: theme.spacing(1),
    position: "absolute",
    bottom: "60px",
    left: theme.spacing(1),
    zIndex: 1,
    width: "350px",
  },
  buttonsCntainerMobile: {
    display: "flex",
    flexDirection: "column",
    alignItems: "baseline",
    padding: theme.spacing(1),
    position: "absolute",
    bottom: "60px",
    left: theme.spacing(1),
    zIndex: 1,
    width: "100px",
  },
  eyeIcon: {
    color: "white",
  },
  eyeIconContainer: {
    display: "flex",
    justifyContent: "center",
    marginTop: "auto",
    marginBottom: theme.spacing(1),
    backgroundColor: "rgba(0, 0, 0, 0.8)",
    borderRadius: 8,
    flex: 1,
    height: "40px",
  },
  logoContainer: {
    position: "absolute",
    top: "0px",
    left: "0px",
    width: "100%",
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    zIndex: 1,
    pointerEvents: "none",
    paddingTop: "10px",
  },
  logo: {
    width: "72px",
    height: "44px",
  },
}));

function Map(props) {
  // Use state hooks
  // Snow type to be highlighted on the map, -1 means subsegments only, -2 everything and -3 nothing
  const [highlightedSnowType, setHighlightedSnowType] = useState(-3);
  // An array of snow types that are currently applied to a segment on the map
  const [currentSnowTypes, setCurrentSnowTypes] = useState([]);
  const [open, setOpen] = useState(false);
  const [openMonitorData, setOpenMonitorData] = useState(false);
  const [buttonText, setButtonText] = useState("Näytä ainoastaan...");
  const { language } = useContext(GlobalContext);

  // Zoom depends on the size of the screen
  const zoom = props.isMobile ? 11 : 11.35;

  useEffect(() => {
    // Get all of the snow types that are currently applied to a segment on the map
    let snowTypes = [];
    props.segments.forEach((segment) => {
      if (segment.update !== null) {
        if (
          segment.update.snow1 !== undefined &&
          !(
            snowTypes.filter((e) => e.id === segment.update.snow1.id).length > 0
          )
        ) {
          snowTypes.push(segment.update.snow1);
        }
        if (
          segment.update.snow2 !== undefined &&
          !(
            snowTypes.filter((e) => e.id === segment.update.snow2.id).length > 0
          )
        ) {
          snowTypes.push(segment.update.snow2);
        }
        if (
          segment.update.snow3 !== undefined &&
          !(
            snowTypes.filter((e) => e.id === segment.update.snow3.id).length > 0
          )
        ) {
          snowTypes.push(segment.update.snow3);
        }
        if (
          segment.update.snow4 !== undefined &&
          !(
            snowTypes.filter((e) => e.id === segment.update.snow4.id).length > 0
          )
        ) {
          snowTypes.push(segment.update.snow4);
        }
        if (
          segment.update.snow5 !== undefined &&
          !(
            snowTypes.filter((e) => e.id === segment.update.snow5.id).length > 0
          )
        ) {
          snowTypes.push(segment.update.snow5);
        }
      }
      setCurrentSnowTypes(snowTypes);
    });
  }, [props.segments]);

  /*
   * Event handlers
   */

  useEffect(() => {
    let showOnlyString = translations["showOnly"][language];
    let snowName = "";
    if (highlightedSnowType === -3) {
      setButtonText(showOnlyString);
    } else {
      if (language === "fi") {
        snowName = translations[getTranslationKey(buttonText, "en")][language];
      } else {
        snowName = translations[getTranslationKey(buttonText)][language];
      }
      setButtonText(snowName);
    }
  }, language);

  function handleClick() {
    setOpen(!open);
  }

  function updateHighlightedSnowType(snow) {
    let showOnlyString = translations["showOnly"][language];
    let snowName = translations[getTranslationKey(snow.name)][language];
    if (highlightedSnowType === snow.id) {
      setHighlightedSnowType(-3);
      setButtonText(showOnlyString);
    } else {
      setHighlightedSnowType(snow.id);
      setButtonText(snowName);
    }
  }
  // Updates the chosen segment
  function updateChosen(segment) {
    props.onClick(segment.id);
  }

  function handleClose() {
    setOpen(false);
  }

  function handleClickOpen() {
    setOpen(!open);
  }

  function toggleMonitorsPopups() {
    setOpenMonitorData(!openMonitorData);
  }

  // Use styles
  const styledClasses = useStyles();

  return (
    <div className="map">
      {props.isMobile ? (
        <div className={styledClasses.logoContainer}>
          <img
            className={styledClasses.logo}
            src="pallaksen_pollot_logo.png"
          ></img>
        </div>
      ) : (
        <div></div>
      )}
      <PallasMap
        shownSegment={props.shownSegment}
        chosenSegment={(segment) => updateChosen(segment)}
        segmentColors={props.segmentColors}
        segments={props.segments}
        isMobile={props.isMobile}
        zoom={zoom}
        viewManagement={props.viewManagement}
        highlightedSnowType={highlightedSnowType}
        showMap={props.showMap}
        monitorData={props.monitorData}
        openMonitorData={openMonitorData}
      ></PallasMap>
      {props.isMobile ? (
        <Box className={styledClasses.buttonsCntainerMobile}>
          <Box className={styledClasses.eyeIconContainer}>
            <IconButton
              onClick={toggleMonitorsPopups}
              className={styledClasses.eyeIcon}
            >
              {openMonitorData ? (
                <img src="icons/sensors_krx.svg" />
              ) : (
                <img src="icons/sensors_krx_off.svg" />
              )}
            </IconButton>
          </Box>
          <Box style={{ paddingRight: "10px" }}>
            <IconButton
              onClick={handleClickOpen}
              style={{
                backgroundColor: highlightedSnowType > -2 ? "#ed7a72" : "white",
                height: "40px",
                borderRadius: 8,
                marginBottom: "10px",
              }}
            >
              <FilterIcon />
            </IconButton>
          </Box>
          <Dialog onClose={handleClose} open={open}>
            <List style={{ maxHeight: "500px", overflow: "auto" }}>
              <Box className={styledClasses.menu}>
                {
                  // Append a snow type to the list if it can be found on a segment
                  currentSnowTypes.map((snowType) => {
                    return (
                      <Box key={snowType.id}>
                        <Button
                          fullWidth={true}
                          onClick={() => {
                            updateHighlightedSnowType(snowType);
                            handleClickOpen();
                          }}
                          style={{
                            backgroundColor:
                              highlightedSnowType === snowType.id
                                ? "#ed7a72"
                                : "white",
                          }}
                        >
                          {
                            translations[getTranslationKey(snowType.name)][
                              language
                            ]
                          }
                        </Button>
                      </Box>
                    );
                  })
                }
                <Button
                  fullWidth={true}
                  onClick={() => {
                    updateHighlightedSnowType({
                      name: "Vain laskualueet",
                      id: -1,
                    });
                    handleClickOpen();
                  }}
                  style={{
                    backgroundColor:
                      highlightedSnowType === -1 ? "#ed7a72" : "white",
                  }}
                >
                  {translations["skiingAreasOnly"][language]}
                </Button>
              </Box>
            </List>
          </Dialog>
          <Box className={styledClasses.eyeIconContainer}>
            <IconButton
              className={styledClasses.eyeIcon}
              onClick={() => {
                highlightedSnowType === -2
                  ? updateHighlightedSnowType({
                      id: -3,
                      name: "Näytä ainoastaan...",
                    })
                  : updateHighlightedSnowType({
                      id: -2,
                      name: "Näytä ainoastaan...",
                    });
              }}
            >
              {highlightedSnowType === -2 ? (
                <VisibilityOffIcon />
              ) : (
                <VisibilityIcon />
              )}
            </IconButton>
          </Box>
        </Box>
      ) : (
        <Box className={styledClasses.buttonsCntainer}>
          <Box className={styledClasses.menuContainer}>
            <Button
              onClick={handleClick}
              variant="contained"
              style={{
                backgroundColor: highlightedSnowType > -2 ? "#ed7a72" : "white",
                height: "40px",
              }}
            >
              {buttonText}
            </Button>
            <Collapse in={open} timeout="auto" unmountOnExit>
              <List style={{ maxHeight: "500px", overflow: "auto" }}>
                <Box className={styledClasses.menu}>
                  {
                    // Append a snow type to the list if it can be found on a segment
                    currentSnowTypes.map((snowType) => {
                      return (
                        <Box key={snowType.id}>
                          <Button
                            fullWidth={true}
                            onClick={() => {
                              updateHighlightedSnowType(snowType);
                              handleClick();
                            }}
                            style={{
                              backgroundColor:
                                highlightedSnowType === snowType.id
                                  ? "#ed7a72"
                                  : "white",
                            }}
                          >
                            {
                              translations[getTranslationKey(snowType.name)][
                                language
                              ]
                            }
                          </Button>
                        </Box>
                      );
                    })
                  }
                  <Button
                    fullWidth={true}
                    onClick={() => {
                      updateHighlightedSnowType({
                        name: "Vain laskualueet",
                        id: -1,
                      });
                      handleClick();
                    }}
                    style={{
                      backgroundColor:
                        highlightedSnowType === -1 ? "#ed7a72" : "white",
                    }}
                  >
                    {translations["skiingAreasOnly"][language]}
                  </Button>
                </Box>
              </List>
            </Collapse>
          </Box>
          <Box className={styledClasses.eyeIconContainer}>
            <IconButton
              className={styledClasses.eyeIcon}
              onClick={() => {
                highlightedSnowType === -2
                  ? updateHighlightedSnowType({
                      id: -3,
                      name: "Näytä ainoastaan...",
                    })
                  : updateHighlightedSnowType({
                      id: -2,
                      name: "Näytä ainoastaan...",
                    });
              }}
            >
              {highlightedSnowType === -2 ? (
                <VisibilityOffIcon />
              ) : (
                <VisibilityIcon />
              )}
            </IconButton>
          </Box>
          <Box
            className={styledClasses.eyeIconContainer}
            style={{ marginLeft: "10px" }}
          >
            <IconButton
              onClick={toggleMonitorsPopups}
              className={styledClasses.eyeIcon}
            >
              {openMonitorData ? (
                <img src="icons/sensors_krx.svg" />
              ) : (
                <img src="icons/sensors_krx_off.svg" />
              )}
            </IconButton>
          </Box>
        </Box>
      )}
    </div>
  );
}

export default Map;
