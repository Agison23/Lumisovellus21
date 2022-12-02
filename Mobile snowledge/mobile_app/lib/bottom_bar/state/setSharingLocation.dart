import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../../side_bar/gps_handler.dart';
import '../../side_bar/server_communications.dart';
import '../../widgets_binding_observer_state.dart';

class SetSharingLocation extends StatefulWidget {
  const SetSharingLocation({Key? key}) : super(key: key);

  @override
  SetSharingLocationState createState() => SetSharingLocationState();
}

class SetSharingLocationState
    extends WidgetsBindingObserverState<SetSharingLocation> {
  static bool _gpsSwitchState = false;
  static bool get gpsSwitchState => _gpsSwitchState;
  static Location _location = new Location();
  static void setGpsSwitchState(bool value) async {
    if (_gpsSwitchState != value) {
      _gpsSwitchState = value;
      if (value) {
        _location.enableBackgroundMode(enable: true);
        await GpsHandler.startUpdatingGpsVariable();
        ServerComms.startSendingLocationMessages();
      } else {
        GpsHandler.stopUpdatingGpsVariable();
        ServerComms.stopSendingLocationMessages();
        _location.enableBackgroundMode(enable: false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setAppResumedWithAlwaysOnPermissionsTask(() => {
          setState(() {
            setGpsSwitchState(true);
          })
        });
    GpsHandler.loadGpsSetting().then((gpsOn) {
      setState(() {
        setGpsSwitchState(gpsOn);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder<bool?>(
          future: GpsHandler.loadGpsSetting(),
          builder: (context, _snapshot) {
            return Transform.scale(
              scale: 1.5,
              child: Switch(
                  value: _snapshot.data ?? false,
                  onChanged: (value) {
                    GpsHandler.setGpsSetting(context, value,
                            insistAlwaysOn: true)
                        .then((gpsOn) {
                      setState(() {
                        value = gpsOn;
                        setGpsSwitchState(value);
                      });
                    });
                  }),
            );
          }),
    );
  }
}
