import 'package:chess/controller/api_service/home_controller.dart';
import 'package:chess/controller/loading_cont/laoding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/api_service/confirm_controller.dart';
import '../../controller/api_service/login_signup_api.dart';
import '../../controller/notification/push_notification.dart';
import '../../exports.dart';
import '../../models/all_users_details.dart';

class GameConfirmation extends StatefulWidget {
  final AllUsersDetails allUsersDetails;

  const GameConfirmation({Key? key, required this.allUsersDetails}) : super(key: key);

  @override
  State<GameConfirmation> createState() => _GameConfirmationState();
}

class _GameConfirmationState extends State<GameConfirmation> {
  final loginSignCont = Get.put(LoginAndSignUpController());

  final loadingController = Get.put(LoadingController());

  final confirmRequestCont = Get.put(ConfirmController());

  final HomeController homeController = Get.find();

  final pushNotification = Get.put(PushNotification());

  // final socketController = Get.put(SocketConnectionController());

  String? player1ID;

  String? player2ID;

  acceptRequest() async {
    try {
      loadingController.isLoading(true);
      Map<String, dynamic> data =
          await confirmRequestCont.confirmRequest(widget.allUsersDetails.userId!);
      print(" game confirmation ------++++++25 ${data.toString()}");
      player1ID =data["playerOne"];
      player2ID =data["playerTwo"];
      print(player1ID);
      print(player2ID);

      String token =
          await pushNotification.getUserTokenDB(widget.allUsersDetails.userId!);

      Map body = {
        "senderName": loginSignCont.currentUserDetail!.userName,
        "gameId": data["GmageId"],
        "screen": 2,
        "senderId": loginSignCont.currentUserDetail!.id,
        "color": homeController.onePlayerReqDetail!.colour,
        "time": homeController.playingTime.value,
        "player1UserId": player1ID,
        "player2UserId": player2ID,
      };
      print(body.toString());
      pushNotification.sendPushMessage(token, body, "Game Invitation");
      Get.off(
        () => StartGame(
          opponentName: widget.allUsersDetails.userName!,
          gameId: data["GmageId"],
          color: homeController.onePlayerReqDetail!.colour == "black"
              ? "white"
              : "black",
          player1ID: data["playerOne"],
          player2ID: data["playerTwo"],
          playingTime: homeController.playingTime.value,
        ),
      );
    } catch (e) {
      print(e);
    }
    loadingController.isLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black45,
              child: null,
            ),
            buildAlertDialog(context),
          ]),
        ),
      ),
    );
  }

  Widget buildAlertDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dpAndName(loginSignCont.currentUserDetail!.userName,
                    "assets/svg/7309681.jpg"),
                dpAndName(widget.allUsersDetails.userName!, "assets/svg/7309667.jpg")
              ],
            ),
            verticalHeight(height: 25.h),
            Text(
              "Accepted invitation of ${widget.allUsersDetails.userName}",
              style: black50014,
            ),
            Text(
                "opponents color :${homeController.onePlayerReqDetail!.colour}"),
            homeController.onePlayerReqDetail!.colour == "black"
                ? Text("Your Color :white")
                : Text("Your Color :black"),
            Text("Time : ${homeController.onePlayerReqDetail!.time}min"),
            verticalHeight(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                button("Cancel", red, () => Get.back()),
                horizontalWidth(width: 15.w),
                Obx(
                  () => button(
                    loadingController.loading ? "Loading" : "Accept",
                    green,
                    acceptRequest,
                  ),
                ),
              ],
            )
          ]),
    );
  }

  MaterialButton button(String name, Color color, Function()? ontap) =>
      MaterialButton(
        onPressed: ontap,
        height: 38.h,
        minWidth: 80.w,
        color: color,
        child: Text(
          name,
          style: white50016,
        ),
      );

  Column dpAndName(String userName, String image) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.black45,
          radius: 35.r,
          backgroundImage: AssetImage(image),
        ),
        verticalHeight(height: 18.h),
        Text(
          userName,
          style: black50016,
        ),
      ],
    );
  }
}
