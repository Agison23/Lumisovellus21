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

---

## Setting up the Database with MySQL

This application runs with MySQL database. You would need `MySQL` to run the backend code.

1. Let's install [MySQL](https://dev.mysql.com/downloads/installer/), following [this tutorial](https://www.youtube.com/watch?v=2c2fUOgZMmY). At [3:48](https://youtu.be/2c2fUOgZMmY?t=228), you can choose a `Root Password` of your liking. This will grant us administrator access to the database. You don't need to create a `MySQL User`. We can operate on the database using the `root` user.
2. After adding `MySQL` into your environment variable `Path` at [5:16](https://youtu.be/2c2fUOgZMmY?t=316), you can check that `MySQL` is working on your computer by running `mysql --version` in your terminal.
3. We can now populate the database with our data. First, login to the database with the `root` user by running this in the terminal.

   ```
    mysql -u root -p
   ```

   The `-u` flag the user `root`, `-p` flag for password. `MySQL` will now prompt you to endter the password for `root` user:

   ```
   Enter password:
   ```

   Enter the password you created earlier in Step 1. We should have access to our database now.

   ```
   Welcome to the MySQL monitor...
   ...
   mysql>
   ```

4. In the `MySQL Shell`, we create a new database called `pallas`:

   ```
   mysql> create database pallas;
   ```

   Mind the `;` at the end of the command! We can check that the database is correctly created by using:

   ```
   mysql> show databases;
   ```

   Which should result in something like:

   ```
   +--------------------+
   | Database           |
   +--------------------+
   | information_schema |
   | mysql              |
   | pallas             |   <--- This one!
   | performance_schema |
   | sys                |
   +--------------------+
   ```

5. Select the database we just created with:

   ```
   mysql> use pallas;
   ```

   Now we can populate our database with the data in [our SQL files at ./src/sql/](./src/sql/).

6. Copy and paste the content of the file [luonnit.sql](./src/sql/luonnit.sql) into our terminal. `Enter` to create the tables of this database. After that, keep copy and paste the content of [Lumilaadut.sql](./src/sql/Lumilaadut.sql), then [Segmentit.sql](./src/sql/Segmentit.sql), and [Koordinaatit.sql](./src/sql/Koordinaatit.sql) - in that order - into our terminal and run those commands.

7. We can check that the table are properly populated by running:

   ```
   mysql> show tables;
   ```

   Which should show us all the populated tables:

   ```
   +------------------+
   | Tables_in_pallas |
   +------------------+
   | kayttajaarviot   |
   | kayttajat        |
   | koordinaatit     |
   | lumilaadut       |
   | paivitykset      |
   | segmentit        |
   +------------------+
   ```

Done! Our database is up and running now.

---

## Setting up the React web version and build to run on `localhost:3000`

Let's setup our `React` page now.

1. Navigate to the `./src/map-app/` directory. You should see a `package.json` file there. Run:

   ```
   npm install
   npm audit
   npm audit --force
   ```

   These commands will install and audit our dependencies so that the app can build properly (well not really, but at least it works).

2. Check that the app can build by running:

   ```
   npm start
   ```

   If every works, you should see that the app is up and running in [http://localhost:3000/](http://localhost:3000/).

3. Stop the app by `Ctrl + C` in the terminal. We will now build the app to run with the server using:

   ```
   npm build
   ```

4. That's it! Now navigate to `./src/` (you should see an [`app.js`](./src/app.js) file here) and run the `Express` server with:

   ```
   node app.js
   ```

   And the server will be up and running at `port 3000`:

   ```
   Listening to port 3000
   Listening to port 443
   ```

   On your browser, navigate to [http://localhost:3000/](http://localhost:3000/) to see that the app is running there.

## Setting up the Python Virtual Environment to run the backend Flask code

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
