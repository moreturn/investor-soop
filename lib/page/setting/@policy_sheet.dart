import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor_soop/component/button.dart';
import 'package:investor_soop/component/color.dart';
import 'package:investor_soop/component/typograph.dart';
import 'package:investor_soop/page/property/controller/property_controller.dart';
import 'package:investor_soop/services/auth_service.dart';
import 'package:investor_soop/services/http_service.dart';
import 'package:investor_soop/util/extension.dart';

const url = [
  {
    "title": "이용약관",
    "url": "https://www.notion.so/09b554582c8a4c0aa97c9c3b72f660ca?pvs=4"
  },
  {
    "title": "개인정보처리방침",
    "url": "https://plip.kr/pcc/75d6d169-c2e9-40d9-a6d1-38cf61b5dc84/privacy/1.html"
  }
];

class PolicySheet extends StatelessWidget {
  final AuthService controller = Get.find<AuthService>();

  PolicySheet({
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
                child: Text('이용약관', style: h3(color: Colors.black, bold: true)),
              ),
              ListView.separated(
                itemCount: url.length,
                itemBuilder: (c, i) {
                  return ListTile(
                    onTap: () {
                      HttpService.launchURL(url[i]['url']!);
                    },
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        url[i]['title']!,
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
