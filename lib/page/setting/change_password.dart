import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invesotr_soop/component/button.dart';
import 'package:invesotr_soop/component/color.dart';
import 'package:invesotr_soop/component/typograph.dart';
import 'package:invesotr_soop/services/auth_service.dart';
import 'package:invesotr_soop/services/http_service.dart';
import 'package:invesotr_soop/util/toast.dart';

final _formKey = GlobalKey<FormState>();

class ChangePasswordPage extends GetView<AuthService> {
  ChangePasswordPage({super.key});

  RxList<bool> hide = RxList<bool>([true, true, true]);

  final _password = ''.obs;
  final _newPassword1 = ''.obs;
  final _newPassword2 = ''.obs;

  @override
  Widget build(BuildContext context) {
    try {
      Token token = Get.arguments['token'] as Token;

      return Scaffold(
        appBar: AppBar(
          title: Text('비밀번호 변경 ', style: h4(bold: true)),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 52,
                ),
                Text(
                  '기존 비밀번호',
                  style: h5(bold: true),
                ),
                SizedBox(
                  height: 8,
                ),
                Obx(
                  () => TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (v) {
                      _password(v);
                      _formKey.currentState?.save();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '필수 입력';
                      }
                      return null;
                    },
                    obscureText: hide[0],
                    decoration: InputDecoration(
                      fillColor: warmGray50,
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: '기존 비밀번호 입력',
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          hide[0] ? Icons.visibility : Icons.visibility_off,
                          color: deepBlue1,
                        ),
                        onPressed: () {
                          hide[0] = !hide[0];
                          hide.refresh();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  '신규 비밀번호',
                  style: h5(bold: true),
                ),
                SizedBox(
                  height: 8,
                ),
                Obx(
                  () => TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (v) {
                      _newPassword1(v);
                      _formKey.currentState?.save();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '필수 입력';
                      } else if (value.length < 8) {
                        return '비밀번호는 최소 8자리 이상 입력해주세요';
                      } else if (value != _newPassword2.value) {
                        return '확인용 비밀번호와 일치하지 않습니다.';
                      }

                      return null;
                    },
                    obscureText: hide[1],
                    decoration: InputDecoration(
                      fillColor: warmGray50,
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: '신규 비밀번호 입력',
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          hide[1] ? Icons.visibility : Icons.visibility_off,
                          color: deepBlue1,
                        ),
                        onPressed: () {
                          hide[1] = !hide[1];
                          hide.refresh();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (v) {
                      _newPassword2(v);
                      _formKey.currentState?.save();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '필수 입력';
                      } else if (value.length < 8) {
                        return '비밀번호는 최소 8자리 이상 입력해주세요';
                      } else if (value != _newPassword1.value) {
                        return '확인용 비밀번호와 일치하지 않습니다.';
                      }

                      return null;
                    },
                    obscureText: hide[2],
                    decoration: InputDecoration(
                      fillColor: warmGray50,
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: '신규 비밀번호 확인',
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          hide[2] ? Icons.visibility : Icons.visibility_off,
                          color: deepBlue1,
                        ),
                        onPressed: () {
                          hide[2] = !hide[2];
                          hide.refresh();
                        },
                      ),
                    ),
                  ),
                ),
                Button(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try{
                        dynamic a = await controller.passwordChange(
                            pwd: _password.value,
                            newPwd: _newPassword1.value,
                            token: token.token);
                        Get.back();
                        Toast.success('비밀번호가 변경되었습니다.');
                      }
                      catch(e){
                        Toast.error('비밀번호 변경이 실패하였습니다.');
                      }
                    }
                  },
                  child: Text('text'),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print(e);
      Get.back();
      return Container();
    }
  }
}
