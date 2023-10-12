// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:chess/controller/socket/socket.dart';
import 'package:chess/models/winner_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../constants/constant.dart';
import '../controller/api_service/game_controller.dart';
import '../controller/api_service/login_signup_api.dart';
import '../exports.dart';
import '../models/message_model.dart';

class GameBoard extends StatefulWidget {
  final String? opponentName;
  final String? gameId;
  final String? color;
  final String player1Id;
  final String player2Id;

  const GameBoard({Key? key, this.opponentName, this.gameId, this.color,required this.player1Id,required this.player2Id})
      : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final controller = Get.put(GameController());

  Duration duration = Duration();

  Timer? timer;

  bool timerStarted = false;
  bool startGame = false;

  final gameController = Get.put(GameController());
  final loginAndSignUp = Get.put(LoginAndSignUpController());
  SocketConnectionController socketController = Get.find();

  // void startTimer() {
  //   setState(() {
  //     timerStarted = true;
  //     startGame = true;
  //   });
  //   timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  // }
  //
  // void addTime() {
  //   const addSecond = 1;
  //   setState(() {
  //     final second = duration.inSeconds + controller.minute.value + addSecond;
  //     duration = Duration(seconds: second);
  //   });
  // }

  // void resetTimer({bool reset = false}) {
  //   if (reset) {
  //     reset();
  //   }
  // }

  Future<void> confirmMoves() async {
    controller.pieceMove();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm Move"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Confirm Move ${controller.displayMoves.value}",
                  style: black60012,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!controller.checkMove())
                  Text(
                    "Wrong Move(eg.Q+a+5)",
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.red,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
              ],
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              IgnorePointer(
                ignoring: !controller.checkMove(),
                child: TextButton(
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                        color: !controller.checkMove() ? Colors.grey : green),
                  ),
                  onPressed: () async {
                    // controller.addToLocalStorage(
                    //   Moves(
                    //       moveTime: time,
                    //       playerMove: controller.displayMoves.value),
                    // );
                    // gameController.moveList.add(Moves(
                    //     moveTime: "",
                    //     playerMove: controller.displayMoves.value));
                    await sendMove();
                    Get.back();
                  },
                ),
              ),
            ],
          );
        });
  }

  getMoves() {
    var data = gameController.getMoves();
    return data;
  }

  sendMove() async {
    // socketController.sendMessage(
    //     "gameID", "userId", "move", !socketController.isActive.value);
    // controller.pieceMove();
    await controller.sendMove(socketController.time.value);
    if(loginAndSignUp.currentUserDetail!.id == gameController.player1ID.value && socketController.neutralContinueButton.isTrue){
      socketController.changesContinueButtonStatus(false);
    }else if(loginAndSignUp.currentUserDetail!.id == gameController.player2ID.value && socketController.neutralContinueButton.isTrue){
      socketController.changesContinueButtonStatus(true);
    }else{
      socketController.changesContinueButtonStatus(!socketController.continueButtonStatus.value);
    }
  }

  @override
  void initState() {
    Logger().i("gameId ${widget.gameId}");
    duration = Duration(
        seconds: controller.second.value, minutes: controller.minute.value);
    controller.opponentName.value = widget.opponentName!;
    controller.gameId.value = widget.gameId!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if(socketController.endGameStatus.value == true) {
    //   showEndGameDialog(context);
    // }
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.h),
        child: Column(
          children: [
            display(context),
            buildPieces(),
            buildSpecialKeys(),
            gameKeyBoard(),
            buildAllMovesDisplay(),
            // Obx(() => socketController.second.value < 0 ? Text("Time Finished"): SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget display(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Column(
        children: [
          ///play Button
          /// start button, timer, end time button
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            // isRunning
            //     ? GestureDetector(
            //         onTap: () {
            //           if (isRunning) {
            //             setState(() {
            //               timerStarted = false;
            //               timer?.cancel();
            //             });
            //           }
            //         },
            //         child: Text(
            //           "Pause Time",
            //           style: black50015,
            //         ),
            //       ):

            ///start game button
//             Obx(() => loginAndSignUp.currentUserDetail!.id ==
//                     gameController.player1ID.value
//                 ? socketController.gameStarted.isFalse
//                     ? GestureDetector(
//                         onTap: () {
//                           socketController.sendMessage(
//                               "gameID", "userId", "mm1", true);
//                           socketController.gameStarted(true);
//                           chessGameStarted(true);
//                         },
//                         child: Text(
//                           "Start Time",
//                           style: black50015,
//                         ),
//                       )
//                     : SizedBox()
//                 : SizedBox()),
            ///timer section->
//             MaterialButton(
//                 onPressed: () {},
//                 color: violet,
//                 padding: EdgeInsets.symmetric(horizontal: 46.w),
//                 child: Obx(() => Text(
//                       socketController.time.value,
//                       style: white50016,
//                     ))),
            InkWell(
              onTap: () {
                // if (!startGame) {
                //   Get.showSnackbar(GetSnackBar(
                //     message: "Please start the game",
                //     duration: Duration(seconds: 1),
                //   ));
                //   return;
                // }
                // if (isRunning) {
                //   setState(() {
                //     timer?.cancel();
                //   });
                // }
                // controller.endTime.value = "$minute:$second";

                // Get.to(() => MovementTracker());

                // Get.to(()=>MovementTracker(gameId: widget.gameId!,));
                // showEndGameDialog(context);
                gameController.showDialogBox(true);
              },
              child: Text(
                // "${socketController.isActive}",
                "End Game",
                style: black50015,
              ),
            ),
          ]),
          verticalHeight(height: 5),

          ///clear continue button
          Row(
            children: [
              ///clear
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: GestureDetector(
                    onTap: controller.clearButtonList,
                    child: button(context, "Clear", red, red50016)),
              ),

              ///display
              Expanded(
                  child: Container(
                height: 35.h,
                padding: EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: grey,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.r)),
                child: Obx(() {
                  // controller.displayMoves.value =
                  //     controller.buttonsList.join('');
                  return Text(
                    controller.buttonsList.join(''),
                    overflow: TextOverflow.ellipsis,
                    style: black50016,
                  );
                }),
              )),

              ///continue
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: continueButton(context),
              )
            ],
          )
        ],
      ),
    );
  }

  // Future<void> showEndGameDialog(BuildContext context) {
  //   return showDialog(
  //                 context: context,
  //                 builder: (context) {
  //                   return AlertDialog(
  //                       title: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             "Who Won the Game ?",
  //                             style: black50016,
  //                           ),
  //                           InkWell(
  //                               onTap: () {
  //                                 Get.back();
  //                               },
  //                               child: Icon(Icons.close)),
  //                         ],
  //                       ),
  //                       content: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           verticalHeight(height: 20),
  //                           SizedBox(
  //                             height: 30.h,
  //                             child: Obx(() => Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.center,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     Expanded(
  //                                       child: GestureDetector(
  //                                         onTap: () {
  //                                           gameController
  //                                               .buttonSelected.value = 1;
  //                                           gameController.winnerUserModel =
  //                                               WinnerUserModel(
  //                                             winnerName: loginAndSignUp
  //                                                 .currentUserDetail!
  //                                                 .userName,
  //                                             winnerId: loginAndSignUp
  //                                                 .currentUserDetail!.id == widget.player1Id ? widget.player1Id : widget.player2Id,
  //
  //                                           );
  //                                           print(gameController.winnerUserModel!.winnerName);
  //                                           print(gameController.winnerUserModel!.winnerId);
  //                                         },
  //                                         child: Container(
  //                                           decoration: BoxDecoration(
  //                                             color: gameController
  //                                                         .buttonSelected
  //                                                         .value ==
  //                                                     1
  //                                                 ? grey
  //                                                 : null,
  //                                             border:
  //                                                 Border.all(color: green),
  //                                             // borderRadius: BorderRadius.only(
  //                                             //     topLeft: Radius.circular(10.r),
  //                                             //     bottomLeft: Radius.circular(10.r)),
  //                                           ),
  //                                           alignment: Alignment.center,
  //                                           child: Text(
  //                                             loginAndSignUp
  //                                                 .currentUserDetail!
  //                                                 .userName,
  //                                             style: black50012,
  //                                             overflow: TextOverflow.ellipsis,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     horizontalWidth(width: 15),
  //                                     Expanded(
  //                                       child: GestureDetector(
  //                                         onTap: () {
  //                                           gameController
  //                                               .buttonSelected.value = 2;
  //                                           gameController.winnerUserModel =
  //                                               WinnerUserModel(
  //                                                 winnerName: widget.opponentName!,
  //                                                 winnerId: loginAndSignUp
  //                                                     .currentUserDetail!.id ==widget.player2Id ? widget.player1Id : widget.player2Id,
  //                                               );
  //                                           print(gameController.winnerUserModel!.winnerName);
  //                                           print(gameController.winnerUserModel!.winnerId);
  //
  //                                         },
  //                                         child: Container(
  //                                           decoration: BoxDecoration(
  //                                             color: gameController
  //                                                         .buttonSelected
  //                                                         .value ==
  //                                                     2
  //                                                 ? grey
  //                                                 : null,
  //                                             border:
  //                                                 Border.all(color: green),
  //                                             // borderRadius: BorderRadius.only(
  //                                             //     topLeft: Radius.circular(10.r),
  //                                             //     bottomLeft: Radius.circular(10.r)),
  //                                           ),
  //                                           alignment: Alignment.center,
  //                                           child: Text(
  //                                             widget.opponentName!,
  //                                             style: black50012,
  //                                             overflow: TextOverflow.ellipsis,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 )),
  //                           ),
  //                           // Text("Or"),
  //                           // GestureDetector(
  //                           //   onTap: () {
  //                           //     gameController.buttonSelected.value = 1;
  //                           //   },
  //                           //   child: Container(
  //                           //     decoration: BoxDecoration(
  //                           //       color: gameController
  //                           //           .buttonSelected.value ==
  //                           //           1
  //                           //           ? grey
  //                           //           : null,
  //                           //       border: Border.all(color: green),
  //                           //       // borderRadius: BorderRadius.only(
  //                           //       //     topLeft: Radius.circular(10.r),
  //                           //       //     bottomLeft: Radius.circular(10.r)),
  //                           //     ),
  //                           //     alignment: Alignment.center,
  //                           //     child: Text(
  //                           //       "Draw",
  //                           //       style: black50012,
  //                           //       overflow: TextOverflow.ellipsis,
  //                           //     ),
  //                           //   ),
  //                           // ),
  //                           verticalHeight(height: 50.h),
  //                           Row(
  //                             mainAxisAlignment:
  //                                 MainAxisAlignment.spaceAround,
  //                             children: [
  //                               MaterialButton(
  //                                 color: Theme.of(context).primaryColor,
  //                                 onPressed: () {
  //                                   Get.back();
  //                                 },
  //                                 child: Text(
  //                                   "Cancel",
  //                                   style: white40013,
  //                                 ),
  //                               ),
  //                               MaterialButton(
  //                                 color: Theme.of(context).primaryColor,
  //                                 onPressed: () {},
  //                                 child: Text(
  //                                   "Okay",
  //                                   style: white40013,
  //                                 ),
  //                               ),
  //                             ],
  //                           )
  //                         ],
  //                       ));
  //                 });
  // }

  Widget continueButton(BuildContext context) {
    // return Obx(() => GestureDetector(
    //   onTap: confirmMoves,
    //   // onTap: () {
    //   //   // if (!timerStarted || controller.buttonsList.isEmpty) {
    //   //   //   ScaffoldMessenger.of(context).clearSnackBars();
    //   //   //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   //   //       content: Text("Timer not running or no Move")));
    //   //   //   return;
    //   //   // }
    //   //
    //   //   controller.pieceMove();
    //   //   confirmMoves("$minute:$second");
    //   //   print(controller.displayMoves.value);
    //   // },
    //   child: button(
    //     context,
    //     "Continue",
    //    socketController.continueStatus.value == true ? green,
    //     green50016,
    //   ),
    // ));

    ///obx widget of continue button
    return Obx(() {
      if (loginAndSignUp.currentUserDetail!.id ==
              gameController.player1ID.value &&
          socketController.continueButtonStatus.isFalse && socketController.neutralContinueButton.isFalse) {
        return IgnorePointer(
          ignoring: true,
          child: GestureDetector(
            onTap: confirmMoves,
            child: button(
              context,
              "Continue",
              Colors.grey,
              TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        );
      } else if (loginAndSignUp.currentUserDetail!.id ==
              gameController.player2ID.value &&
          socketController.continueButtonStatus.isTrue && socketController.neutralContinueButton.isFalse) {
        return IgnorePointer(
          ignoring: true,
          child: GestureDetector(
              onTap: confirmMoves,
              child: button(
                  context,
                  "Continue",
                  Colors.grey,
                  TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500))),
        );
      } else {
        return GestureDetector(
            onTap: confirmMoves,

            child: button(context, "Continue", green, green50016));
      }
    });
  }

  Widget buildPieces() {
    return SizedBox(
      height: 150.h,
      width: double.infinity,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: chessPieces[widget.color!].length / 3.8,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3),
          itemCount: chessPieces[widget.color!].length,
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: () {
                controller.currentPiece.value = i;
              },
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                      color: controller.currentPiece.value == i
                          ? Colors.grey[100]
                          : null,
                      borderRadius: BorderRadius.circular(15.r),
                      border: controller.currentPiece.value == i
                          ? Border.all(color: green)
                          : null),
                  child: SvgPicture.asset(
                    chessPieces[widget.color!][i]["imagePath"],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget buildSpecialKeys() {
    ///obx will check for timeout
    // return Obx(() => );
    return Stack(
      children: [
        SizedBox(
          height: 45.h,
          width: double.infinity,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.r)),
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: symbols.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6),
                itemBuilder: (_, i) {
                  return Obx(() => GestureDetector(
                        onTap: () {
                          controller.buttonsList.add(symbols[i]);
                        },
                        child: Center(
                          child: Container(
                              margin: EdgeInsets.only(bottom: 15.h),
                              alignment: Alignment.center,
                              height: 30.h,
                              width: 30.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: controller.buttonsList
                                          .contains(symbols[i])
                                      ? lightViolet
                                      : null),
                              child: Text(
                                symbols[i],
                                style: black50012,
                              )),
                        ),
                      ));
                }),
          ),
        ),
        // if (socketController.second.value < 0)
        //   Container(
        //     height: 48.h,
        //     width: double.infinity,
        //     color: Colors.black45,
        //     child: Center(child: Text("Time Over")),
        //   )
      ],
    );
  }

  Widget gameKeyBoard() {
    //obx will keep on checking for timeout
    // return Obx(() => );
    return Stack(
      children: [
        SizedBox(
          height: 185.h,
          width: double.infinity,
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: alphaAndNum.length,
              itemBuilder: (_, i) {
                List listIndex = alphaAndNum[i];
                return SizedBox(
                    height: 45.h,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: listIndex.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                          itemBuilder: (_, i) {
                            return Obx(() => GestureDetector(
                                  onTap: () {
                                    // if (!timerStarted) {
                                    //   ScaffoldMessenger.of(context)
                                    //       .clearSnackBars();
                                    //   ScaffoldMessenger.of(context).showSnackBar(
                                    //       SnackBar(
                                    //           content: Text("Please start timer")));
                                    //   return;
                                    // }
                                    // --------------up work

                                    // if (controller.buttonsList
                                    //     .contains(listIndex[i])) {
                                    //   controller.buttonsList.remove(listIndex[i]);
                                    // } else {
                                    //   controller.buttonsList.add(listIndex[i]);
                                    // }
                                    controller.buttonsList.add(listIndex[i]);
                                  },
                                  child: Center(
                                    child: Container(
                                        margin: EdgeInsets.only(bottom: 38.h),
                                        alignment: Alignment.center,
                                        height: 30.h,
                                        width: 30.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.r),
                                            color: controller.buttonsList
                                                    .contains(listIndex[i])
                                                ? lightViolet
                                                : null),
                                        child: Text(
                                          listIndex[i],
                                          style: black50014,
                                        )),
                                  ),
                                ));
                          }),
                    ));
              }),
        ),
        // if (socketController.second.value < 0)
        //   Container(
        //     height: 185.h,
        //     width: double.infinity,
        //     color: Colors.black45,
        //     child: Center(child: Text("Time Over")),
        //   )
      ],
    );
  }

  Expanded buildAllMovesDisplay() {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: StreamBuilder(
          stream: Stream.periodic(Duration(milliseconds: 500))
              .asyncMap((_) => getMoves()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> list = snapshot.data!;
              controller.fetchedMoveList = list;

              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    int reverseIndex = list.length -
                        1 -
                        i; //reversing the list and showing to the top most
                    ChatMessage chatMessage =
                        ChatMessage.fromJson(list[reverseIndex]);
                    return messages(chatMessage, reverseIndex);
                  });
              return Text("data");
            } else if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget messages(ChatMessage chatMessage, i) {
    return Container(
      width: double.infinity,
      alignment: chatMessage.userId == loginAndSignUp.currentUserDetail!.id
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.grey),
        child: Text(
          chatMessage.move!,
          style: TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Container button(
      BuildContext context, String name, Color color, TextStyle style) {
    return Container(
      alignment: Alignment.center,
      height: 35.h,
      width: 90.w,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          border: Border.all(color: color)),
      child: Text(
        name,
        style: style,
      ),
    );
  }
}
