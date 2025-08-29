import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:investor_soop/services/auth_service.dart';
import 'package:investor_soop/services/env_service.dart';

import 'package:url_launcher/url_launcher.dart';

class HttpService extends GetxController {
  Future<HttpService> init() async => this;
  final _env = Get.find<EnvService>();
  final _auth = Get.find<AuthService>();

  HttpService._privateConstructor();

  static final HttpService _instance = HttpService._privateConstructor();

  factory HttpService() {
    return _instance;
  }

  static launchURL(String urlString) async {
    if (await canLaunchUrl(Uri.parse(urlString))) {
      await launchUrl(Uri.parse(urlString),
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $urlString';
    }
  }

  Future<T> post<T>(String url, dynamic body, {String? token}) async {
    try {
      // HTTP POST 요청 시작
      Uri uri = Uri.parse(_env.apiEndPoint + url);
      http.Response res = await http.post(uri, body: body, headers: {
        "Authorization": token ?? await _auth.getToken() ?? '',
        "code": _env.companyGroupCode
      });

      if (res.statusCode < 200 || 299 < res.statusCode) {
        dynamic json = jsonDecode(res.body.toString());
        throw json['message'] ?? json['error'] ?? '예기치못한 오류';
      }

      return jsonDecode(res.body.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<T> get<T>(String url, {String? token}) async {
    try {
      Uri uri = Uri.parse(_env.apiEndPoint + url);
      http.Response res = await http.get(uri, headers: {
        "Authorization": token ?? await _auth.getToken() ?? '',
        "code": _env.companyGroupCode,
      });

      if (res.statusCode < 200 || 299 < res.statusCode) {
        dynamic json = jsonDecode(res.body.toString());
        throw json['message'] ?? json['error'] ?? '예기치못한 오류';
      }
      return jsonDecode(res.body.toString()) as T;
    } catch (e) {
      rethrow;
    }
  }

  Future<T> patch<T>(String url, dynamic body, {String? token}) async {
    try {
      Uri uri = Uri.parse(_env.apiEndPoint + url);
      http.Response res = await http.patch(uri, body: body, headers: {
        "Authorization": token ?? await _auth.getToken() ?? '',
        "code": _env.companyGroupCode,
      });

      if (res.statusCode < 200 || 299 < res.statusCode) {
        dynamic json = jsonDecode(res.body.toString());
        throw json['message'] ?? json['error'] ?? '예기치못한 오류';
      }
      return jsonDecode(res.body.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<T> delete<T>(String url, dynamic body, {String? token}) async {
    try {
      Uri uri = Uri.parse(_env.apiEndPoint + url);
      http.Response res = await http.delete(uri, body: body, headers: {
        "Authorization": token ?? await _auth.getToken() ?? '',
        "code": _env.companyGroupCode,
      });

      if (res.statusCode < 200 || 299 < res.statusCode) {
        dynamic json = jsonDecode(res.body.toString());
        throw json['message'] ?? json['error'] ?? '예기치못한 오류';
      }
      return jsonDecode(res.body.toString());
    } catch (e) {
      rethrow;
    }
  }
}
