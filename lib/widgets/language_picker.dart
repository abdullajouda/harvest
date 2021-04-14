import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:provider/provider.dart';

class LanguagePicker extends StatefulWidget {
  final ValueChanged<Locale> onChanged;
  final Locale value;

  const LanguagePicker({
    Key key,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  _LanguagePickerState createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  Locale _currentChoosedLocale;

  @override
  void initState() {
    _currentChoosedLocale = widget.value ?? Locale("en", "US");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width * 0.3;
    final _options = [
      PopupMenuItem(
        value: Locale('en', 'US'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                image: DecorationImage(
                  image: AssetImage('assets/icons/en.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              "English",
              style: TextStyle(
                color: CColors.headerText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      PopupMenuItem(
        value: Locale('ar', 'SA'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                image: DecorationImage(
                  image: AssetImage('assets/icons/qatar.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              "العربية",
              style: TextStyle(
                color: CColors.headerText,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    ];

    return Container(
      width: width,
      margin: EdgeInsetsDirectional.only(end: 30,start: 30),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: PopupMenuButton<Locale>(
        elevation: 2,
        padding: EdgeInsets.zero,
        initialValue: _currentChoosedLocale,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onSelected: (value) {
          setState(() => _currentChoosedLocale = value);
          if (widget.onChanged != null) widget.onChanged(value);
        },
        itemBuilder: (context) => _options,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                      image: DecorationImage(
                        image: AssetImage(
                            _currentChoosedLocale.languageCode.toLowerCase() ==
                                    'ar'
                                ? 'assets/icons/qatar.jpg'
                                : 'assets/icons/en.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    _currentChoosedLocale.languageCode.toLowerCase() == 'ar'
                        ? "العربية"
                        : "English",
                    style: TextStyle(
                      color: CColors.headerText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Icon(FontAwesomeIcons.chevronDown,
                    size: 15, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
