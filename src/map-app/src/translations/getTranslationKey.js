/**
Parameter lan should be either "fi" or "en" depending on which language is 
the parameter textToTranslate in.

This function finds the key from the translations object where textToTranslate = 
translations[translationKey][lan] and returns translationKey. 

The snow types and terrain bases are saved in the database only in Finnish, 
so this function allows showing either of the languages to the user by finding 
the key for that textToTranslate parameter.
**/

import translations from "./translations";

export default function getTranslationKey(textToTranslate, lan = "fi") {
  for (let translationKey in translations) {
    let translationObject = translations[translationKey];
    let translationInLan = translationObject[lan];

    if (translationInLan == textToTranslate) {
      return translationKey;
    }
  }
  //shouldn't be possible
  return "error";
}
