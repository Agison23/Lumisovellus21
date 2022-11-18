import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  Widget _getIndicatorPlatform(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
        return const CupertinoActivityIndicator();
      case TargetPlatform.android:
      default:
        return const CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) => _getIndicatorPlatform(Theme.of(context).platform);
}
