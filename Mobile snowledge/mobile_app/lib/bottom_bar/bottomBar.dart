import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/dialogs.dart';
import 'package:mobile_app/widgets_binding_observer_state.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends WidgetsBindingObserverState<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          height: 60,
          decoration: const BoxDecoration(color: Colors.black, boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(0, 7), blurRadius: 35)
          ]),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40.0,
              ),
              Container(
                width: 40.0,
              ),
              InkWell(
                onTap: () {
                  // add page infos about sharing location
                  Dialogs().showDialogSharingLocation(context);
                },
                child: Row(
                  children: const [
                    Icon(Icons.near_me_rounded, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Sijainti', style: TextStyle(color: Colors.white))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () {
            Dialogs().showHelpNeededDialog(context);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            height: 90.0,
            width: 90.0,
            decoration: BoxDecoration(
                color: const Color(0xffd99222),
                borderRadius: BorderRadius.circular(50.0)),
            child: const Center(
                child: Text(
              'Pyydä\napua',
              style: TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.center,
            )),
          ),
        ),
      ),
    ]);
  }
}
