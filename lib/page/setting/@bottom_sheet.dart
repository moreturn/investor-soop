import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor_soop/component/button.dart';
import 'package:investor_soop/component/color.dart';
import 'package:investor_soop/component/typograph.dart';
import 'package:investor_soop/page/property/controller/property_controller.dart';
import 'package:investor_soop/services/auth_service.dart';
import 'package:investor_soop/util/extension.dart';

class PasswordChangeBottomSheet extends StatelessWidget {
  final AuthService controller = Get.find<AuthService>();

  PasswordChangeBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 210,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Text('비밀번호를 변경할 계정을 선택해 주세요.',
                    style: h3(color: Colors.black, bold: true)),
              ),
              ListView.separated(
                itemCount: controller.tokens.length,
                itemBuilder: (c, i) {
                  return ListTile(
                    onTap: () {
                      Get.back();
                      Get.toNamed('/change_password',
                          arguments: {"token": controller.tokens[i]});
                    },
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        controller.tokens[i].id,
                        style: h3(color: gray800)
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                  );
                },
                separatorBuilder: (c, i) {
                  return Divider();
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            ]),
      )),
    );
  }
}
