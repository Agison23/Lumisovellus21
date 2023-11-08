import 'package:bubble_showcase/bubble_showcase.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/dialogs.dart';
import 'package:mobile_app/widgets_binding_observer_state.dart';
import 'package:provider/provider.dart';
import 'package:speech_bubble/speech_bubble.dart';

import '../state/appState.dart';
import '../translations/translations.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends WidgetsBindingObserverState<BottomBar> {
  final GlobalKey _askForHelpButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: true);
    Widget bottomBar = buildBottomBar(appState);

    // return bottomBar;
    return appState.showTutorial && appState.currentTutorialStep == 3
        ? BubbleShowcase(
            bubbleShowcaseId: 'my_bubble_showcase',
            bubbleShowcaseVersion: 1,
            bubbleSlides: [
              _askForHelpButtonSlide(),
            ],
            child: bottomBar,
          )
        : bottomBar;
  }

  RelativeBubbleSlide _askForHelpButtonSlide() {
    return RelativeBubbleSlide(
      widgetKey: _askForHelpButtonKey,
      shape: const Oval(
        spreadRadius: 0,
      ),
      child: RelativeBubbleSlideChild(
        direction: AxisDirection.up,
        widget: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: SpeechBubble(
            nipLocation: NipLocation.BOTTOM,
            color: Colors.blue,
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'This is a new cool feature !',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomBar(AppState appState) {
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
              buildShareLocationButton(appState),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: buildAskForHelpButton(appState),
      ),
    ]);
  }

  Widget buildAskForHelpButton(AppState appState) {
    return InkWell(
      key: _askForHelpButtonKey,
      onTap: () {
        Dialogs().showHelpNeededDialog(context);
        if (appState.showTutorial && appState.currentTutorialStep == 3) {
          print("Advance to next tutorial step!");
          appState.nextTutorialStep();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        height: 90.0,
        width: 90.0,
        decoration: BoxDecoration(
            color: const Color(0xffd99222),
            borderRadius: BorderRadius.circular(50.0)),
        child: Center(
          child: Text(
            translations['askHelp'][appState.language],
            style: const TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildShareLocationButton(AppState appState) {
    return InkWell(
      onTap: () {
        // add page infos about sharing location
        Dialogs().showDialogSharingLocation(context);
      },
      child: Row(
        children: [
          const Icon(Icons.near_me_rounded, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            translations['location'][appState.language],
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
