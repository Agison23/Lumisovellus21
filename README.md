# Lumisovellus
Lumisovellus koostuu kahdesta palvelusta: 
- nettisivu, mistä käyttäjät voivat tarkastella pallaksen lumitilannetta ja voivat lisätä sinne lumihavaintoja ja näkevät säätietoja.
- Puhelinsovellus, joka koostuu puhelinsovelluksesta käyttäjille, ja netissä olevasta admin dashboardista (kutsutaan rescue-puoleksi).
- HUOM! nämä palvelut omaavat omat tietokantansa, eivätkä ne keskustele keskenään toistensa kanssa. Poikkeuksena tähän on puhelinsovellus, josta voidaan myös tarkastella lumitilannetta. Tämä on kuitenkin toteutettu webview-komponentilla, eli puhelin käsittelee karttaa kuin se olisi avattuna normiselaimessa.
## Toteutustavat

- Lumitilanteen nettisivu on toteutettu Reactilla (lumisovellus.fi).
- Lumitilanteen nettisivun backend on toteutettu nodeJSsällä ja MySQL-tietokantaa.
- Puhelinaplikaatio on totetettu Flutterilla
- Rescuepuoli on toteutettu Flutter webillä (lumisovellus.fi/rescue)
- puhelinapin ja rescuen backend on toteutettu Pythonilla käyttäen SQLite3 tietokantaa

## Kehitys

Käyttöliittymiä voi kehittää niin, että ne ovat yhteydessä tuotantopuoleen. Tarkoittaa siis sitä, että omaa backend-koodia ei tarvitse laittaa pyörimään lokaalisti. Tällöin varmista, että apikutsut tehdään osoitteeseen lumisovellus.fi/[loppupolku], eikä esimerkiksi localhost:3000.

lumisovellus.fi -nettisivun saa toimintaan näin:
```sh
npm install
npm run
```
lumisovellus.fi/rescuen  -nettisivun ja puhelinsovelluksen saa toimintaan näin:
```sh
flutter run
```

Mobiilisovellus on toteutettu Flutterilla. Kattavan ohjeet sen asentamiseen ja alkuun pääsemiseen eri käyttöjärjestelmille löytyy osoitteesta https://docs.flutter.dev/get-started/install.
Mobiilipuolen tiedostot löytyvät Mobile snowledge kansiosta ja Flutter sovelluksen juuri main.dart tiedosto löytyy snowledge/Mobile snowledge/mobile_app/lib
Mobiilisovelluksen ajaminen onnistuu ajamalla juuri tämä main.dart tiedosto flutter run - komennolla.
Mobiilisovellus koostuu pääosin rescue- elementistä ja se käyttää lumitilanteen ja säätietojen osalta Web puolta


[BACKEND OHJEET PUUTTUU]

## Tiedossa olevat virheet / bugit
- Jostain syystä lumisovellus.fi/rescuen tietokanta menee joskus lukkoon. Se ilmenee sillä, että selain antaa consoliin 500-error koodin. Tämän voi ohittaa käynnistämällä instanssi uudestaan tavu.io -sivulta.
- Versiohallinnassa lumisovellus.fi/rescue -backendissa on kaksi ylimääräistä fileä. näiden tarvittava sisältö on siirretty _app.py -tiedostoon, sillä käyttöönoton yhteydessä huomattiin, että mikäli koodit olisivat olleet omassa tiedostossaan, ne olisivat vaatineet 3003 portin toiminnan, eikä sitä osattu silloin asettaa. _app.py tiedosto käytti jo 3002 porttia, joten koodit siirrettiin sinne.

