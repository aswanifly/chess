import 'package:chess/api/api_helper.dart';
import 'package:get/get.dart';

import '../../api/api_constant.dart';
import 'login_signup_api.dart';

class CnfrmAndColorController extends GetxController {
  RxString selectedColor = "".obs;
  RxInt selectedColorIndex = 0.obs;

  final loginSignCont = Get.put(LoginAndSignUp());

  confirmRequest(String id) async {
    String url = CONFIRM_REQUEST;
    var jsonBody = {"senderId": id, "status": "confirm"};
    Map<String, dynamic> data = await ApiHelper().apiTypeHeaderPost(
        url: url,
        jsonBody: jsonBody,
        token: loginSignCont.userDetails!.token,
        methodType: 'PUT');
    return data;
  }
}
