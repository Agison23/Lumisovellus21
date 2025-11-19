import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

// the name we get from the api is in finnish, so we need to convert it to english to get the correct translation key
export function getTranslationKeyForSnowTypeName(name: string) {
  switch (name) {
    case "Korppu":
      return "crust"
    case "Sohjo":
      return "slush"
    case "Jää":
      return "ice"
    case "Uusi lumi":
      return "fresh"
    case "Tuulen pieksemä lumi":
      return "wind-blown"
    case "Vähäinen lumi":
      return "sparse"
    case "Lumeton maa":
      return "bare-ground"
    case "Vitilumi":
      return "powder-snow"
    case "Puuterilumi":
      return "powder"
    case "Märkä uusi lumi":
      return "wet"
    case "Sastrugi":
      return "sastrugi"
    case "Aaltoileva lumi":
      return "wavy"
    case "Tuiskulumi":
      return "wind-packed"
    case "Ohut korppu":
      return "thin-crust"
    case "Rikkoutuva korppu":
      return "breakable-crust"
    case "Kantava korppu":
      return "bearing-crust"
    case "Rikkoutuva jää":
      return "breakable-ice"
    case "Kastuva lumi":
      return "softening-snow"
    case "Saturoitunut lumi":
      return "saturated-snow"
    case "Kiviä":
      return "stones"
    case "Oksia":
      return "branches"
  }
  return name.toLowerCase().replace(" ", "-");
}