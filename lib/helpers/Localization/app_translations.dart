import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppTranslations {
  Locale locale;
  static Map<dynamic, dynamic> _localisedValues;
  BuildContext _context;
  BuildContext get context => _context;
  set ctx(BuildContext context) {
    _context = context;
  }

  AppTranslations(Locale locale) {
    this.locale = locale;
    _localisedValues = null;
  }

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  static Future<AppTranslations> load(Locale locale) async {
    AppTranslations appTranslations = AppTranslations(locale);
    String jsonContent =
        await rootBundle.loadString("resources/langs/${locale.languageCode}-${locale.languageCode.toUpperCase()}.json");
    try {
      _localisedValues = json.decode(jsonContent);
    } catch (e) {
      print("ERROR #$e");
    }
    return appTranslations;
  }

  TextDirection get textDirection => !isArabic ? TextDirection.ltr : TextDirection.rtl;
  TextDirection get directionReversed => isArabic ? TextDirection.ltr : TextDirection.rtl;
  String get currentLanguage => locale.languageCode;
  bool get isArabic => locale.languageCode == 'ar';
  bool get isEnglish => locale.languageCode == 'en';

  String translate(String key) {
    if (_localisedValues == null) return isArabic ? 'تحميل...' : 'loading...';
    return _localisedValues[key] ?? "$key not found";
  }
}

extension Translation on String {
  String trs(BuildContext context) {
    return AppTranslations.of(context).translate(this);
  }
}

extension TranslationText on Text {
  Text trs(BuildContext context) {
    final tr = AppTranslations.of(context);
    return Text(tr.translate(this.data),
        key: key,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis);
  }
}

extension DirAligment on AlignmentGeometry {
  static const Alignment topCenter = Alignment(0.0, -1.0);
}

///Arabic is the baseline for this widget
@Deprecated("Don't use")
class ReversedIcon extends StatelessWidget {
  final Widget child;
  final Widget replacment;
  const ReversedIcon({
    Key key,
    @required this.child,
    @required this.replacment,
  })  : assert(child != null && replacment != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppTranslations trs = AppTranslations.of(context);
    return Transform.rotate(
      angle: trs.isArabic ? 0 : pi,
      child: child,
    );
  }
}
