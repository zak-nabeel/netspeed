// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'NetSpeed';

  @override
  String get appTagline => 'Internet Speed Test';

  @override
  String get startTest => 'START TEST';

  @override
  String get cancelTest => 'CANCEL';

  @override
  String get testAgain => 'TEST AGAIN';

  @override
  String get viewHistory => 'VIEW HISTORY';

  @override
  String get tryAgain => 'TRY AGAIN';

  @override
  String get mbps => 'Mbps';

  @override
  String get connectionWifi => 'Wi-Fi';

  @override
  String get connectionMobile => 'Mobile Data';

  @override
  String get connectionEthernet => 'Ethernet';

  @override
  String get connectionNone => 'No Connection';

  @override
  String get connectionUnknown => 'Unknown';

  @override
  String get statePing => 'PING';

  @override
  String get stateDownload => 'DOWNLOAD';

  @override
  String get stateUpload => 'UPLOAD';

  @override
  String get stateFindingServer => 'Finding best server...';

  @override
  String get stateCheckingConnection => 'Checking connection...';

  @override
  String get downloading => 'Downloading...';

  @override
  String get uploading => 'Uploading...';

  @override
  String get yourInternetSpeed => 'Your Internet Speed';

  @override
  String get download => 'Download';

  @override
  String get upload => 'Upload';

  @override
  String get ping => 'Ping';

  @override
  String get connection => 'Connection';

  @override
  String get ms => 'ms';

  @override
  String get noInternetTitle => 'No Internet Connection';

  @override
  String get noInternetMessage => 'Please check your network and try again.';

  @override
  String get genericErrorTitle => 'Something went wrong';

  @override
  String get serverErrorMessage => 'Could not reach the test server. Please try again.';

  @override
  String get timeoutErrorMessage => 'The test timed out. Please try again.';

  @override
  String get connectionLostMessage => 'Your internet connection was lost during the test.';

  @override
  String get testCancelledMessage => 'Test cancelled.';

  @override
  String get qualityExcellent => 'Excellent';

  @override
  String get qualityVeryGood => 'Very Good';

  @override
  String get qualityGood => 'Good';

  @override
  String get qualityFair => 'Fair';

  @override
  String get qualityPoor => 'Poor';

  @override
  String get history => 'History';

  @override
  String get noHistoryYet => 'No tests yet';

  @override
  String get noHistoryMessage => 'Your test results will appear here.';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get clearHistoryConfirm => 'This will permanently delete all saved test results.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get networkInformation => 'Network Information';

  @override
  String get connectionType => 'Connection Type';

  @override
  String get internetStatus => 'Internet Status';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get ipAddress => 'IP Address';

  @override
  String get notAvailable => 'Not available';

  @override
  String get wifiName => 'Wi-Fi Name';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get speedUnit => 'Speed Unit';

  @override
  String get unitMbps => 'Mbps';

  @override
  String get unitMBps => 'MB/s';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get privacy => 'Privacy';

  @override
  String get appVersion => 'App Version';

  @override
  String get testingServer => 'Testing Server';

  @override
  String get server => 'Server';

  @override
  String get home => 'Home';

  @override
  String get close => 'Close';

  @override
  String get privacyBody => 'NetSpeed does not collect your name, email, phone number, precise location, or contacts. Speed test results are stored only on your device and are never uploaded anywhere.';

  @override
  String get aboutBody => 'NetSpeed is a simple, privacy-friendly internet speed test app that measures download, upload, and ping using real network transfers.';
}
