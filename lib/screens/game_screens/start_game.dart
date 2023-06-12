import 'package:chess/controller/api_service/game_controller.dart';
import 'package:chess/controller/socket/socket.dart';
import 'package:chess/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constants/constant.dart';
import '../../controller/api_service/confirm_controller.dart';
import '../../controller/api_service/home_controller.dart';
import '../../controller/api_service/login_signup_api.dart';

class StartGame extends StatelessWidget {
  final String? opponentName;
  final String? gameId;
  final String? color;
  final String? player1ID;
  final String? player2ID;
  final String? playingTime;

  StartGame(
      {Key? key,
      this.opponentName,
      this.gameId,
      this.color,
      this.player1ID,
      this.player2ID,this.playingTime})
      : super(key: key);

  final loginAndSignUp = Get.put(LoginAndSignUp());
  final gameController =Get.put(GameController());
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    homeController.playingTime(playingTime);
    gameController.gameId(gameId!);
    gameController.player1ID(player1ID!);
    gameController.player2ID(player2ID!);
    final socketController = Get.put(SocketConnectionController());
    socketController.connectToSocket();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(children: [
            topBar(context),
            Divider(
              height: 0,
              thickness: 1.w,
              indent: 0,
            ),
            GameBoard(
                opponentName: opponentName!, gameId: gameId!, color: color!),
          ]),
        ),
      ),
    );
  }

  Padding topBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () => Get.back(), child: Icon(Icons.arrow_back)),
              horizontalWidth(width: 10.w),
              CircleAvatar(
                // backgroundColor: Colors.grey,
                backgroundImage: AssetImage("assets/svg/7309681.jpg"),
              ),
              horizontalWidth(width: 8.w),
              Text(
                loginAndSignUp.currentUserDetail!.userName,
                style: black50015,
              ),
              SvgPicture.asset(pieceColorPath[color]),
              Spacer(),
              // Text(
              //   "vs",
              //   style: black50015,
              // ),
              Spacer(),
              color == "white"
                  ? SvgPicture.asset(pieceColorPath["black"])
                  : SvgPicture.asset(pieceColorPath["white"]),
              Text(
                opponentName!,
                style: black50015,
              ),

              horizontalWidth(width: 8.w),
              CircleAvatar(
                backgroundImage: AssetImage("assets/svg/7309667.jpg"),
                // backgroundColor: Colors.grey,
              ),
            ],
          ),
          // verticalHeight(height: 8.h),
          // Row(
          //   children: [
          //     SvgPicture.asset(pieceColorPath[color]),
          //     horizontalWidth(width: 13.w),
          //     Text(
          //       "12 points",
          //       style: violet50013,
          //     ),
          //     Spacer(),
          //     color == "white"
          //         ? SvgPicture.asset(pieceColorPath["black"])
          //         : SvgPicture.asset(pieceColorPath["white"]),
          //     horizontalWidth(width: 13.w),
          //     Text(
          //       "10 points",
          //       style: violet50013,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
