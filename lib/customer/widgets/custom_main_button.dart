import 'package:flutter/material.dart';

import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/button_loader.dart';

class MainButton extends StatelessWidget {
  final String title;
  final TextStyle titleTextStyle;
  final BoxConstraints constraints;
  final VoidCallback onTap;
  final EdgeInsetsGeometry titlePadding;
  final Color color;
  final bool enabled;
  final bool loading;
  final bool outLined;

  const MainButton({
    Key key,
    this.title,
    this.titleTextStyle,
    this.constraints,
    this.onTap,
    this.titlePadding,
    this.color,
    this.enabled = true,
    this.loading = false,
    this.outLined = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled || loading,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          constraints: constraints ?? BoxConstraints(maxHeight: 60),
          decoration: BoxDecoration(
            color: outLined ? null : (color ?? CColors.lightGreen),
            borderRadius: BorderRadius.circular(12),
            border: outLined ? Border.all(color: CColors.lightGreen, width: 2) : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: titlePadding ?? EdgeInsets.zero,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: outLined ? CColors.lightGreen : Colors.white,
                      fontSize: 17,
                    ).merge(titleTextStyle),
                  ),
                ),
              ),
              if (loading)
                Positioned.fill(
                  child: Container(color: Colors.white.withOpacity(0.3), child: Center(child: LoadingBtn())),
                ),
              if (!enabled) Positioned.fill(child: Container(color: Colors.white.withOpacity(0.3))),
            ],
          ),
        ),
      ),
    );
  }
}
