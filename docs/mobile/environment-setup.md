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
- VS Code will build and start the Dev Container with Flutter + Node.js preinstalled.
- The container will automatically attempt to connect to the host emulator using: `adb connect host.docker.internal:5555` via `postCreateCommand` in devcontainer.json
- On the emulator screen, accept the authentication pop-up: Allow USB Debugging. Once accepted, the container should detect the device automatically. You can verify with `adb devices`

**Note:** If you start the emulator after the container is already running, you need to connect manually by running `adb connect host.docker.internal:5555`  

### 4. Install dependencies and run the app

Install dependencies (including mobile) and run the app:

```
npm install
npm run dev
```

In order to use hot module reloading for mobile, open another terminal and navigate to apps/mobile inside container:

```
cd apps/mobile
flutter run
```

Pressing "r" in the terminal will trigger a hot reload and update the app on the emulator with the latest changes.


## Potential issues

Known issues and how to resolve them:

- ADB not found on host
  - Normally Android SDK Platform-Tools would be installed automatically while setting up Android Studio. Check if you have the `platform-tools` directory, then add it to your system’s PATH.
  - If you can't find it, install Android SDK Platform-Tools via Android Studio. 