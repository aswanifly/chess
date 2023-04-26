import 'dart:convert';
import 'dart:io';

import 'package:chess/api/api_constant.dart';
import 'package:chess/api/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_detail_model.dart';

class LoginAndSignUp extends GetxController {
  final Rx<TextEditingController> nameC = TextEditingController().obs;
  final Rx<TextEditingController> emailC = TextEditingController().obs;
  final Rx<TextEditingController> passwordC = TextEditingController().obs;
  CurrentUserDetail? userDetails;
  RxString message = "".obs;
  final RxBool _tAndc = true.obs;

  final RxBool _rememberMe = false.obs;

  bool get tAndc => _tAndc.value;

  tAndC(bool value) => _tAndc.value = value;

  textEditingControllers() {
    nameC.value.text = "";
    emailC.value.text = "";
    passwordC.value.text = "";
  }

  login() async {
    String url = LOGIN;
    var jsonBody = {
      "Email": emailC.value.text.trim(),
      "PassWord": passwordC.value.text.trim()
    };
    try {
      Map<String, dynamic> data =
          await ApiHelper().apiTypePost(url: url, jsonBody: jsonBody);
      print("this is 200 -$data");
      userDetails = CurrentUserDetail(
          id: data["UserId"],
          userName: data["UserName"],
          email: data["UserEmail"],
          token: data["Token"]);
      return data;
    } catch (e) {
      rethrow;
      // var m = e as Map;
      // message.value = e["message"];
      // print("this is login cont ${message.value}");
    }
    // if (!data.containsKey("userDetails")) {
    //   message.value = data["message"];
    //
    //   return data;
    // }
    // userDetails = UserDetails.fromJson(data["userDetails"]);
    // if (_rememberMe.isTrue) {
    //   ///shared Prefs
    // }
    // return data;
  }

  signUp() async {
    String url = SIGNUP;
    var jsonBody = {
      "UserName": nameC.value.text,
      "Email": emailC.value.text,
      "PassWord": passwordC.value.text
    };

    try {
      Map<String, dynamic> data =
          await ApiHelper().apiTypePost(url: url, jsonBody: jsonBody);
      emailC.value.clear();
      passwordC.value.clear();
      nameC.value.clear();
      message.value = data["message"];
    } catch (e) {
      rethrow;
    }

  }

  bool get rememberMe => _rememberMe.value;

  toggleRememberMe(bool value) => _rememberMe.value = value;
}
