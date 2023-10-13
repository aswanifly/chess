import 'package:chess/controller/api_service/game_controller.dart';
import 'package:chess/controller/socket/socket.dart';
import 'package:chess/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../constants/constant.dart';
import '../../controller/api_service/home_controller.dart';
import '../../controller/api_service/login_signup_api.dart';
import '../../models/winner_model.dart';

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
      this.player2ID,
      this.playingTime})
      : super(key: key);

  final loginAndSignUp = Get.put(LoginAndSignUpController());
  final gameController = Get.put(GameController());
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    homeController.playingTime(playingTime);
    gameController.gameId(gameId!);
    gameController.player1ID(player1ID!);
    gameController.player2ID(player2ID!);
    gameController.buttonSelected(0);
    final socketController = Get.put(SocketConnectionController());
    socketController.connectToSocket();
    // socketController.changesContinueButtonStatus(true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SizedBox(
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
                  opponentName: opponentName!,
                  gameId: gameId!,
                  color: color!,
                  player1Id: player1ID!,
                  player2Id: player2ID!,
                ),
              ]),
            ),
            // player 1 -> first who has send the request and 2nd one is the one who will accept the request
            Obx(() =>gameController.showDialogBox.value == true || socketController.endGameStatus.value == true ?  Material(
              color: Colors.transparent,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black45,
                child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.w),
                      padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                      height: 250.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(150, 0, 0, 0.3),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(right: 10.w,top: 5.h),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                    onTap: () {
                                      gameController.showDialogBox(false);
                                    },
                                    child: Icon(Icons.close))),
                          ),
                          verticalHeight(height: 10),
                         socketController.endGameStatus.value == true ? Text("Game Over",style: black50014,) :SizedBox(),
                          verticalHeight(height: 10),
                          Text("Who Won the Game ?",style: black50016,),
                          verticalHeight(height: 20),
                          SizedBox(
                            height: 30.h,
                            child: Obx(() => Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      gameController
                                          .buttonSelected.value = 1;
                                      gameController.winnerUserModel =
                                          WinnerUserModel(
                                            winnerName: loginAndSignUp
                                                .currentUserDetail!
                                                .userName,
                                            winnerId: loginAndSignUp
                                                .currentUserDetail!.id == player1ID! ? player1ID! : player2ID!,
                                            looserId: loginAndSignUp
                                                .currentUserDetail!.id == player1ID! ? player2ID! : player1ID!

                                          );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: gameController
                                            .buttonSelected
                                            .value ==
                                            1
                                            ? grey
                                            : null,
                                        border:
                                        Border.all(color: green),
                                        // borderRadius: BorderRadius.only(
                                        //     topLeft: Radius.circular(10.r),
                                        //     bottomLeft: Radius.circular(10.r)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        loginAndSignUp
                                            .currentUserDetail!
                                            .userName,
                                        style: black50012,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                                horizontalWidth(width: 15),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      gameController
                                          .buttonSelected.value = 2;
                                      gameController.winnerUserModel =
                                          WinnerUserModel(
                                            winnerName: opponentName!,
                                            winnerId: loginAndSignUp
                                                .currentUserDetail!.id ==player1ID! ? player2ID! : player1ID!,
                                            looserId: loginAndSignUp
                                                .currentUserDetail!.id ==player1ID! ? player1ID! : player2ID!,
                                          );

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: gameController
                                            .buttonSelected
                                            .value ==
                                            2
                                            ? grey
                                            : null,
                                        border:
                                        Border.all(color: green),
                                        // borderRadius: BorderRadius.only(
                                        //     topLeft: Radius.circular(10.r),
                                        //     bottomLeft: Radius.circular(10.r)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        opponentName!,
                                        style: black50012,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                             Obx(() =>  IgnorePointer(
                              ignoring  : socketController.endGameStatus.value,
                               child: MaterialButton(
                                 color:socketController.endGameStatus.value == true ? grey : Theme.of(context).primaryColor,
                                 onPressed: () {
                                   gameController.showDialogBox(false);
                                 },
                                 child: Text(
                                   "Cancel",
                                   style:socketController.endGameStatus.value == true ? black40013 : white40013,
                                 ),
                               ),
                             )),
                              MaterialButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {

                                  //asking both the user and for I am getting server error
                                  gameController.endGameApi().then((v){
                                    // if(v){
                                     socketController.endGameWithSocket(true);
                                      gameController.addCurrentUserMove();
                                      gameController.showDialogBox(false);
                                      Get.off(()=>MovementTracker(gameId: gameId!));
                                    // }
                                  });


                                  // if()


                                },
                                child: Text(
                                  "Okay",
                                  style: white40013,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            ) : SizedBox())
          ],
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
