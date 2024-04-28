import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/bubble_slides.dart';
import 'package:mobile_app/widgets/dialogs.dart';
import 'package:mobile_app/widgets_binding_observer_state.dart';
import 'package:provider/provider.dart';
import 'package:bubble_showcase/bubble_showcase.dart';
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
  final GlobalKey _shareLocationButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: true);
    Widget bottomBar = buildBottomBar(appState);

    // return bottomBar;
    return appState.showTutorial &&
            appState.currentTutorialStep ==
                appState.tutorialSteps['LOCATION_SHARING']
        ? BubbleShowcase(
            bubbleShowcaseId: 'my_bubble_showcase_4',
            bubbleShowcaseVersion: 1,
            doNotReopenOnClose: true,
            bubbleSlides: [
              BubbleSlides().getRelativeBubbleSlide(
                  appState,
                  translations['rescueTutorial']['shareLocation']
                      [appState.language],
                  _shareLocationButtonKey,
                  axisDirection: AxisDirection.up,
                  nipLocation: NipLocation.BOTTOM)
            ],
            child: bottomBar,
          )
        : bottomBar;
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
        child: buildAskHelpButton(appState),
      ),
    ]);
  }

  Widget buildAskHelpButton(AppState appState) {
    return (appState.showTutorial &&
            appState.currentTutorialStep ==
                appState.tutorialSteps['ASK_FOR_HELP'])
        ? BubbleShowcase(
            bubbleShowcaseId: 'my_bubble_showcase_6',
            bubbleShowcaseVersion: 1,
            doNotReopenOnClose: true,
            bubbleSlides: [
              BubbleSlides().getRelativeBubbleSlide(
                  appState,
                  translations['rescueTutorial']['askForHelp']
                      [appState.language],
                  _askForHelpButtonKey,
                  axisDirection: AxisDirection.up,
                  nipLocation: NipLocation.BOTTOM,
                  shape: const Oval(spreadRadius: 1))
            ],
            child: buildAskForHelpButton(appState),
          )
        : buildAskForHelpButton(appState);
  }

  Widget buildAskForHelpButton(AppState appState) {
    String pngFile =
        appState.language == 'en' ? 'askForHelpEn.png' : 'askForHelpFi.png';

    String pngPath = 'assets/images/$pngFile';

    return InkWell(
        key: _askForHelpButtonKey,
        onTap: () {
          Dialogs().showHelpNeededDialog(context);
          if (appState.showTutorial &&
              appState.currentTutorialStep ==
                  appState.tutorialSteps['ASK_FOR_HELP']) {
            print("Advance to next tutorial step!");
            appState.nextTutorialStep();
          }
        },
        child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            alignment: Alignment.center,
            width: 90.0,
            height: 90.0,
            child: Image.asset(pngPath, fit: BoxFit.contain)));
  }

  Widget buildShareLocationButton(AppState appState) {
    return InkWell(
      key: _shareLocationButtonKey,
      onTap: () {
        // add page infos about sharing location
        Dialogs().showDialogSharingLocation(context);
        if (appState.showTutorial &&
            appState.currentTutorialStep ==
                appState.tutorialSteps['LOCATION_SHARING']) {
          print("Advance to next tutorial step!");
          appState.nextTutorialStep();
        }
      },
      child: Row(
        children: [
          const Icon(Icons.near_me_rounded, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            translations['location'][appState.language],
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Baskerville'
              ),
          )
        ],
      ),
    );
  }
}
