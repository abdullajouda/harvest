import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/components/WaveAppBar/appBar_body.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:loading_indicator/loading_indicator.dart';

class SupportChat extends StatefulWidget {
  @override
  _SupportChatState createState() => _SupportChatState();
}

class _SupportChatState extends State<SupportChat> {
  static const _image =
      r'''https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fg.foolcdn.com%2Feditorial%2Fimages%2F497302%2Fbearded-older-man-with-big-smile_gettyimages-902012616.jpg&f=1&nofb=1''';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: WaveAppBarBody(
              bottomViewOffset: Offset(0, -10),

              backgroundGradient: CColors.greenAppBarGradient(),
              actions: [
                SvgPicture.asset(Constants.menuIcon),
              ],
              leading: SvgPicture.asset(Constants.basketIcon),
              pinned: true,
              hideActions: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 30)
                  .add(EdgeInsets.only(
                bottom: size.height * 0.12,
              )),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                separatorBuilder: (context, index) => SizedBox(height: 20),
                itemBuilder: (context, index) {
                  // if (index == 0) {
                  //   return Container(
                  //     height: 20,
                  //     width: 20,
                  //     child: LoadingIndicator(
                  //       indicatorType: Indicator.ballPulseSync,
                  //       color: CColors.lightGreen.withOpacity(0.5),
                  //     ),
                  //   );
                  // }
                  return ChatBubble(
                    user: index.isEven
                        ? (index % 4 == 0 ? ChatUser.Me : ChatUser.Auto)
                        : ChatUser.Reciver,
                    imagePath: _image,
                    isSeen: index.isEven,
                    content: "This a message " * 3,
                    time: DateTime.now(),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: TextField(
                  style: TextStyle(fontSize: 13),
                  keyboardAppearance: Brightness.light,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Type a message...",
                    hintStyle: TextStyle(fontSize: 13),
                    suffixIcon: Icon(CupertinoIcons.paperplane_fill),
                    // prefixIconConstraints: BoxConstraints(maxHeight: 45, maxWidth: 45),
                    // prefixIcon: _buildImojePicker(),
                    fillColor: Colors.white,
                    border: _buildTextFieldBorder(),
                    focusedBorder: _buildTextFieldBorder(),
                    errorBorder: _buildTextFieldBorder(),
                    enabledBorder: _buildTextFieldBorder(),
                    disabledBorder: _buildTextFieldBorder(),
                    focusedErrorBorder: _buildTextFieldBorder(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildImojePicker() {
    return InkWell(
      onTap: () {
        print("object");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SvgPicture.asset(
          Constants.emojeIcon,
          fit: BoxFit.contain,
          width: 50,
          height: 50,
        ),
      ),
    );
  }

  ShapeBorder _buildTextFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(99),
      borderSide: BorderSide(color: Colors.transparent, width: 1),
    );
  }
}

enum ChatUser { Me, Reciver, Auto }

class ChatBubble extends StatelessWidget {
  final String imagePath;
  final Widget image;
  final DateTime time;
  final String content;
  final bool isSeen;
  final ChatUser user;

  const ChatBubble({
    Key key,
    @required this.time,
    @required this.content,
    this.isSeen = false,
    this.user = ChatUser.Me,
    this.imagePath,
    this.image,
  })  : assert(image != null || imagePath != null,
            "You should provide an image or imagePath"),
        assert(content != null, "You must provide a message content"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: _direction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: _isNotMe ? CColors.fadeGreen : CColors.fadeOrange,
              borderRadius: BorderRadiusDirectional.only(
                topEnd: _isNotMe ? Radius.circular(12) : Radius.zero,
                bottomStart: _isNotMe ? Radius.circular(12) : Radius.zero,
                topStart: !_isNotMe ? Radius.circular(12) : Radius.zero,
                bottomEnd: !_isNotMe ? Radius.circular(12) : Radius.zero,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildUserAvatar(),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          content,
                          textAlign: _textAlign,
                          style: TextStyle(
                            color: CColors.headerText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(_checkIcon, width: 13),
                      SizedBox(width: 7),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          DateFormat.jm().format(time),
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        image: imagePath != null && user != ChatUser.Auto
            ? DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: AssetImage(Constants.supportImage),
                fit: BoxFit.cover,
              ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 8.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
            color: Color(0x10000000),
          ),
          BoxShadow(
            offset: Offset(0.0, 3.0),
            blurRadius: 14.0,
            spreadRadius: 2.0,
            color: Color(0x10000000),
          ),
        ],
      ),
    );
  }

  bool get _isNotMe => this.user != ChatUser.Me;

  TextDirection get _direction =>
      _isNotMe ? TextDirection.ltr : TextDirection.rtl;

  TextAlign get _textAlign => _isNotMe ? TextAlign.start : TextAlign.end;

  String get _checkIcon =>
      this.isSeen ? Constants.seenCheck : Constants.sentCheck;
}
