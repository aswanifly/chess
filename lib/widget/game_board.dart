import 'dart:async';

import 'package:chess/models/moves.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/api_service/game_board_controller.dart';
import '../exports.dart';

// class GameBoard extends StatefulWidget {
//   const GameBoard({super.key});
//
//   @override
//   State<GameBoard> createState() => _GameBoardState();
// }
//
// class _GameBoardState extends State<GameBoard> {
//   final moves = TextEditingController();
//
//   List alphaAndNum = [
//     ["a", "b", "c", "d"],
//     ["e", "f", "g", "h"],
//     ["1", "2", "3", "4"],
//     ["5", "6", "7", "8"],
//   ];
//
//   List symbols = ["0-0", "0-0-0", "x", "+", "#"];
//
//   List tempList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           children: [
//             display(context),
//             SizedBox(
//               height: 75,
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(13)),
//                 child: GridView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: symbols.length,
//                     gridDelegate:
//                     const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 4),
//                     itemBuilder: (_, i) {
//                       return Center(
//                         child: Container(
//                             margin: EdgeInsets.only(bottom: 15),
//                             alignment: Alignment.center,
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 color: tempList.contains(symbols[i])
//                                     ? lightViolet
//                                     : null),
//                             child: Text(
//                               symbols[i],
//                               style: black50016,
//                             )),
//                       );
//                     }),
//               ),
//             ),
//             gameKeyBoard(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Expanded gameKeyBoard() {
//     return Expanded(
//       child: ListView.builder(
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: alphaAndNum.length,
//           itemBuilder: (_, i) {
//             List listIndex = alphaAndNum[i];
//             return SizedBox(
//                 height: 75,
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(13)),
//                   child: GridView.builder(
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: listIndex.length,
//                       gridDelegate:
//                       const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 4),
//                       itemBuilder: (_, i) {
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               if (tempList.contains(listIndex[i])) {
//                                 tempList.remove(listIndex[i]);
//                               } else {
//                                 tempList.add(listIndex[i]);
//                               }
//                               moves.text = tempList.join("");
//                             });
//                           },
//                           child: Center(
//                             child: Container(
//                                 margin: EdgeInsets.only(bottom: 15),
//                                 alignment: Alignment.center,
//                                 height: 40,
//                                 width: 40,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     color: tempList.contains(listIndex[i])
//                                         ? lightViolet
//                                         : null),
//                                 child: Text(
//                                   listIndex[i],
//                                   style: black50020,
//                                 )),
//                           ),
//                         );
//                       }),
//                 ));
//           }),
//     );
//   }
//
//   Widget display(BuildContext context) {
//     return Column(
//       children: [
//
//         ///play Button
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Text(
//             "Start Time",
//             style: black50016,
//           ),
//           MaterialButton(
//             onPressed: () {},
//             color: violet,
//             padding: EdgeInsets.symmetric(horizontal: 60),
//             child: Icon(
//               Icons.play_arrow,
//               color: Colors.white,
//             ),
//           ),
//           Text(
//             "End Game",
//             style: black50016,
//           )
//         ]),
//
//         ///clear continue button
//         Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       tempList.clear();
//                       moves.clear();
//                     });
//                   },
//                   child: button(context, "Clear", red, red50016)),
//             ),
//             Expanded(
//                 child: TextField(
//                   controller: moves,
//                   enabled: false,
//                   textAlign: TextAlign.center,
//                   decoration: InputDecoration(
//                       filled: true,
//                       fillColor: grey,
//                       contentPadding: EdgeInsets.only(left: 10),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12))),
//                 )),
//             Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: GestureDetector(
//                   onTap: () {
//                     print("object");
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => MovementTracker()));
//                   },
//                   child: button(context, "Continue", green, green50016)),
//             )
//           ],
//         )
//       ],
//     );
//   }
//
//   Container button(BuildContext context, String name, Color color,
//       TextStyle style) {
//     return Container(
//       alignment: Alignment.center,
//       height: 40,
//       width: 97,
//       padding: EdgeInsets.all(5),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white,
//           border: Border.all(color: color)),
//       child: Text(
//         name,
//         style: style,
//       ),
//     );
//   }
// }

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final controller = Get.put(GameBoardController());

  final List alphaAndNum = [
    ["a", "b", "c", "d"],
    ["e", "f", "g", "h"],
    ["1", "2", "3", "4"],
    ["5", "6", "7", "8"],
  ];

  final List symbols = ["0-0", "0-0-0", "x", "+", "#"];

  Duration duration = Duration();

  Timer? timer;

  bool timerStarted = false;
  bool startGame = false;

  void startTimer() {
    setState(() {
      timerStarted = true;
      startGame = true;
    });
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    const addSecond = 1;
    setState(() {
      final second = duration.inSeconds + addSecond;
      duration = Duration(seconds: second);
    });
  }

  // void resetTimer({bool reset = false}) {
  //   if (reset) {
  //     reset();
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            display(context),
            SizedBox(
              height: 75,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: symbols.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                    itemBuilder: (_, i) {
                      return Center(
                        child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            alignment: Alignment.center,
                            height: 40,
                            width: 40,
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(20),
                            //     color: tempList.contains(symbols[i])
                            //         ? lightViolet
                            //         : null),
                            child: Text(
                              symbols[i],
                              style: black50016,
                            )),
                      );
                    }),
              ),
            ),
            gameKeyBoard(),
          ],
        ),
      ),
    );
  }

  Expanded gameKeyBoard() {
    return Expanded(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: alphaAndNum.length,
          itemBuilder: (_, i) {
            List listIndex = alphaAndNum[i];
            return SizedBox(
                height: 75,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listIndex.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemBuilder: (_, i) {
                        return Obx(() => GestureDetector(
                              onTap: () {
                                if (!timerStarted) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Please start timer")));
                                  return;
                                }
                                if (controller.buttonsList
                                    .contains(listIndex[i])) {
                                  controller.buttonsList.remove(listIndex[i]);
                                } else {
                                  controller.buttonsList.add(listIndex[i]);
                                }
                                // if (controller.buttonsList
                                //     .contains(listIndex[i])) {
                                //   controller.buttonsList.remove(listIndex[i]);
                                // } else {
                                //   controller.buttonsList.add(listIndex[i]);
                                // }
                              },
                              child: Center(
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: controller.buttonsList
                                                .contains(listIndex[i])
                                            ? lightViolet
                                            : null),
                                    child: Text(
                                      listIndex[i],
                                      style: black50020,
                                    )),
                              ),
                            ));
                      }),
                ));
          }),
    );
  }

  Widget display(BuildContext context) {
    String twoDigit(int n) => n.toString().padLeft(2, "0");
    final minute = twoDigit(duration.inMinutes.remainder(60));
    final second = twoDigit(duration.inSeconds.remainder(60));
    final isRunning = timer == null ? false : timer!.isActive;
    return Column(
      children: [
        ///play Button
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          isRunning
              ? GestureDetector(
                  onTap: () {
                    if (isRunning) {
                      setState(() {
                        timerStarted = false;
                        timer?.cancel();
                      });
                    }
                  },
                  child: Text(
                    "Stop Time",
                    style: black50016,
                  ),
                )
              : GestureDetector(
                  onTap: startTimer,
                  child: Text(
                    "Start Time",
                    style: black50016,
                  ),
                ),
          MaterialButton(
              onPressed: () {},
              color: violet,
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                "$minute : $second",
                style: white50016,
              )),
          GestureDetector(
            onTap: () {
              if (!startGame) {
                Get.showSnackbar(GetSnackBar(
                  message: "Please start the game",
                  duration: Duration(seconds: 1),
                ));
                return;
              }
              if (isRunning) {
                setState(() {
                  timer?.cancel();
                });
              }
              controller.endTime.value = "$minute:$second";
              Get.to(MovementTracker());
            },
            child: Text(
              "End Game",
              style: black50016,
            ),
          )
        ]),

        ///clear continue button
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                  onTap: () {
                    controller.clearAllMoves();
                  },
                  child: button(context, "Clear", red, red50016)),
            ),
            Expanded(
                child: Container(
              height: 40,
              padding: EdgeInsets.all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: grey,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              child: Obx(() {
                controller.displayMoves.value = controller.buttonsList.join('');
                return Text(
                  controller.displayMoves.value,
                  overflow: TextOverflow.ellipsis,
                  style: black60022,
                );
              }),
            )),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                  onTap: () {
                    if (!timerStarted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please start timer")));
                      return;
                    }
                    controller.addMoves(Moves(
                        moveTime: "$minute:$second",
                        playerMove: controller.displayMoves.value));
                  },
                  child: button(context, "Continue", green, green50016)),
            )
          ],
        )
      ],
    );
  }

  Container button(
      BuildContext context, String name, Color color, TextStyle style) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: 97,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: color)),
      child: Text(
        name,
        style: style,
      ),
    );
  }
}
