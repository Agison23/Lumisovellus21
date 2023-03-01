/**
Uloskirjautumispainike ja sen toiminnallisuudet

Luonut: Markku Nirkkonen

Viimeisin päivitys
Markku Nirkkonen 26.11.2020
Suomennoksia, ei siis käytännön muutoksia

2.12.2020 Markku Nirkkonen
Korjattu niin, että uloskirjautuessa näkymä palaa karttaan

23.2 2023 otso tikkkanen
Added english version

**/

import React,{useState, useContext } from "react";
import Button from "@material-ui/core/IconButton";
// eslint-disable-next-line no-unused-vars
import ExitToAppIcon from "@material-ui/icons/ExitToApp";
// eslint-disable-next-line no-unused-vars
import Typography from "@material-ui/core/Typography";
import DialogActions from "@material-ui/core/DialogActions";
import IconButton from "@material-ui/core/IconButton";
import SnowIcon from "@material-ui/icons/AcUnit";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import { makeStyles } from "@material-ui/core/styles";
import Divider from "@material-ui/core/Divider";
import GlobalContext from "../context/GlobalContext";
import translations from "../translations/translations";

import { Select, MenuItem } from "@material-ui/core";

const useStyles = makeStyles(() => ({
  snowIcon: {
    position: "absolute",
    top: "5px",
    right: "5px"
  }
}));

function Logout(props) {
  // Hooks
  const [logoutOpen, setLogoutOpen] = useState(false);

  const { language, changeToLanguage } = useContext(GlobalContext);
  const handleChange = (event) => {
    const languageToChangeTo = event.target.value;
    changeToLanguage(languageToChangeTo);
  };


  // Event handlers

  //Avaa kirjautumisdialogin
  const openLogout = () => {
    setLogoutOpen(true);
  };

  // Sulkee kirjautumisdialogin
  const closeLogout = () => {
    setLogoutOpen(false);
  };
   
  //  Uloskirjautuminen nollaa tokenin ja kirjautuneen käyttäjän
  const logout = () => {
    props.updateToken(null);
    props.updateUser(null);
    if (props.showManagement) {
      props.updateShown(0);
    }   
  };

  const styledClasses = useStyles();

  return (
    <div className="logout">
      <div className={styledClasses.snowIcon} >
      <Select
          style={{
            color: props.isMobile ? "#4d4d4d" : "#e6e6e6",
            fontWeight: "bold",
            padding: "5px",
          }}
          value={language}
          onChange={handleChange}
          className={"select"}
        >
          <MenuItem value="en">English</MenuItem>
          <MenuItem value="fi">Suomi</MenuItem>
        </Select>
 
        <IconButton 
          onClick={openLogout}
        >
          <SnowIcon style={{color: "#4d4d4d"}} />
        </IconButton>
      </div>
      <Dialog 
        onClose={closeLogout} 
        open={logoutOpen}
      >
        <DialogTitle id="logout-dialog">{translations["logOut"][language]}</DialogTitle>
        <DialogActions>
          <Divider/>
          <Button id={"dialogClose"} onClick={closeLogout}>{translations["cancel"][language]}</Button>
          <Button color="primary" id={"dialogOK"} onClick={logout}>OK</Button>
        </DialogActions>
      </Dialog>
    </div>
  );

}
 
export default Logout;
