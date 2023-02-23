import translations from "./translations"; 

export default function getTranslationKey(snowTypeInFinish,lan = "fi"){
    for (let snowType in translations){
      let snowTypeObject = translations[snowType];
      let snowTypeInFi = snowTypeObject[lan];
  
      if(snowTypeInFi == snowTypeInFinish){
        return snowType;
      }
    }
      //shouldn't be possible
    return "snowTypeError";
}

