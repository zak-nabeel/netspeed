// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'NetSpeed';

  @override
  String get appTagline => 'اختبار سرعة الإنترنت';

  @override
  String get startTest => 'ابدأ الاختبار';

  @override
  String get cancelTest => 'إلغاء';

  @override
  String get testAgain => 'إعادة الاختبار';

  @override
  String get viewHistory => 'عرض السجل';

  @override
  String get tryAgain => 'حاول مجدداً';

  @override
  String get mbps => 'ميجابت/ث';

  @override
  String get connectionWifi => 'واي فاي';

  @override
  String get connectionMobile => 'بيانات الجوال';

  @override
  String get connectionEthernet => 'إيثرنت';

  @override
  String get connectionNone => 'لا يوجد اتصال';

  @override
  String get connectionUnknown => 'غير معروف';

  @override
  String get statePing => 'البينج';

  @override
  String get stateDownload => 'التنزيل';

  @override
  String get stateUpload => 'الرفع';

  @override
  String get stateFindingServer => 'جاري البحث عن أفضل خادم...';

  @override
  String get stateCheckingConnection => 'جاري التحقق من الاتصال...';

  @override
  String get downloading => 'جاري التنزيل...';

  @override
  String get uploading => 'جاري الرفع...';

  @override
  String get yourInternetSpeed => 'سرعة الإنترنت لديك';

  @override
  String get download => 'التنزيل';

  @override
  String get upload => 'الرفع';

  @override
  String get ping => 'البينج';

  @override
  String get connection => 'الاتصال';

  @override
  String get ms => 'مللي ثانية';

  @override
  String get noInternetTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get noInternetMessage => 'يرجى التحقق من شبكتك والمحاولة مرة أخرى.';

  @override
  String get genericErrorTitle => 'حدث خطأ ما';

  @override
  String get serverErrorMessage => 'تعذر الوصول إلى خادم الاختبار. حاول مرة أخرى.';

  @override
  String get timeoutErrorMessage => 'انتهت مهلة الاختبار. حاول مرة أخرى.';

  @override
  String get connectionLostMessage => 'انقطع اتصال الإنترنت أثناء الاختبار.';

  @override
  String get testCancelledMessage => 'تم إلغاء الاختبار.';

  @override
  String get qualityExcellent => 'ممتاز';

  @override
  String get qualityVeryGood => 'جيد جداً';

  @override
  String get qualityGood => 'جيد';

  @override
  String get qualityFair => 'مقبول';

  @override
  String get qualityPoor => 'ضعيف';

  @override
  String get history => 'السجل';

  @override
  String get noHistoryYet => 'لا توجد اختبارات بعد';

  @override
  String get noHistoryMessage => 'ستظهر نتائج اختباراتك هنا.';

  @override
  String get clearHistory => 'مسح السجل';

  @override
  String get clearHistoryConfirm => 'سيؤدي هذا إلى حذف جميع نتائج الاختبارات المحفوظة نهائياً.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get networkInformation => 'معلومات الشبكة';

  @override
  String get connectionType => 'نوع الاتصال';

  @override
  String get internetStatus => 'حالة الإنترنت';

  @override
  String get connected => 'متصل';

  @override
  String get disconnected => 'غير متصل';

  @override
  String get ipAddress => 'عنوان IP';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get wifiName => 'اسم شبكة الواي فاي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get theme => 'المظهر';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get speedUnit => 'وحدة السرعة';

  @override
  String get unitMbps => 'ميجابت/ث';

  @override
  String get unitMBps => 'ميجابايت/ث';

  @override
  String get language => 'اللغة';

  @override
  String get about => 'حول التطبيق';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get testingServer => 'خادم الاختبار';

  @override
  String get server => 'الخادم';

  @override
  String get home => 'الرئيسية';

  @override
  String get close => 'إغلاق';

  @override
  String get privacyBody => 'لا يجمع تطبيق NetSpeed اسمك أو بريدك الإلكتروني أو رقم هاتفك أو موقعك الدقيق أو جهات اتصالك. تُحفظ نتائج الاختبارات على جهازك فقط ولا تُرفع إلى أي مكان.';

  @override
  String get aboutBody => 'NetSpeed هو تطبيق بسيط يحترم الخصوصية لقياس سرعة الإنترنت، يقيس التنزيل والرفع والبينج باستخدام نقل بيانات حقيقي عبر الشبكة.';
}
