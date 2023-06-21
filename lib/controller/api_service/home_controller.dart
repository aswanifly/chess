import 'dart:async';

import 'package:chess/api/api_constant.dart';
import 'package:chess/models/friend_req_details.dart';
import 'package:get/get.dart';

import '../../api/api_helper.dart';
import '../../models/all_users_details.dart';
import '../../models/player.dart';
import '../../models/user_detail_model.dart';
import 'login_signup_api.dart';

class HomeController extends GetxController {
  RxList<AllUsersDetails> allUsers = <AllUsersDetails>[].obs;
  RxList<FriendRequestDetail> friendRequestList = <FriendRequestDetail>[].obs;
  RxList dummyFriend = [].obs; //data dega
  RxList requestSendList = [].obs;
  final loginSignCont = Get.put(LoginAndSignUp());
  RxString message = "".obs;
  FriendRequestDetail? onePlayerReqDetail;
  RxString playingTime = "".obs;
  AllUsersDetails? singleUserDetails;
  RxBool blink = true.obs;

  @override
  void onInit() async {
    try {
      Timer.periodic(Duration(seconds: 2), (timer) async {
        friendRequestList.value = await friendRequest();
      });
    } catch (_) {
      print("went wrong");
    }
    super.onInit();
  }

  getAllUsers(String token) async {
    String url = GET_ALL_USER;
    List<AllUsersDetails> list = [];
    Map<String, dynamic> data = await ApiHelper().apiTypeGet(url, token);
    print("all the user details $data");
    for (int i = 0; i < data["allUsersData"].length; i++) {
      list.add(AllUsersDetails.fromJson(data["allUsersData"][i]));
    }
    allUsers.value = list;
  }

  Future<List<FriendRequestDetail>> friendRequest() async {
    String url = FRIEND_REQ;

    Map<String, dynamic> data = await ApiHelper()
        .apiTypeGet(url, loginSignCont.currentUserDetail!.token);
    // print(data["list"]);
    List<FriendRequestDetail> allReq = [];
    for (int i = 0; i < data["list"].length; i++) {
      allReq.add(FriendRequestDetail.fromJson(data["list"][i]));
    }
    return allReq;
  }

  Future sendFriendRequest(String id, String color, String time) async {
    String url = SEND_FRIEND_REQ;
    var jsonBody = {"reciverId": id, "colour": color, "time": time};
    print(jsonBody);
    try {
      Map<String, dynamic> data = await ApiHelper().apiType(
          url: url,
          jsonBody: jsonBody,
          token: loginSignCont.currentUserDetail!.token,
          methodType: 'POST');
      message.value = data["message"];
      print(data);
      return data;
    } catch (_) {
      rethrow;
    }
  }

  blinkText() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      blink.value = !blink.value;
    });
  }

  int checkFriendList(String userId) {
    // 0 -  send friend request // 1 - request not accepted // 2 - request accepted
    int status = 0;
    for (var i in friendRequestList) {
      if (i.userId == userId && i.status == 1) {
        status = 1;

        /// request not accepted
      } else if (i.userId == userId && i.status == 2) {
        status = 2;

        ///request accepted
      } else {
        status = 0;
      }
    }
    return status;
  }

  FriendRequestDetail? singleFriendReq(String userId) {
    for (var i in friendRequestList) {
      if (i.userId == userId) {
        onePlayerReqDetail = i;
        playingTime(i.time);
        print(i.time);
        return i;
      }
    }
    return null;
  }
}
