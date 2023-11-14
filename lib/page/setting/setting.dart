import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invesotr_soop/component/button.dart';
import 'package:invesotr_soop/component/color.dart';
import 'package:invesotr_soop/component/typograph.dart';
import 'package:invesotr_soop/page/setting/@bottom_sheet.dart';
import 'package:invesotr_soop/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:invesotr_soop/services/env_service.dart';
import 'package:invesotr_soop/util/toast.dart';

class SettingPage extends GetView<AuthService> {
  SettingPage({super.key});

  final EnvService _env = Get.find<EnvService>();
  final AuthService _auth = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: SizedBox(
              height: 32,
              child: Text('설정', style: h2(bold: true, color: gray900)),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Obx(
              () => _auth.isGuest.isFalse
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 12,
                        children: [
                          const Text('계정 목록'),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            runSpacing: 12,
                            children: controller.tokens
                                .map((d) => accountItem(d, controller))
                                .toList(),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed('/login');
                            },
                            child: Container(
                              height: 28,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '계정 추가 >',
                                style: label3(color: newDeepBlue),
                              ),
                            ),
                          )
                        ],
                      ))
                  : Container(),
            ),
          ),
          const Divider(
            height: 32,
            thickness: 8,
            color: warmGray50,
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
                    SvgPicture.asset('assets/icons/ic_kakaro.svg'),
                    Text('카카오톡 상담하기', style: label2(color: Colors.black))
                  ],
                ),
              )),
          const Divider(
            height: 32,
            thickness: 8,
            color: warmGray50,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    title: Text('이용약관', style: h3()),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {

                      if(_auth.isGuest.isTrue){
                        Toast.warn('둘러보기 사용자는 비밀번호를 변경할 수 없습니다.');
                      }
                      else{
                        Get.bottomSheet(PasswordChangeBottomSheet());
                      }

                    },
                    title: Text('비밀번호 변경', style: h3()),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Get.defaultDialog(
                        title: _auth.isGuest.isTrue  ? '둘러보기 종료' :'모든 계정 로그아웃',
                        content: const Text('모든 계정을 로그아웃 하시겠습니까?'),
                        textConfirm: '로그아웃',
                        confirmTextColor: Colors.white,
                        textCancel: '취소',
                        onConfirm: () {
                          controller.logout();
                          Get.offAllNamed('/login');
                        },
                        onCancel: Get.back,
                      );
                    },
                    title: Text( _auth.isGuest.isTrue ? '둘러보기 종료': '모든 계정 로그아웃'),
                  ),
                ],
              )),
        ],
      ),
    );

    // Button(
    //   onPressed: () {
    ;
    //   },
    //   child: const Text('logout'),
    // ),
    //
    return Center(
      child: Column(
        children: [
          Button(
            onPressed: () {
              if (_env.isProd.isTrue) {
                _env.devMode();
              } else {
                _env.prodMode();
              }
            },
            child: Text('change ${_env.isProd.value} mode'),
          ),
          Button(
            onPressed: () {
              controller.logout();
              Get.offAllNamed('/login');
            },
            child: const Text('logout'),
          ),
        ],
      ),
    );
  }

  Widget accountItem(Token d, AuthService auth) {
    return GestureDetector(
      onTap: () {
        auth.active(d.id);
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: InkWell(
              child: Container(
                color: warmGray100,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 52,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      d.id,
                      style: h4(color: Colors.black, bold: true),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          d.active ? '적용' : '미적용',
                          style: h6(color: Colors.black),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        SizedBox(
                          height: 16,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: CupertinoSwitch(
                              value: d.active,
                              activeColor: Colors.black,
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          d.active
              ? Positioned(
                  top: 0,
                  left: 16,
                  child: SvgPicture.asset('assets/icons/badge.svg'))
              : Container(),
        ],
      ),
    );
  }
}
