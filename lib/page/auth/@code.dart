import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invesotr_soop/services/env_service.dart';
import 'package:get/get.dart';

class CodeInputDialog extends StatefulWidget {
  const CodeInputDialog({Key? key}) : super(key: key);

  @override
  State<CodeInputDialog> createState() => _CodeInputDialogState();
}

class _CodeInputDialogState extends State<CodeInputDialog> {
  String code = Get.find<EnvService>().devGroupCode;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 360,
          height: 360,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                TextFormField(
                  maxLength: 8,
                  initialValue: code,
                  onChanged: (value) {
                    code = value;
                  },
                ),
                ElevatedButton(onPressed: () {

                  Get.find<EnvService>().setDevGroupCode(code);
                }, child: Text('확인'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
