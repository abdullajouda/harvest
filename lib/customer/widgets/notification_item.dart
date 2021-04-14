import 'package:flutter/material.dart';
import 'package:harvest/customer/models/notifications.dart';

class NoticeItem extends StatelessWidget {
  final NotificationM note;

  const NoticeItem({Key key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: const Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                color: const Color(0x17000000),
                offset: Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  height: 75,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/vectors/harvest_logo.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  height: 75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          note.message,
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xff3c4959),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: Text(
            note.createdAt,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xff3c984f),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
