import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:harvest/helpers/variables.dart';

class LoadingBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpinKitDoubleBounce(
          color: kPrimaryColor,
          size: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: SpinKitDoubleBounce(
            color: kPrimaryColor,
            size: 15,
          ),
        ),
        SpinKitDoubleBounce(
          color: kPrimaryColor,
          size: 15,
        ),
      ],
    );
  }
}
