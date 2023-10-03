# Dockerization of snowledge mobile
The dockerfile in this only serve purpose to not have to set up the mobile front end of the snowledge.
Therefore, to make the snowledge mobile fully functional you need to set up the web side and the mobile back end
## Set up web side
1. Go in **/src/map-app** folder and run `npm install` then `npm audit fix` then `npm run build`
2. Go in **/src** folder and run **node app.js** which should start the map on localhost:3000

## Set up backend
1. Go in **Mobile snowledge/Server**
2. Make sure to install python already and run `pip install -r requirements.txt`
3. Run `python server.py` and server should start on localhost:50943

## Dockerize of snowledge mobile frontend
1. Go in **Mobile snowledge/mobile-app**
2. Make sure that you have still android studio and adb (can run `adb devices` in terminal and `flutter doctor`)
3. Run `docker build -t snowledge-mobile .` which will create the image snowledge-mobile:latest
4. Run `docker run -it --network host snowledge-mobile` which will start a container of the created image and have interactive shell with the same network as the host machine.
5. Open VSCODE and start an emulator, run `adb devices` and when you see the emulator name in that list means that you're successful
6. When the terminal of the docker container is ready, you can run `adb devices`, the emulator should be there too.
7. run `flutter run` in docker container terminal (this will take a long time but it'll work)

## Other notes
1. Because the folder is not actively updated to the docker container, when you make change you'll need to copy the file to the correct position on the docker container as well. For example I change the file **server_communications.dart** in folder **lib/side_bar** then I can run `docker cp lib/side_bar container_id:/app/lib/side_bar`
2. Sometimes there might be problem with the build (some .env file problem in the auto created build folder), avoid deleting this because it'll need to rebuild and take a long time but if this happens then delete this by in docker terminal run `rm -rf build` in the **/app** folder
3. There might be a problem with .env file of this folder, just remove the comments part and copy it to the docker container, the comment make things go wrong