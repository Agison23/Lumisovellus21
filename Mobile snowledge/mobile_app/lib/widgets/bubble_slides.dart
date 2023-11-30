import 'package:bubble_showcase/bubble_showcase.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:mobile_app/translations/translations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_bubble/speech_bubble.dart';

class BubbleSlides {
  AbsoluteBubbleSlide getAbsoluteBubbleSlide(String message,
      {NipLocation? nipLocation, Position? position}) {
    return AbsoluteBubbleSlide(
      positionCalculator: (size) => const Position(
        top: 0,
        right: 0,
        bottom: 0,
        left: 0,
      ),
      child: AbsoluteBubbleSlideChild(
        positionCalculator: (size) =>
            position ?? const Position(top: 500, right: 50, left: 50),
        widget: SpeechBubble(
          nipLocation: nipLocation ?? NipLocation.TOP,
          color: const Color(0xff5A97EE),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  RelativeBubbleSlide getRelativeBubbleSlide(
      AppState appState, String message, GlobalKey key,
      {AxisDirection? axisDirection,
      NipLocation? nipLocation,
      EdgeInsets? padding,
      Shape? shape}) {
    return RelativeBubbleSlide(
      widgetKey: key,
      shape: shape ??
          const Oval(
            spreadRadius: 5,
          ),
      child: RelativeBubbleSlideChild(
        direction: axisDirection ?? AxisDirection.down,
        widget: Padding(
          padding: padding ?? const EdgeInsets.only(bottom: 15.0),
          child: SpeechBubble(
            nipLocation: nipLocation ?? NipLocation.TOP,
            color: const Color(0xff5A97EE),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      appState.setShowTutorial = false;
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Text(translations['skipTutorial'][appState.language],
                        style: const TextStyle(color: Colors.white54)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
