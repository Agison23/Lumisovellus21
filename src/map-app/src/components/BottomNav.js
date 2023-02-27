/**
Bottom navigation bar of the application.
Choose between map, snowtype information and weather information.

Recent changes:

29.11 Emil Calonius
Created component

23.2 2023 otso tikkkanen
Added english version

 **/

import  React, { useState, useContext } from "react";
import BottomNavigation from "@material-ui/core/BottomNavigation";
import BottomNavigationAction from "@material-ui/core/BottomNavigationAction";
import MapIcon from "@material-ui/icons/Map";
import InfoIcon from "@material-ui/icons/Info";
import CloudIcon from "@material-ui/icons/Cloud";
import { makeStyles } from "@material-ui/core/styles";
import { createTheme, ThemeProvider } from "@material-ui/core/styles";
import SettingsIcon from "@material-ui/icons/Settings";
import GlobalContext from "../context/GlobalContext";
import translations from "../translations/translations";


const useStyles = makeStyles(() => ({
  navbar: {
    backgroundColor: "rgba(0, 0, 0, 0.8)",
    width: "75vw"
  }
}));

const navBarTheme = createTheme({
  palette: {
    primary: {
      main: "#ed7a72"
    },
    text: {
      secondary: "#a1a1a1"
    }
  }
});

function BottomNav(props) {
  // Hooks
  const [value, setValue] = useState(0);
  const { language } = useContext(GlobalContext);

  // Use styles
  const styledClasses = useStyles();


  if(props.user === null || props.user === undefined) {
    return(
      <ThemeProvider theme={navBarTheme}>
        <BottomNavigation
          className={styledClasses.navbar}
          showLabels
          value={value}
          style={props.isMobile ? {width: "100vw"} : {}}
          // eslint-disable-next-line no-unused-vars
          onChange={(event, newValue) => {
            setValue(newValue);
            props.updateShown(newValue);
          }}
        >
          <BottomNavigationAction
            className={styledClasses.button}
            label= {translations["map"][language]}
            icon={<MapIcon />}
          />
          <BottomNavigationAction
            className={styledClasses.button}
            label={translations["definitions"][language]}
            icon={<InfoIcon />}
          />
          <BottomNavigationAction
            className={styledClasses.button}
            label={translations["weather"][language]}
            icon={<CloudIcon />}
          />
        </BottomNavigation>
      </ThemeProvider>
    );
  }
  else {
    return (
      <ThemeProvider theme={navBarTheme}>
        <BottomNavigation
          className={styledClasses.navbar}
          showLabels
          value={value}
          style={props.isMobile ? {width: "100vw"} : {}}
          // eslint-disable-next-line no-unused-vars
          onChange={(event, newValue) => {
            setValue(newValue);
            props.updateShown(newValue);
          }}
        >
          <BottomNavigationAction
            className={styledClasses.button}
            label= {translations["map"][language]}
            icon={<MapIcon />}
          />
          <BottomNavigationAction
            className={styledClasses.button}
            label= {translations["definitions"][language]}
            icon={<InfoIcon />}
          />
          <BottomNavigationAction
            className={styledClasses.button}
            label={translations["weather"][language]}
            icon={<CloudIcon />}
          />
          <BottomNavigationAction
            className={styledClasses.button}
            label={translations["manage"][language]}
            icon={<SettingsIcon />}
          />
        </BottomNavigation>
      </ThemeProvider>
    );
  }
}

export default BottomNav;
