import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/widgets/directions.dart';

class NotAuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Direction(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: SvgPicture.asset(
              'assets/signup_required.svg',
            ),
          ),
          Text(
            'Login is required in order to view this page.'.trs(context),
            style: TextStyle(
              fontSize: 24,
              color: const Color(0xff000000),
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
