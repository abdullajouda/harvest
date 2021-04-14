import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/models/slider.dart';
import 'package:harvest/helpers/colors.dart';
class SliderItem extends StatelessWidget {
  final SliderModel slider;

  const SliderItem({Key key, this.slider}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SizedBox(height: size.height * 0.1),
          Image.network(slider.image,errorBuilder: (context, error, stackTrace) => Expanded(child: Container()), fit: BoxFit.fill),
          // SizedBox(height: size.height * 0.02),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    slider.title??'',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CColors.headerText,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  slider.details,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CColors.headerText,
                    fontSize: 15,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
