import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invesotr_soop/component/button.dart';
import 'package:invesotr_soop/component/color.dart';
import 'package:invesotr_soop/component/typograph.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
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
                      child: SvgPicture.asset('assets/images/login-logo.svg')),
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
                            child: const TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '이름',
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: warmGray,
                                border: Border.all(color: lightGray),
                                borderRadius: BorderRadius.circular(6)),
                            child: const TextField(
                                decoration: InputDecoration(
                              fillColor: Colors.blue,
                              border: OutlineInputBorder(),
                              hintText: '연락처',
                            )),
                          ),
                          const SizedBox(height: 27),
                          Button(
                            child: Text(
                              '로그인',
                              style: label2(),
                            ),
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                          Container(
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
    );
  }
}


