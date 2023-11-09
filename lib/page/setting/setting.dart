import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invesotr_soop/component/button.dart';
import 'package:invesotr_soop/component/color.dart';
import 'package:invesotr_soop/component/typograph.dart';
import 'package:invesotr_soop/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:invesotr_soop/services/env_service.dart';

class SettingPage extends GetView<AuthService> {
  SettingPage({super.key});

  final EnvService env = Get.find<EnvService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 32,
            child: Text('설정', style: h2(bold: true, color: gray900)),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                runSpacing: 12,
                children: [
                  const Text('계정 목록'),
                  Obx(
                    () => Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runSpacing: 12,
                      children: controller.tokens
                          .map((d) => accountItem(d, controller))
                          .toList(),
                    ),
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
              )),
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
    return Center(
      child: Column(
        children: [
          Button(
            onPressed: () {
              if (env.isProd.isTrue) {
                env.devMode();
              } else {
                env.prodMode();
              }
            },
            child: Text('change ${env.isProd.value} mode'),
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
