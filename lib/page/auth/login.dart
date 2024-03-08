import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:investor_soop/component/button.dart';
import 'package:investor_soop/component/color.dart';
import 'package:investor_soop/component/typograph.dart';
import 'package:get/get.dart';
import 'package:investor_soop/controller/tab_controller.dart';
import 'package:investor_soop/page/auth/@code.dart';
import 'package:investor_soop/services/auth_service.dart';
import 'package:investor_soop/page/tab/tab.dart';
import 'package:investor_soop/services/env_service.dart';
import 'package:toastify/toastify.dart';
import 'package:another_flushbar/flushbar.dart';

final _formKey = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _id = '';

  String _password = '';

  bool isLongPressing = false;

  bool envMode = false;

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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  envMode = false;
                                });
                              },
                              onLongPressStart: (details) {
                                startLongPressTimer();
                              },
                              onLongPressEnd: (details) {
                                stopLongPressTimer();
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 280,
                                  child: Transform.rotate(
                                    angle: (360 / (envMode ? 2 : 1)) *
                                        math.pi /
                                        180,
                                    child: SvgPicture.asset(
                                        'assets/images/login-logo.svg'),
                                  )),
                            ),
                            Get.find<EnvService>().isProd.isTrue
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      Get.dialog(CodeInputDialog());
                                    },
                                    child: Text(
                                      'group code : ${Get.find<EnvService>().companyGroupCode.toString().toUpperCase()}',
                                      style: h2(color: Colors.blue),
                                    ),
                                  ),
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
                                              if (!envMode) {
                                                final authService =
                                                    Get.find<AuthService>();
                                                authService.guestLogin();
                                                Get.offAllNamed('/tab');
                                              } else {
                                                EnvService env =
                                                    Get.find<EnvService>();

                                                if (env.isProd.isTrue) {
                                                  env.devMode();
                                                } else {
                                                  env.prodMode();
                                                }
                                              }
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

  void startLongPressTimer() {
    isLongPressing = true;
    print('start');
    Future.delayed(Duration(seconds: 10), () {
      if (isLongPressing) {
        setState(() {
          envMode = true;
        });
        // 여기에서 원하는 작업을 수행
      }
    });
  }

  void stopLongPressTimer() {
    isLongPressing = false;
  }
}
