import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/widgets/directions.dart';
class AlertBuilder extends StatefulWidget {

  final String title;
  final String subTitle;
  final Widget icon;
  final Color color;

  const AlertBuilder(
      {Key key, this.title, this.subTitle, this.icon, this.color})
      : super(key: key);
  @override
  _AlertBuilderState createState() => _AlertBuilderState();
}

class _AlertBuilderState extends State<AlertBuilder> {


  @override
  Widget build(BuildContext context) {
    return Direction(
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
              color: const Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:28,right: 15 ),
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                              color: widget.color,
                            ),
                            child: Center(child: widget.icon,),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xff3c4959),
                                letterSpacing: 0.14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              widget.subTitle,
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color(0x66423959),
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(bottom: 5),
                    shadowColor: Colors.transparent,
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
