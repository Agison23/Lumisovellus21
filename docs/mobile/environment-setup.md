# Environment Setup 

Instructions on how to setup **Dev Container** while using the **Android emulator** from local Android Studio installation.

## Prerequisites

Make sure you have the following installed **on your host machine**:

- [Docker](https://www.docker.com/)  
- [Visual Studio Code](https://code.visualstudio.com/) with the **Dev Containers** extension  
- [Android Studio](https://developer.android.com/studio)
- A configured Android emulator (via Android Studio → **Device Manager**)  

## Steps

### 1. Start the Android Emulator (on host)

- Open **Android Studio → Device Manager**.  
- Start your emulator and leave it running in the background.

### 2. Enable ADB TCP/IP on the Host

On your **host machine** (not in the container), run:

```PowerShell
adb kill-server
adb start-server
adb tcpip 5555
```

### 3. Open the Repo in a Dev Container

- Open the repository in **VS Code**.  
- Use **Dev Containers: Reopen in Container** command from the Command Palette (`F1`, `Ctrl+Shift+P`).
- VS Code will build and start the Dev Container with Docker + Flutter + Node.js preinstalled.
- The container will automatically attempt to connect to the host emulator using: `adb connect host.docker.internal:5555` via `postCreateCommand` in devcontainer.json
- On the emulator screen, accept the authentication pop-up: Allow USB Debugging. Once accepted, the container should detect the device automatically. You can verify with `adb devices`

**Note:** If you start the emulator after the container is already running, running the connect command again is required. This is done by the `dev` script and requires re-running the script until you have accepted the popup.

### 4. Set up the backend database and .env variables
- Copy apps/backend/.env.example content into apps/backend/.env and set DATABASE_URL as `mysql://lumisovellus:password@mysql:3306/lumisovellus`
- Copy apps/mobile/.env.example into apps/mobile/.env and set the ACCESS_TOKEN as your public mapbox access token.

### 5. Install dependencies and run the app
Install dependencies (including mobile) and run the app:

```
npm install
cd infra/docker && docker compose up mysql -d && cd ../..
npm run dev
```

In order to use hot module reloading for mobile, open another terminal and navigate to apps/mobile inside container:

```
cd apps/mobile
npm run dev
```

Pressing "r" in the terminal will trigger a hot reload and update the app on the emulator with the latest changes.


## Potential issues

Known issues and how to resolve them:

- ADB not found on host
  - Normally Android SDK Platform-Tools would be installed automatically while setting up Android Studio. Check if you have the `platform-tools` directory, then add it to your system’s PATH.
  - If you can't find it, install Android SDK Platform-Tools via Android Studio. 

## What the mobile `dev` script does
- Tries to connect ADB to the host emulator by running `adb connect host.docker.internal:5555`. If it fails, it won’t stop the script and you need to manually confirm USB debugging from the emulator.
- Sets up port forwarding for the backend by running `adb reverse tcp:3001 tcp:3001`. This allows the app to reach the backend with a localhost ip.
- Starts the Flutter app in debug mode by running `flutter run`
