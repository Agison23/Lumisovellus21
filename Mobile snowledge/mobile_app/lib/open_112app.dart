import 'package:url_launcher/url_launcher.dart';

Future<void> open112() async {
  final appUri = Uri(scheme: "app112suomi");
  bool isInstalled = await canLaunchUrl(appUri);

  if (isInstalled) {
    launchUrl(appUri);
  } else {
    launchUrl(Uri(scheme: "tel", path: "112"));
  }
}
