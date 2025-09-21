# Dockerization of snowledge mobile

The dockerfile in this only serve purpose to not have to set up the mobile front end of the app.
Therefore, to make the snowledge mobile fully functional you need to set up the web client and the mobile backend.

## Set up web side

1. Go in `/src/map-app `folder and run `npm install` then `npm audit fix` then `npm run build`
2. Go back to `/src` folder. Run `npm install` to install the dependencies, and then run `node app.js` which should start the map on `localhost:3000`.

## Set up backend

1. Go in `Mobile snowledge/Server/back_end`
2. Make sure to install python already and run `pip install -r requirements.txt`
3. Run `python server.py` and server should start on localhost:5000

## Dockerize of snowledge mobile frontend

1. Go in `Mobile snowledge/mobile-app`
2. Make sure that you have Android Studio installed correctly (`flutter doctor` check), and have a valid emulator running. To check this, you can use `adb`: run `adb devices` in your terminal. It should show the list of active devices. If your terminal shows that `adb` is not a valid command, you need to add it into your environment variable. Follow [this](https://stackoverflow.com/questions/20564514/adb-is-not-recognized-as-an-internal-or-external-command-operable-program-or) to do so. Make sure that you have Docker installed, too. You can follow their [Docker desktop guide](https://docs.docker.com/desktop/) to get started.
3. Start `Docker Desktop`.
4. Run `docker build -t snowledge-mobile .` which will create the image `snowledge-mobile:latest`. This will take a while to run.
5. Run `docker images` to see the list of images on your machine. We should see a `snowledge-mobile` repository with the tag `latest`. Nice, we created our image successfully!
6. Run `docker run -it --network host snowledge-mobile` which will start a container of the created image and have interactive shell with the same network as the host machine.
7. Remember that Android emulator we started earlier? Open VSCode's terminal, and now run `adb devices`. We should then see the emulator name in that list - good to go now.
8. When the terminal of the docker container is ready, you can run `adb devices` in that console instance. The same emulator name should show up there, too. For example, in my case, when running `adb devices` in VSCode's terminal and the Docker image instance, I got `emulator-5554` in my `List of devices attached`.
9. Run `flutter run` in the Docker container's terminal. This will start the Flutter app in the container - it will take a long time but it should work at this stage.

## Other notes

1. Because the folder is not actively updated to the docker container, when you make change you'll need to copy the file to the correct position on the docker container as well. For example I change the file `server_communications.dart` in folder `lib/side_bar` then I can run `docker cp lib/side_bar container_id:/app/lib/side_bar`
2. Sometimes there might be problem with the build (some .env file problem in the auto created build folder), avoid deleting this because it'll need to rebuild and take a long time but if this happens then delete this by in docker terminal run `rm -rf build` in the `/app` folder
3. There might be a problem with .env file of this folder, just remove the comments part and copy it to the docker container, the comment make things go wrong
