import 'package:flutter/material.dart';

import '../helpers/colors.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle textStyle;
  final String hint;
  final TextStyle hintTextStyle;
  final TextInputType textInputType;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  final EdgeInsetsGeometry contentPadding;
  final bool isEnabled;
  final bool autoCorrect;
  final Icon icon;

  const InputTextField({
    Key key,
    this.controller,
    this.textStyle,
    this.hint,
    this.hintTextStyle,
    this.textInputType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.isEnabled,
    this.autoCorrect = false,
    this.icon,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // color: CColors.fadeBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1.3, color: Colors.transparent),
      ),
      margin: EdgeInsetsDirectional.only(top: 10),
      child: TextFormField(
        enabled: isEnabled,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        autocorrect: autoCorrect,
        keyboardType: textInputType,
        textAlign: TextAlign.start,
        style: TextStyle(color: CColors.darkGreen, fontSize: 14).merge(textStyle),
        decoration: InputDecoration(
          filled: true,
          prefixIcon: icon,
          contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 20),
          hintText: hint,
          fillColor: CColors.fadeBlue,
          hintStyle: TextStyle(color: CColors.grey, fontWeight: FontWeight.w400, fontSize: 14).merge(hintTextStyle),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );
  }
}
