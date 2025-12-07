# iOS App Configuration

## Prerequisites

In order to build iOS application, you need to have a Mac with Xcode installed.

The application is distributed for beta usege via firebase app distribution. I recommend installing the Firebase CLI tools to make it easier to manage app distribution.

To install Firebase CLI, you can use npm:

```bash
npm install -g firebase-tools
firebase login
```

You also need to have Flutter installed.

You can find the iOS-specific deployment guide in the Flutter documentation: `https://docs.flutter.dev/docs/deployment/ios`

You will also need `cocoapods` for managing iOS dependencies. You can install it with:

```bash
brew install cocoapods
```

## Building the iOS App

Firebase App Distribution uses .ipa files. You can build the .ipa with the following command:

```bash
flutter build ipa --release --export-method=ad-hoc
```

Then you can distribute the built .ipa file with Firebase CLI:

```bash
firebase appdistribution:distribute build/ios/ipa/Runner.ipa \
  --app=1:YOUR_PROJECT_NUMBER:ios:YOUR_BUNDLE_ID \
  --release-notes="Internal testing build" \
  --testers="tester1@example.com,tester2@example.com"
```
