// import 'package:url_launcher/url_launcher.dart';

class UrlLauncherWrapper {
  Future<bool> canLaunchUrl(Uri url) async {
    return await canLaunchUrl(url);
  }

  Future<bool> launchUrl(Uri url) async {
    return await launchUrl(url);
  }
}