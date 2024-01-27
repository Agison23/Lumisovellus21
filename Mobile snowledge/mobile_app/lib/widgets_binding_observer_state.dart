import 'package:flutter/cupertino.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class WidgetsBindingObserverState<T extends StatefulWidget> extends State
    with WidgetsBindingObserver {
  @override
  void initState() {
    var appState = Provider.of<AppState>(context, listen: false);
    super.initState();
    setAppResumedWithAlwaysOnPermissionsTask(
        () => {appState.setUserInAppSettings = false});
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  late Function() _appResumedWithAlwaysOnPermissions;

  ///the function will be run when user returns from the AppSettings, where he/she did give the app the alwaysOn location permissions.
  setAppResumedWithAlwaysOnPermissionsTask(Function() f) {
    _appResumedWithAlwaysOnPermissions = f;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var appState = Provider.of<AppState>(context, listen: false);
    switch (state) {
      case AppLifecycleState.resumed:
        if (appState.userInAppSettings) {
          appState.setUserInAppSettings = false;
          Permission.locationAlways.isGranted.then((isGranted) {
            if (isGranted) {
              _appResumedWithAlwaysOnPermissions();
            }
          });
        }
        break;
      default:
        // print("didChangeAppLifecycleState: ${state}");
        break;
    }
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    // override build in the class that extends this State
    throw UnimplementedError();
  }
}
