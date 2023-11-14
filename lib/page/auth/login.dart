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
    bool isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Stack(
      children: [
        Scaffold(
          body: Material(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Container(
                      color: Colors.white,
                      child: SafeArea(
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                height: 280,
                                child: SvgPicture.asset(
                                    'assets/images/login-logo.svg')),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 28),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      onSaved: (value) {
                                        _id = value as String;
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '필수 입력';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        fillColor: warmGray50,
                                        filled: true,
                                        border: OutlineInputBorder(),
                                        hintText: '아이디',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
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
                                        decoration: const InputDecoration(
                                          fillColor: warmGray50,
                                          filled: true,
                                          border: OutlineInputBorder(),
                                          hintText: '비밀번호',
                                        )),
                                    const SizedBox(height: 27),
                                    Button(
                                      onPressed: () async {
                                        final authService =
                                            Get.find<AuthService>();
                                        try {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                          }
                                          await authService.login(
                                              id: _id, password: _password);

                                          Get.offAllNamed('/tab');
                                        } catch (e) {
                                          Flushbar(
                                            message:
                                                "로그인 실패 \n ${e.toString()}",
                                            duration:
                                                const Duration(seconds: 3),
                                            backgroundColor: hot,
                                            flushbarPosition:
                                                FlushbarPosition.TOP,
                                            isDismissible: true,
                                          ).show(Get.context!);
                                        }
                                      },
                                      child: Text(
                                        '로그인',
                                        style: label2(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 28,
                                    ),
                                    Navigator.of(context).canPop()
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              final authService =
                                                  Get.find<AuthService>();
                                              authService.guestLogin();
                                              Get.offAllNamed('/tab');
                                            },
                                            child: Text(
                                              '로그인 하지 않고 둘러보기 >',
                                              style: label3(color: deepBlue)
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: !isKeyboard
              ? SafeArea(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '또는,',
                          style: h6(color: Colors.black54),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Button(
                              color: const Color(0xFFFAE300),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 4,
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/ic_kakaro.svg'),
                                  Text('카카오톡 상담하기',
                                      style: label2(color: Colors.black))
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                )
              : Container(),
        )
      ],
    );
  }
}
