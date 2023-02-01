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

lumisovellus.fi/rescuen -nettisivun ja puhelinsovelluksen saa toimintaan näin:

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
- Versiohallinnassa lumisovellus.fi/rescue -backendissa on kaksi ylimääräistä fileä. näiden tarvittava sisältö on siirretty \_app.py -tiedostoon, sillä käyttöönoton yhteydessä huomattiin, että mikäli koodit olisivat olleet omassa tiedostossaan, ne olisivat vaatineet 3003 portin toiminnan, eikä sitä osattu silloin asettaa. \_app.py tiedosto käytti jo 3002 porttia, joten koodit siirrettiin sinne.

## Setting up the Flutter Development Environment

This instruction is written for setting up the environment in Windows. First, we setup `Flutter` and make sure that it works on our machine.

1. Install [Flutter](https://docs.flutter.dev/get-started/install) using the link. Select your OS. Let's choose Windows here.
2. Unzip the files. This gonna take quite a while since it's big. If you prefer cloning, then open your terminal, and use `git clone https://github.com/flutter/flutter.git -b stable` into your prefered directory.
3. Update your `PATH` environment variable based on their instruction (in the install page). We should be able to run `flutter` in our terminal now. Run `flutter doctor` and see what it says. Most likely it will say that you haven't install **Android Studio**, have no Virtual Machine, nor have **Visual Studio** installed.
4. Since I work on Windows, I need to install [Android Studio](https://developer.android.com/studio/install) and configure some virtual machine (I use the **Pixel 3** and **Pixel 4**). Follow the rest of the Flutter instruction if you want to use **Visual Studio** as your IDE (I personally don't and use VSCode)
5. Download the **Java SE Dev kit 11**. **DON'T USE THE LATEST VERSION** (v19). For some reason, Graddle doesn't work with the latest version of Java so install [this version](https://www.oracle.com/java/technologies/downloads/#java11) (you will need to register for a Oracle account for this. Won't take long, just a basic email auth).
6. Add `JAVA_HOME` to your environment variable. Follow [this StackOverflow thread](https://stackoverflow.com/questions/64359564/error-java-home-is-not-set-and-no-java-command-could-be-found-in-your-flutter).
7. Restart your machine for the change to take place now.
8. Then just follow [this tutorial](https://www.youtube.com/watch?v=1xipg02Wu8s&t=375s). After this, you should be able to run an `Android simulation` for `Flutter` while using `VSCode` as your IDE.

Some trouble you might (still) run into:

- When running flutter run on the project, Graddle might encounter a problem related to the build tools. To solve this, in `Android Studio -> Tools -> SDK Manager`. In there, select the tools they say that are missing and choose `Apply` to download and install them.
- Some problem about your license. Check out [this](https://stackoverflow.com/questions/54273412/failed-to-install-the-following-android-sdk-packages-as-some-licences-have-not).

After all that, run `flutter doctor` in your terminal again. You should see that now your have `Android Studio` running, with an Android emulator.

To run the application locally:

1. Clone the repo.
2. Navigate to the directory `./Mobile snowledge/mobile_app`
3. Open the directory in your preffered editor. Again, I use `VSCode` so I use `code .` here.
4. In `VSCode`, choose your `Android emulator` that you created. It should pop up as a mobile phone on your screen.
5. Run `flutter run`. If anything works, then Flutter should build the application using Graddle and install that into your emulation.
6. Now code! To see your change in the emulator, use `r` to perform an app restart. Use `Shift + r` (a captital `R`) to perform a "hot restart" of the app. This helps when you need "big" changes (implement a new `Widget`, for example).
