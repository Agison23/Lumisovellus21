# Lumisovellus Mobile – Firebase & APK Build

This README describes how to:

- Initialize Firebase for the Flutter mobile app
- Build an APK for testing

---

## Project Location

```text
  apps/
    mobile/   # Flutter app
```

## Do the Firebase setup
```
cd apps/mobile
curl -sL https://firebase.tools | bash
firebase --version
firebase login
```

## Install FlutterFire CLI (once per environment)
```
dart pub global activate flutterfire_cli
export PATH="$PATH:$HOME/.pub-cache/bin"
flutterfire --version
```

## Configure Firebase for the app

```
flutterfire configure --project=snowledge-36e50
```
Select platforms: android and ios

This generates the file:
```
lib/firebase_options.dart
```

Firebase should already be initialized in main.dart, this is roughly how it should look:
```
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
```

## Build a debug APK
```
flutter build apk --debug
```

The built file will be located at:
```
build/app/outputs/flutter-apk/app-debug.apk
```

## Optional: Building a release APK
```
flutter build apk --release
```

Result:
```
build/app/outputs/flutter-apk/app-release.apk
```

If you are running the project on WSL, you might want to copy the file into Windows
```
cp build/app/outputs/flutter-apk/app-debug.apk /mnt/c/Users/<USERNAME>/Downloads/
```

Now the file is ready to be uploaded into Firebase.