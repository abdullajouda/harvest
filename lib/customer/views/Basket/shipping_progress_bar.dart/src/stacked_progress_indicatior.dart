part of '../shipping_progress_bar.dart';

@Deprecated("in favour of `FreeShippingSlider`")
class ShippingPregressIndicator extends StatelessWidget {
  final double value;
  final Size size;
  const ShippingPregressIndicator({
    Key key,
    this.value = 0.1,
    this.size,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final double _height = 20.0;
    return Container(
      height: _size.height * 0.05,
      width: size?.width ?? _size.width,
      margin: EdgeInsets.symmetric(horizontal: _height),
      // decoration: BoxDecoration(color: Colors.teal),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: SizedBox(
              // width: 50,
              child: LinearPercentIndicator(
                padding: EdgeInsets.zero,
                alignment: MainAxisAlignment.center,
                animation: false,
                lineHeight: 20.0,
                percent: value,
                // linearStrokeCap: LinearStrokeCap.roundAll,
                linearGradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  // colors: [
                  //   Colors.orange,
                  //   Colors.orange,
                  // ],
                ),
                backgroundColor: CColors.fadeBlue,
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: (_size.width - 33 - (_height * 2.0)) * value,
            child: SvgPicture.asset(
              value == 1 ? Constants.fullFreeDileiveryIcon : Constants.freeDileiveryIcon,
              width: 33,
            ),
          ),
        ],
      ),
    );
  }
}
