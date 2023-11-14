import 'package:flutter/material.dart';
import 'package:invesotr_soop/component/color.dart';

class Button extends StatelessWidget {
  final double? width;
  final Widget child;
  final Color? color;
  final Function? onPressed;
  final Color? borderColor;

  Button(
      {Key? key, required this.child, this.width, this.color, this.onPressed, this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? deepBlue,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: borderColor ?? color ?? deepBlue)),
        ),
        onPressed: () async {
          onPressed?.call();
        },
        child: child,
      ),
    );
  }
}
