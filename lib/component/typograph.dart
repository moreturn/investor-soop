import 'dart:ui';

import 'package:flutter/material.dart';

TextStyle h1({Color? color, bool? bold}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 28,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.normal);
}

TextStyle h2({Color? color, bool? bold}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 24,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.normal);
}

TextStyle h3({Color? color, bool? bold}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 18,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.normal);
}

TextStyle h4({Color? color, bool? bold}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 16,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.normal);
}
TextStyle h5({Color? color, bool? bold}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 14,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.normal);
}
TextStyle h6({Color? color, bool? bold}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 13,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.normal);
}
TextStyle h7({Color? color, bool? bold}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 12,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.normal);
}



TextStyle body({Color? color, bool? bold}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 16,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.normal);
}


TextStyle input({Color? color, bool? bold}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 16,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.normal);
}
TextStyle caption({Color? color, bool? bold}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 14,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.normal);
}


TextStyle label1({Color? color, bool? bold}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 18,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.w500);
}


TextStyle label2({Color? color, bool? bold}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 16,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.w500);
}
TextStyle label3({Color? color, bool? bold}) {
  print(color);
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 14,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.w500);
}

TextStyle label4({Color? color, bool? bold}) {
  print(color);
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 11,
      fontWeight: (bold ?? false) ? FontWeight.bold : FontWeight.normal);
}
