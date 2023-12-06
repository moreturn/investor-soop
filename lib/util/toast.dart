import 'package:another_flushbar/flushbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:investor_soop/component/color.dart';

class Toast {
  static success(String message) {
    Flushbar(
      message: message,
      icon: const Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.white,
      ),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: green1.withOpacity(0.8),
    ).show(Get.context!);
  }

  static error(String message) {
    Flushbar(
            message: message,
            icon: const Icon(
              Icons.error,
              size: 28.0,
              color: Colors.white,
            ),
            flushbarPosition: FlushbarPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red.shade500)
        .show(Get.context!);
  }

  static warn(String message) {
    Flushbar(
            message: message,
            icon: const Icon(
              Icons.error,
              size: 28.0,
              color: Colors.black,
            ),
            messageColor: Colors.black,
            flushbarPosition: FlushbarPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: yellow.withOpacity(0.8))
        .show(Get.context!);
  }
}
