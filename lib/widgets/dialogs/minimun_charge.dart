import 'package:flutter/material.dart';
import 'package:harvest/customer/views/root_screen.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/widgets/directions.dart';

class MinimumChargeDialog extends StatelessWidget {
  final String subTitle;

  const MinimumChargeDialog({Key key, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Direction(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: const Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1c000000),
                    offset: Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.clear))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset('assets/minimum-charge.png'),
                  ),
                  Text(
                    'Minimum Charge Price'.trs(context),
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color(0xff3c4959),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xff888a8d),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.of(context, rootNavigator: true)
                            .pushReplacement(MaterialPageRoute(
                          builder: (context) => RootScreen(),
                        ));
                      },
                      child: Container(
                        height: 28,
                        width: 117,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xffe4f0e6),
                        ),
                        child: Center(
                          child: Text(
                            'Home'.trs(context),
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xff3c984f),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
