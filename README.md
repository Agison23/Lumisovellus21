<!-- # Lumisovellus

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
- Versiohallinnassa lumisovellus.fi/rescue -backendissa on kaksi ylimääräistä fileä. näiden tarvittava sisältö on siirretty \_app.py -tiedostoon, sillä käyttöönoton yhteydessä huomattiin, että mikäli koodit olisivat olleet omassa tiedostossaan, ne olisivat vaatineet 3003 portin toiminnan, eikä sitä osattu silloin asettaa. \_app.py tiedosto käytti jo 3002 porttia, joten koodit siirrettiin sinne. -->

# Snowledge - Lumisovellus

This is a repository for the Snowledge application. See [Wiki](https://gitlab.com/lumisovellus/snowledge/-/wikis/home) for more in-depth documentation!

---

## Setting up the Flutter Development Environment

This instruction is written for setting up the environment in Windows. First, we setup `Flutter` and make sure that it works on our machine.

1. Install [Flutter](https://docs.flutter.dev/get-started/install) using the link. Select your OS. Let's choose Windows here.
2. Unzip the files. This gonna take quite a while since it's big. If you prefer cloning, then open your terminal, and use `git clone https://github.com/flutter/flutter.git -b stable` into your prefered directory. Path to flutter can not contain any non-ASCII characters.
3. Update your `PATH` environment variable based on their instruction (in the install page). We should be able to run `flutter` in our terminal now. Run `flutter doctor` and see what it says. Most likely it will say that you haven't install **Android Studio**, have no Virtual Machine, nor have **Visual Studio** installed.
4. Since I work on Windows, I need to install [Android Studio](https://developer.android.com/studio/install) and configure some virtual machine (For example **Pixel 7**). Follow the rest of the Flutter instruction if you want to use **Visual Studio** as your IDE.
5. Download the **Java SE Dev kit** here: https://www.oracle.com/java/technologies/downloads/. Project runs on atleast java version 22 and below.
6. Add `JAVA_HOME` to your environment variable. Follow [this StackOverflow thread](https://stackoverflow.com/questions/64359564/error-java-home-is-not-set-and-no-java-command-could-be-found-in-your-flutter).
7. Restart your machine for the change to take place.
8. Then just follow [this tutorial](https://www.youtube.com/watch?v=1xipg02Wu8s&t=375s). After this, you should be able to run an `Android simulation` for `Flutter` while using `VSCode` as your IDE.

Some trouble you might (still) run into:

- When running flutter run on the project, Graddle might encounter a problem related to the build tools. To solve this, in `Android Studio -> Tools -> SDK Manager`. In there, select the tools they say that are missing and choose `Apply` to download and install them.

- Some problem about your license. Check out [this](https://stackoverflow.com/questions/54273412/
failed-to-install-the-following-android-sdk-packages-as-some-licences-have-not).

- Android Emulator hypervisor driver installation might fail on AMD processors. Follow this [guide] (https://www.youtube.com/watch?v=Y1WhS2yuF8I&ab_channel=GamerTweak) to fix the issue

Issues that can appear in the future and some help in fixing them:

- Mobile app not compiling due to flutter SDK file pinning issues. This happens because a newer version of Flutter has pinned the given dependency to a higher version. This can be fixed by either [downgrading] (https://karthikponnam.medium.com/flutter-downgrade-any-version-57927705b9e8) Flutter or by upgrading the dependency by running `flutter pub upgrade --major-versions`. 

- Gradle or Kotlin version can be too low. To fix this go to `/Mobile snowledge/mobile_app/android/build.gradle` and upgrade `ext.kotlin_version` and `com.android.tools.build:gradle:` to higher versions. You may also need to upgrade `location` in `Mobile snowledge/mobile_app/pubspec.yaml`



After all that, run `flutter doctor` in your terminal again. You should see that now your have `Android Studio` running, with an Android emulator.

To run the application locally:

1. Clone the repo.
2. Navigate to the directory `./Mobile snowledge/mobile_app`
3. Open the directory in your preffered editor. Again, I use `VSCode` so I use `code .` here.
4. In `VSCode`, choose your `Android emulator` that you created. It should pop up as a mobile phone on your screen.
5. Run `flutter run`. If anything works, then Flutter should build the application using Graddle and install that into your emulation.
6. Now code! To see your change in the emulator, use `r` to perform an app restart. Use `Shift + r` (a captital `R`) to perform a "hot restart" of the app. This helps when you need "big" changes (implement a new `Widget`, for example).

---

## Setting up the Databse using Docker

The production db is a MySQL db, but for local testing purposes we use MariaDB since it has better support for chars like 'äöå' when running in a container.

For local testing the database should be run in a Docker container. Follow the steps below to get it up and running:

1. Install or make sure you have the Docker Engine installed. The Docker Engine is installed through Docker Desktop by default or if you use Linux and don't want the desktop app you can use your preferred package manager to download the engine or follow the instructions [here](https://docs.docker.com/engine/install/). 

2. Docker Compose is installed alongside Docker Desktop by default, but **for linux users**  if you only installed Docker Engine make sure to follow instructions [here](https://docs.docker.com/compose/install/linux/).

3. At last we can check that both are installed by running the following commands in the terminal:
   + `docker --version`
   + `docker-compose --version`

3. Now that Docker is all setup we can locate ourselves to `<project root>/src/sql`.

4. We can start the database by running `docker compose up -d`. After it tells you the containers have started you can check that they are still running using `docker ps`. It should show the images `mariadb` and `adminer` up and running. If they don't show up try using compose without the '-d' (detached mode) flag. It should output if something goes wrong.

5. We use adminer to view data easily in the db. You can access adminer in the port 8080 and the credentials for the db are found in the compose file. If everything went accordingly you should see six tables present in the first view after logging in. 

6. Before running the map-app locally make sure to change your `APP_ENVIRONMENT` variables to `DEVELOPMENT`.

Done! Our database is up and running now. Next step is running the map app.

---

## Setting up the React web version and build to run on `localhost:3000`

Let's setup our `React` page now. NOTE: web version will not run without the database.

1. Install `Node.js` using this tutorial https://nodejs.org/en/learn/getting-started/how-to-install-nodejs.

2. Navigate to the `./src/map-app/` directory. You should see a `package.json` file there. Run:

   ```
   npm install
   npm audit
   npm audit fix --force
   ```

   These commands will install and audit our dependencies so that the app can build

3. Check that the app can build by running:

   ```
   npm start
   ```

   If every works, you should see that the app is up and running in [http://localhost:3000/](http://localhost:3000/).
   NOTE: the app will not wrok correctly yet. As long as it builds move to the next step.
   
4. Stop the app by `Ctrl + C` in the terminal. We will now build the app to run with the server using:

   ```
   npm run build
   ```

5. That's it! Now navigate to `./src/` (you should see an [`app.js`](./src/app.js) file here) and run the `Express` server with:

   ```
   node app.js
   ```

   And the server will be up and running at `port 3000`:

   ```
   Listening to port 3000
   Listening to port 443
   ```

   On your browser, navigate to [http://localhost:3000/](http://localhost:3000/) to see that the app is running there.

## Setting up the Python Virtual Environment to run the mobile app backend Flask code

We need to install a [virtual environment](https://docs.python.org/3/library/venv.html) for our Python code to keep every dependencies in an isolated folder. We will run our backend code in this virtual environment.

1. Make sure that you have installed [Python](https://www.python.org/), if you haven't done so. You can check using the command:

   ```
   python --version
   ```

2. Open your terminal, and navigate to the root directory of the repository, `./snowledge/`. Make sure that you are in the root directory, by checking:

   ```
   ls
   ```

   Make sure that the file `requirements.txt` exists.

3. In the root directory, create a new virtual environment. I named mine `myEnv`:

   ```
   python -m venv myEnv
   ```

   where `myEnv` is the name of your virtual environment.

4. Still in your root directory, activate the virtual environment:

   - On Windows:

   ```
   myEnv\Scripts\activate
   ```

   - On Linux/macOS:

   ```
   source myEnv/bin/activate
   ```

5. Verify that the virtual environment is active by checking the prompt in your terminal, which should have changed to include the name of the virtual environment. Something similar to:

   ```
   (myEnv) ... $
   ```

6. Install the packages you need for your project using `pip` or `conda`. I use `pip` here:

   ```
   pip install -r requirements.txt
   ```

   After this, you should see the `Lib` directory inside your virtual environment folder fills with different packages.

7. You can use the terminal normally, which `ls`, `cd`, etc. You can start the backend server in this virtual environment by `cd` to the backend directory:

   ```
   cd './Mobile snowledge/Server/back_end'
   ```

   and run the `server.py` file with:

   ```
   python server.py
   ```

   You should see something like:

   ```
   Server started succesfully!
   tulee tähän
   ...
   ```

8. You can exit from the virtual environment with:

   ```
   deactivate
   ```

   this should get your terminal prompt back to normal (no more `(myEnv)`).

9. I have already ignore my virtual environment in the `.gitignore` file. But if you name your environment something different than `myEnv`, you can easily ignore it by putting:

   ```
   <YOUR ENVIRONMENT FOLDER NAME>/
   ```

   in the `.gitignore` file so it doesn't push to `master`. Check if this is done correctly by running:

   ```
   git status
   ```

   and see if the virtual environment folder is inside the changes.

After this, you should be able to use Python's virtual environment to run the backend server with `Flask`!
