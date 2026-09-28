import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'NetSpeed'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Internet Speed Test'**
  String get appTagline;

  /// No description provided for @startTest.
  ///
  /// In en, this message translates to:
  /// **'START TEST'**
  String get startTest;

  /// No description provided for @cancelTest.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancelTest;

  /// No description provided for @testAgain.
  ///
  /// In en, this message translates to:
  /// **'TEST AGAIN'**
  String get testAgain;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'VIEW HISTORY'**
  String get viewHistory;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'TRY AGAIN'**
  String get tryAgain;

  /// No description provided for @mbps.
  ///
  /// In en, this message translates to:
  /// **'Mbps'**
  String get mbps;

  /// No description provided for @connectionWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get connectionWifi;

  /// No description provided for @connectionMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile Data'**
  String get connectionMobile;

  /// No description provided for @connectionEthernet.
  ///
  /// In en, this message translates to:
  /// **'Ethernet'**
  String get connectionEthernet;

  /// No description provided for @connectionNone.
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get connectionNone;

  /// No description provided for @connectionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get connectionUnknown;

  /// No description provided for @statePing.
  ///
  /// In en, this message translates to:
  /// **'PING'**
  String get statePing;

  /// No description provided for @stateDownload.
  ///
  /// In en, this message translates to:
  /// **'DOWNLOAD'**
  String get stateDownload;

  /// No description provided for @stateUpload.
  ///
  /// In en, this message translates to:
  /// **'UPLOAD'**
  String get stateUpload;

  /// No description provided for @stateFindingServer.
  ///
  /// In en, this message translates to:
  /// **'Finding best server...'**
  String get stateFindingServer;

  /// No description provided for @stateCheckingConnection.
  ///
  /// In en, this message translates to:
  /// **'Checking connection...'**
  String get stateCheckingConnection;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @yourInternetSpeed.
  ///
  /// In en, this message translates to:
  /// **'Your Internet Speed'**
  String get yourInternetSpeed;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @ping.
  ///
  /// In en, this message translates to:
  /// **'Ping'**
  String get ping;

  /// No description provided for @connection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// No description provided for @ms.
  ///
  /// In en, this message translates to:
  /// **'ms'**
  String get ms;

  /// No description provided for @noInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetTitle;

  /// No description provided for @noInternetMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your network and try again.'**
  String get noInternetMessage;

  /// No description provided for @genericErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get genericErrorTitle;

  /// No description provided for @serverErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the test server. Please try again.'**
  String get serverErrorMessage;

  /// No description provided for @timeoutErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'The test timed out. Please try again.'**
  String get timeoutErrorMessage;

  /// No description provided for @connectionLostMessage.
  ///
  /// In en, this message translates to:
  /// **'Your internet connection was lost during the test.'**
  String get connectionLostMessage;

  /// No description provided for @testCancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'Test cancelled.'**
  String get testCancelledMessage;

  /// No description provided for @qualityExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get qualityExcellent;

  /// No description provided for @qualityVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get qualityVeryGood;

  /// No description provided for @qualityGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get qualityGood;

  /// No description provided for @qualityFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get qualityFair;

  /// No description provided for @qualityPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get qualityPoor;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No tests yet'**
  String get noHistoryYet;

  /// No description provided for @noHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Your test results will appear here.'**
  String get noHistoryMessage;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all saved test results.'**
  String get clearHistoryConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @networkInformation.
  ///
  /// In en, this message translates to:
  /// **'Network Information'**
  String get networkInformation;

  /// No description provided for @connectionType.
  ///
  /// In en, this message translates to:
  /// **'Connection Type'**
  String get connectionType;

  /// No description provided for @internetStatus.
  ///
  /// In en, this message translates to:
  /// **'Internet Status'**
  String get internetStatus;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @wifiName.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Name'**
  String get wifiName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @speedUnit.
  ///
  /// In en, this message translates to:
  /// **'Speed Unit'**
  String get speedUnit;

  /// No description provided for @unitMbps.
  ///
  /// In en, this message translates to:
  /// **'Mbps'**
  String get unitMbps;

  /// No description provided for @unitMBps.
  ///
  /// In en, this message translates to:
  /// **'MB/s'**
  String get unitMBps;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @testingServer.
  ///
  /// In en, this message translates to:
  /// **'Testing Server'**
  String get testingServer;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'NetSpeed does not collect your name, email, phone number, precise location, or contacts. Speed test results are stored only on your device and are never uploaded anywhere.'**
  String get privacyBody;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'NetSpeed is a simple, privacy-friendly internet speed test app that measures download, upload, and ping using real network transfers.'**
  String get aboutBody;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
