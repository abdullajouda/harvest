import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/helpers/constants.dart';

class FreeShippingSlider extends StatefulWidget {
  final double persentage;
  final double minOrder;
  final Size size;

  const FreeShippingSlider({
    Key key,
    @required this.persentage,
    this.size, this.minOrder,
  })  : assert(persentage >= 0.0 && persentage <= 1.0),
        assert(size != Size.zero),
        super(key: key);

  @override
  _FreeShippingSliderState createState() => _FreeShippingSliderState();
}

class _FreeShippingSliderState extends State<FreeShippingSlider> {
  Offset _offset;
  double width;
  double height;

  @override
  void initState() {
    width = widget.size?.width;
    height = widget.size?.height ?? 17.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Offset center = Offset(size.width/1.2, size.height / 2);
    final rect =
    Rect.fromCenter(center: center, height: size.height, width: size.width);
    final double imageWidthPersentage =
        (size.width / 2) - rect.width * (widget.persentage);
    print(imageWidthPersentage);
    _offset = Offset(rect.left, 0);
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: _FreeShippingSliderPainter(
            persentage: widget.persentage,
            gradient: _buildSliderLinearGradient(),
            onChange: (offset) => _offset = offset,
          ),
          size: Size(width ?? size.width * 0.95, height),
        ),
        PositionedDirectional(
          child: Transform.translate(
            offset: Offset(_offset.dx, 0),
            child: SvgPicture.asset(
              widget.persentage <=0
                  ? Constants.fullFreeDileiveryIcon
                  : Constants.freeDileiveryIcon,
              width: height * 2,
            ),
          ),
        ),
      ],
    );
  }

  Gradient _buildSliderLinearGradient() {
    return LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      // colors: [
      //   Colors.orange,
      //   Colors.orange[200],
      // ],
    );
  }
}

class _FreeShippingSliderPainter extends CustomPainter {
  final double persentage;
  final ValueChanged<Offset> onChange;
  final Color color;
  final LinearGradient gradient;

  const _FreeShippingSliderPainter({
    this.persentage,
    this.onChange,
    this.color,
    this.gradient,
  });

  static const double _onChangeThrethold = 0.965;
  static const double _radiusThrethold = 0.94;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.1);
    Offset center = Offset(size.width / 2, size.height / 2);
    final rect =
        Rect.fromCenter(center: center, height: size.height, width: size.width);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(50));
    canvas.drawRRect(rrect, paint);
    // =======================================
    final double rectStart = rect.left;
    final double rectTop = rect.top;
    final double rectheight = rect.height;
    final double rectWidth = rect.width;
    final double widthPersentage = rectWidth * (1 - persentage);

    final startOffset = Offset(rectStart, rectTop);
    final endOffset = Offset(widthPersentage, rectheight);

    final paint2 = Paint()
      ..color = Colors.orange
      ..shader = _createGradientShaderLeftToRight(endOffset, startOffset);

    final rect2 = Rect.fromPoints(startOffset, endOffset);
    final rrect2 = RRect.fromRectAndCorners(
      rect2,
      bottomLeft: Radius.circular(50),
      topLeft: Radius.circular(50),
      bottomRight: _endRadius(),
      topRight: _endRadius(),
    );
    canvas.drawRRect(rrect2, paint2);
    // =======================================
    final double imageWidthPersentage = (size.width / 2) - size.width  * persentage;

    final Offset _safeOffset = Offset(imageWidthPersentage / (1-_onChangeThrethold), 0);

    Offset _imageOffset = Offset(imageWidthPersentage, 0);

    if (_imageOffset.dx >= (rectWidth * _onChangeThrethold)) {
      _imageOffset -= _safeOffset;
    }
    if (persentage > 0.0) {
      _imageOffset += _safeOffset;
    }
    if (onChange != null)
      onChange(_imageOffset);
    print(_imageOffset);

  }

  Radius _endRadius() {
    return persentage > _radiusThrethold
        ? Radius.circular(50 * persentage)
        : Radius.zero;
  }

  Shader _createGradientShaderLeftToRight(Offset b, [Offset a]) {
    return gradient.createShader(
      Rect.fromPoints(a ?? Offset.zero, b),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
