import 'package:flutter/material.dart';
import 'package:invesotr_soop/component/color.dart';

class Button extends StatelessWidget {
  double? width;
  Widget child;
  Color? color;

  Button({Key? key, required this.child, this.width, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(

          backgroundColor: color ?? deepBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onPressed: () async {},
        child: child,
      ),
    );
  }
}
