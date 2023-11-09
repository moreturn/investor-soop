import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invesotr_soop/component/button.dart';
import 'package:invesotr_soop/component/color.dart';
import 'package:invesotr_soop/component/typograph.dart';
import 'package:get/get.dart';
import 'package:invesotr_soop/controller/tab_controller.dart';
import 'package:invesotr_soop/services/auth_service.dart';
import 'package:invesotr_soop/page/tab/tab.dart';
import 'package:toastify/toastify.dart';
import 'package:another_flushbar/flushbar.dart';

final _formKey = GlobalKey<FormState>();

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  String _id = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    print(Get.previousRoute);
    return Scaffold(
      appBar: AppBar(),
      body: Material(
        child: Form(
          key: _formKey,
          child: Container(
            color: Colors.white,
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          height: 280,
                          child:
                              SvgPicture.asset('assets/images/login-logo.svg')),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: warmGray,
                                    border: Border.all(color: lightGray),
                                    borderRadius: BorderRadius.circular(6)),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.always,
                                  onSaved: (value) {
                                    _id = value as String;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '필수 입력';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '아이디',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                    color: warmGray,
                                    border: Border.all(color: lightGray),
                                    borderRadius: BorderRadius.circular(6)),
                                child: TextFormField(
                                    onSaved: (value) {
                                      _password = value as String;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '필수 입력';
                                      }
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      fillColor: Colors.blue,
                                      border: OutlineInputBorder(),
                                      hintText: '비밀번호',
                                    )),
                              ),
                              const SizedBox(height: 27),
                              Button(
                                onPressed: () async {
                                  final authService = Get.find<AuthService>();
                                  try {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                    }
                                    await authService.login(
                                        id: _id, password: _password);

                                    Get.offAllNamed('/tab');
                                  } catch (e) {
                                    Flushbar(
                                      message: "로그인 실패 \n ${e.toString()}",
                                      duration: const Duration(seconds: 3),
                                      backgroundColor: hot,
                                      flushbarPosition: FlushbarPosition.TOP,
                                      isDismissible: true,
                                    ).show(Get.context!);
                                  }
                                },
                                child: Text(
                                  '로그인',
                                  style: label2(),
                                ),
                              ),
                              const SizedBox(
                                height: 28,
                              ),
                              Navigator.of(context).canPop()
                                  ? Container()
                                  : Container(
                                      child: Text(
                                        '둘러보기 >',
                                        style: label3(color: deepBlue),
                                      ),
                                    ),
                              //TODO : 높이 가변적으로
                              const SizedBox(
                                height: 120,
                              ),
                              Button(
                                color: Colors.yellow,
                                width: double.infinity,
                                child: Text(
                                  '카카오톡 문의',
                                  style: label2(color: Colors.black),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
