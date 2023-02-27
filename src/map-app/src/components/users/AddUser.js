/**
Käyttäjän lisäykseen liittyvät toiminnot

Luonut: Markku Nirkkonen 9.1.2021

23.2 2023 otso tikkkanen
Added english version

**/

import React, {useState, useContext } from "react";
import Box from "@material-ui/core/Box";
import Button from "@material-ui/core/Button";
import Checkbox from "@material-ui/core/Checkbox";
import Typography from "@material-ui/core/Typography";
import AddCircleOutlineIcon from "@material-ui/icons/AddCircleOutline";
import Divider from "@material-ui/core/Divider";
import Dialog from "@material-ui/core/Dialog";
import DialogActions from "@material-ui/core/DialogActions";
import DialogTitle from "@material-ui/core/DialogTitle";
import { makeStyles } from "@material-ui/core/styles";
import FormControl from "@material-ui/core/FormControl";
import FormControlLabel from "@material-ui/core/FormControlLabel";
import Input from "@material-ui/core/Input";
import InputLabel from "@material-ui/core/InputLabel";
import IconButton from "@material-ui/core/IconButton";
import Visibility from "@material-ui/icons/Visibility";
import VisibilityOff from "@material-ui/icons/VisibilityOff";
import InputAdornment from "@material-ui/core/InputAdornment";
import GlobalContext from "../../context/GlobalContext";
import translations from "../../translations/translations";

const useStyles = makeStyles((theme) => ({
  add: {
    padding: theme.spacing(2),
    maxWidth: 400,
    marginTop: 10,
    margin: "auto",
    border: 1,
    borderRadius: 3,
    boxShadow: "0 2px 2px 2px rgba(0, 0, 0, .3)",
  },
  coordinateInputs: {
    display: "flex"
  },
  addNewLine: {
    // Koordinaattirivin lisäysnapin tyylit
  }
}));

function AddUser(props) {

  // Hooks
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [admin, setAdmin] = useState(false);
  const [addOpen, setAddOpen] =useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const { language } = useContext(GlobalContext);

  // Tarkistuksia lisäyspainikkeen aktivoitumiselle lisäysdialogissa
  const formOK = Boolean(!(firstName !== "" && lastName !== "" && email !== "" && password.length >= 7));
  

  /*
   * Event handlers
   */
  
  // Avaa käyttäjänlisäysdialogin
  const openAdd = () => {
    setAddOpen(true);
  };

  // Sulkee dialogin
  const closeAdd = () => {
    setAddOpen(false);
    setFirstName("");
    setLastName("");
    setEmail("");
    setPassword("");
    setAdmin(false);
  };

  // Käyttäjän lisääminen (vahvistusdialogin jälkeen)
  const handleAdd = () => {
    
    // Tiedot  tulevat hookeista
    const data = {
      Etunimi: firstName,
      Sukunimi: lastName,
      Sähköposti: email,
      Salasana: password,
      Rooli: admin ? "admin" : "operator",
    };

    // Käyttäjän lisäämisen api-kutsu
    const fetchAddUser = async () => {
      const response = await fetch("api/user",
        {
          method: "POST",
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            Authorization: "Bearer " + props.token
          },
          body: JSON.stringify(data),
        });
      const res = await response.json();
      console.log(res);
      await props.fetchUsers();
    };
    fetchAddUser();
    closeAdd();
  };

  // Etunimen päivittäminen
  const updateFirstName = (event) => {
    setFirstName(event.target.value);
  };

  // Sukunimen päivittäminen
  const updateLastName = (event) => {
    setLastName(event.target.value);
  };

  // Sähköpostin päivittäminen
  const updateEmail = (event) => {
    setEmail(event.target.value);
  };

  // Sähköpostin päivittäminen
  const updatePassword = (event) => {
    setPassword(event.target.value);
  };

  // Roolin vaihtamienn
  const updateAdmin = () => {
    setAdmin(!admin);
  };

  // Vaihtaa salasanakentän näkyvyyden (päälle/pois)
  const handleClickShowPassword = () => {
    setShowPassword(!showPassword);
  };

  const handleMouseDownPassword = (event) => {
    event.preventDefault();
  };

  const classes = useStyles();

  /*
   * Renderöinti
   */
  return (
    <div className="add_user">
      
      {/* Painike, joka avaa käyttäjän lisäysdialogin */}
      <Box className={classes.add}>
        <Button>
          <AddCircleOutlineIcon />
          <Typography variant="button" onClick={openAdd}>{translations["addUser"][language]}</Typography>
          
        </Button>
      </Box>

      {/* Segmentin lisäysdialogi */}
      <Dialog 
        onClose={closeAdd} 
        open={addOpen}
      >
        <DialogTitle id="add_segment">{translations["addUser"][language]}</DialogTitle>
        <Typography variant="caption">{translations["allTextFieldsAreRequired"][language]}</Typography>
        <Typography variant="caption">{translations["tooShortPassword"][language]}</Typography>
        <FormControl>
          <InputLabel htmlFor="firstname" >{translations["firstName"][language]}</InputLabel>
          <Input
            id="firstname"
            type='text'
            onChange={updateFirstName}
          />
        </FormControl>
        <FormControl>
          <InputLabel htmlFor="lastname" >{translations["lastName"][language]}</InputLabel>
          <Input
            id="lastname"
            type='text'
            onChange={updateLastName}
          />
        </FormControl>
        <FormControl>  
          <InputLabel htmlFor="email" >{translations["email"][language]}</InputLabel>
          <Input
            id="email"
            type='text'
            onChange={updateEmail}
          />
        </FormControl>
        <FormControl>
          <InputLabel htmlFor="standard-adornment-password">{translations["password"][language]}</InputLabel>
          <Input
            id="standard-adornment-password"
            type={showPassword ? "text" : "password"}
            value={password}
            onChange={updatePassword}
            endAdornment={
              <InputAdornment position="end">
                <IconButton
                  aria-label="toggle password visibility"
                  onClick={handleClickShowPassword}
                  onMouseDown={handleMouseDownPassword}
                >
                  {showPassword ? <Visibility /> : <VisibilityOff />}
                </IconButton>
              </InputAdornment>
            }
          />
        </FormControl>
        <FormControlLabel
          control={
            <Checkbox            
              checked={admin}
              onChange={updateAdmin}
              name="admin"
              color="primary"
            />
          }
          label={translations["adminUser"][language]}
        />
        
        {/* Painikkeet lomakkeen lopussa */}
        <DialogActions>   
          <Divider />
          <Button id={"deleteClose"} onClick={closeAdd}>{translations["close"][language]}</Button>
          <Button variant="contained" color="primary" id={"delete"} disabled={formOK} onClick={handleAdd}>{translations["add"][language]}</Button>
        </DialogActions>
      
      </Dialog>
    </div>
  );

}
 
export default AddUser;