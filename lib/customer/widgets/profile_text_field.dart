import 'package:flutter/material.dart';

import 'package:harvest/helpers/colors.dart';

class NoBGTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle textStyle;
  final String hint;
  final TextStyle hintTextStyle;
  final TextInputType textInputType;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  final EdgeInsetsGeometry contentPadding;
  final BorderRadius borderRadius;
  final bool isEnabled;
  final bool autoCorrect;
  final Widget icon;
  final int linesNum;
  final String initVal;

  const NoBGTextField({
    Key key,
    this.controller,
    this.textStyle,
    this.hint,
    this.hintTextStyle,
    this.textInputType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.contentPadding,
    this.isEnabled,
    this.autoCorrect = false,
    this.icon,
    this.linesNum,
    this.borderRadius, this.initVal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _borderRaduis = borderRadius ?? BorderRadius.circular(16);
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CColors.white,
        borderRadius: _borderRaduis,
        border: Border.all(width: 1.3, color: Colors.grey[300]),
      ),
      margin: EdgeInsetsDirectional.only(top: 10),
      child: TextFormField(
        initialValue: initVal,
        maxLines: linesNum,
        enabled: isEnabled,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        autocorrect: autoCorrect,
        keyboardType: textInputType,
        textAlign: TextAlign.start,
        style: TextStyle(color: CColors.darkGreen, fontSize: 13).merge(textStyle),
        decoration: InputDecoration(
          fillColor: CColors.white,
          filled: true,
          prefixIcon: icon != null ? IconTheme.merge(data: IconThemeData(size: 20), child: icon) : null,
          contentPadding:
              icon == null ? EdgeInsetsDirectional.only(start: 15, top: 10, bottom: 10) : EdgeInsets.all(15),
          hintText: hint,
          hintStyle: TextStyle(color: CColors.grey, fontWeight: FontWeight.w400, fontSize: 13).merge(hintTextStyle),
          border: OutlineInputBorder(
            borderRadius: _borderRaduis,
            // borderSide: BorderSide(color: Colors.grey[200], width: 4, style: BorderStyle.none),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: _borderRaduis,
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );
  }
}
