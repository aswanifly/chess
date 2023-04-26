import 'dart:async';

import 'package:chess/api/api_constant.dart';
import 'package:get/get.dart';

import '../../api/api_helper.dart';
import '../../models/all_users_details.dart';
import '../../models/user_detail_model.dart';
import 'login_signup_api.dart';

class HomeController extends GetxController {
  RxList<AllUsersDetails> allUsers = <AllUsersDetails>[].obs;
  RxList friendRequestList = [].obs;
  RxList dummyFriend = [].obs; //data dega
  final loginSignCont = Get.put(LoginAndSignUp());
  RxString message = "".obs;

  @override
  void onInit() async {
    // Timer.periodic(Duration(seconds: 3), (timer){
    //   // if(friendRequestList.isNotEmpty){
    //   //   dummyFriend= friendRequestList;
    //   // }
    //
    // });
    // super.onInit();

    Timer.periodic(Duration(seconds: 2), (timer) async {
      friendRequestList.value = await friendRequest();
      // print(friendRequestList.toString());
      // print(friendRequestList.length);
    });
    super.onInit();
  }

  getAllUsers(String token) async {
    String url = GET_ALL_USER;
    Map<String, dynamic> data = await ApiHelper().apiTypeGet(url, token);
    for (int i = 0; i < data["allUsersData"].length; i++) {
      // allUsers.add(CurrentUserDetail.fromJson(data["allUsersData"][i]));
      allUsers.add(AllUsersDetails.fromJson(data["allUsersData"][i]));
    }
    print(allUsers.length);
  }

  Future<List<dynamic>> friendRequest() async {
    String url = FRIEND_REQ;

    Map<String, dynamic> data =
        await ApiHelper().apiTypeGet(url, loginSignCont.userDetails!.token);
    return data["list"];
  }

  Future sendFriendRequest(String id) async {
    String url = SEND_FRIEND_REQ;
    var jsonBody = {"reciverId": id};
    Map<String, dynamic> data = await ApiHelper().apiTypeHeaderPost(
        url: url,
        jsonBody: jsonBody,
        token: loginSignCont.userDetails!.token,
        methodType: 'POST');
    message.value = data["message"];
    print(data);
    return data;
  }
}
