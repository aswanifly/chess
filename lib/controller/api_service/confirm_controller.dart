import 'dart:convert';

import 'package:chess/api/api_helper.dart';
import 'package:get/get.dart';

import '../../api/api_constant.dart';
import 'login_signup_api.dart';

class ConfirmController extends GetxController {
  RxString selectedColor = "".obs;
  RxInt selectedColorIndex = 0.obs;
  RxInt selectedTimingTile = 0.obs;
  RxInt selectedTiming = 0.obs;


  ///controller
  final loginSignCont = Get.put(LoginAndSignUpController());

  confirmRequest(String id) async {
    String url = CONFIRM_REQUEST;
    var jsonBody = {"senderId": id, "status": "2"};
    // print(jsonBody);
    var data = await ApiHelper().apiType(
      url: url,
      jsonBody: jsonBody,
      token: loginSignCont.currentUserDetail!.token,
      methodType: 'PUT',
    );
    // print(data);
    return data;
  }
}
