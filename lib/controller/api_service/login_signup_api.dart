import 'dart:convert';

import 'package:chess/api/api_constant.dart';
import 'package:chess/api/api_helper.dart';
import 'package:chess/exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_detail_model.dart';

class LoginAndSignUp extends GetxController {
  final Rx<TextEditingController> nameC = TextEditingController().obs;
  final Rx<TextEditingController> emailC = TextEditingController().obs;
  final Rx<TextEditingController> passwordC = TextEditingController().obs;
  CurrentUserDetail? currentUserDetail;
  RxString message = "".obs;
  final RxBool _tAndc = true.obs;
  final RxString opponentId = "".obs;

  // final RxBool _rememberMe = false.obs;

  bool get tAndc => _tAndc.value;

  // bool get rememberMe => _rememberMe.value;

  // toggleRememberMe(bool value) => _rememberMe.value = value;
  tAndC(bool value) => _tAndc.value = value;

  textEditingControllers() {
    nameC.value.clear();
    emailC.value.clear();
    passwordC.value.clear();
  }

  login() async {
    String url = LOGIN;
    var jsonBody = {
      "Email": emailC.value.text.trim(),
      "PassWord": passwordC.value.text.trim()
    };
    try {
      Map<String, dynamic> data =
          await ApiHelper().apiPost(url: url, jsonBody: jsonBody);
      print(" login 41 $data");

      ///shared prefs
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        "userEmail": emailC.value.text.trim(),
        "userPassword": passwordC.value.text.trim(),
      });
      textEditingControllers();
      prefs.setString("userData", userData);

      currentUserDetail = CurrentUserDetail(
          id: data["UserId"],
          userName: data["UserName"],
          email: data["UserEmail"],
          token: data["Token"]);

      return data;
    } catch (e) {
      rethrow;
    }
  }

  signUp() async {
    String url = SIGNUP;
    var jsonBody = {
      "UserName": nameC.value.text.trim(),
      "Email": emailC.value.text.trim(),
      "PassWord": passwordC.value.text.trim()
    };

    try {
      Map<String, dynamic> data =
          await ApiHelper().apiPost(url: url, jsonBody: jsonBody);
      textEditingControllers();
      message.value = data["message"];
    } catch (e) {
      rethrow;
    }
  }

  logout() async {
    textEditingControllers();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(()=>Login());
  }
}
