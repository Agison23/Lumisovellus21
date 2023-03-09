/**
Page for information about snowtypes

Recent changes:

7.12 Emil Calonius
Created component

23.2 2023 otso tikkkanen
Added english version

**/

import React, { useContext } from "react";
import { makeStyles } from "@material-ui/core/styles";
import Box from "@material-ui/core/Box";
import Typography from "@material-ui/core/Typography";
import GlobalContext from "../context/GlobalContext";
import translations from "../translations/translations";

const useStyles = makeStyles(() => ({
  root: {
    display: "flex",
    flexDirection: "column",
  },
  snowType: {
    display: "flex",
    flexDirection: "column",
    width: "500px",
    paddingBottom: "60px",
  },
  header: {
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "rgb(50, 76, 109)",
    color: "white",
    height: "10vh",
    position: "fixed",
    top: 0,
    width: "75vw",
  },
  content: {
    paddingTop: "50px",
    display: "flex",
    flexWrap: "wrap",
    justifyContent: "space-evenly",
  },
  snow: {
    display: "flex",
  },
  avalanche: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    justifyContent: "center",
    paddingTop: "15vh",
    paddingLeft: "50px",
    paddingRight: "50px",
  },
  snowHeader: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    justifyContent: "center",
    paddingTop: "15vh",
    paddingLeft: "50px",
    paddingRight: "50px",
  },
}));

function SnowTypes(props) {
  const { language, changeToLanguage } = useContext(GlobalContext);
  const styledClasses = useStyles();
  window.changeLanguageTo = function (language) {
    changeToLanguage(language);
  };
  return (
    <div className="snow_tab_inner">
      <Box
        className={styledClasses.header}
        style={props.isMobile ? { width: "100vw" } : {}}
      >
        <Typography variant="h3">
          {translations["bigDefinitions"][language]}
        </Typography>
      </Box>
      <Box className={styledClasses.avalanche}>
        <img
          src="/icons/avalanche.svg"
          style={{ height: "100px", width: "100px" }}
        ></img>
        <Typography variant="h4">
          {translations["avalancheWarning"][language]}
        </Typography>
        <Typography style={{ paddingTop: "25px" }}>
          {translations["avalancheTerrains"][language]}
        </Typography>
      </Box>
      <Box className={styledClasses.snowHeader}>
        <Typography variant="h4">
          {translations["snowTypes"][language]}
        </Typography>
      </Box>
      <Box className={styledClasses.content}>
        <Box className={styledClasses.snowType}>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_uusi.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["newSnow"][language]}
              </Typography>
              <Typography>
                {translations["newSnowDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/4.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_newSnow_wet.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["freshWetSnow"][language]}
              </Typography>
              <Typography>
                {translations["freshWetSnowDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/4.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_puuteri.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["powderSnow"][language]}
              </Typography>
              <Typography>
                {translations["powderSnowDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/5.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_uusi_viti.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["freshSnow"][language]}
              </Typography>
              <Typography>
                {translations["freshSnowDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/5.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
        </Box>
        <Box className={styledClasses.snowType}>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_korppu.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["crust"][language]}
              </Typography>
              <Typography>
                {translations["crustDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/3.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_korppu_kantava.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["concrete"][language]}
              </Typography>
              <Typography>
                {translations["concreteDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/3.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_korppu_ohut.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["thinCrust"][language]}
              </Typography>
              <Typography>
                {translations["thinCrustDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/3.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_korppu_rikkoutuva.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["collapsingCrust"][language]}
              </Typography>
              <Typography>
                {translations["collapsingCrustDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/2.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
        </Box>
        <Box className={styledClasses.snowType}>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/wind_driven_snow.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["windPackedSnow"][language]}
              </Typography>
              <Typography>
                {translations["windPackedSnowDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/3.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_tuulenPieksema_aaltoileva.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["wavySnow"][language]}
              </Typography>
              <Typography>
                {translations["wavySnowDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/4.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_tuulenPieksema_sasturgi.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["sastrug"][language]}
              </Typography>
              <Typography>
                {translations["sastrugDescription"][language]}{" "}
              </Typography>
              <img
                src="/icons/skiability/1.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_tuulenPieksema_tuisku.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["windblownSnow"][language]}
              </Typography>
              <Typography>
                {translations["windblownSnowDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/4.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
        </Box>
        <Box className={styledClasses.snowType}>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_jaa.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["ice"][language]}
              </Typography>
              <Typography>
                {translations["iceDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/2.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_jaa_rikkoutuva.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["breakableIce"][language]}
              </Typography>
              <Typography>
                {translations["breakableIceDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/1.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
        </Box>
        <Box className={styledClasses.snowType}>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_sohjo.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["slush"][language]}
              </Typography>
              <Typography>
                {translations["slushDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/2.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_sohjo_kastuva.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["wettingSnow"][language]}
              </Typography>
              <Typography>
                {translations["wettingSnowDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/3.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/icon_sohjo_saturoitunut.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["saturatedSnow"][language]}
              </Typography>
              <Typography>
                {translations["saturatedSnowDescription"][language]}
              </Typography>
              <img
                src="/icons/skiability/2.svg"
                style={{ height: "20px", width: "100px" }}
              ></img>
            </Box>
          </Box>
        </Box>
        <Box className={styledClasses.snowType}>
          <Box className={styledClasses.snow}>
            <img
              src="/lumilogot/Lumetonmaa.svg"
              style={{ height: "100px", width: "100px" }}
            ></img>
            <Box>
              <Typography variant="h5">
                {translations["littleSnow"][language]}
              </Typography>
            </Box>
          </Box>
        </Box>
      </Box>
    </div>
  );
}

export default SnowTypes;
