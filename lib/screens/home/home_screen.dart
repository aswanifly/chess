import 'dart:async';

import 'package:chess/controller/api_service/game_controller.dart';
import 'package:chess/controller/loading_cont/laoding_controller.dart';
import 'package:chess/controller/socket/socket.dart';
import 'package:chess/models/friend_req_details.dart';
import 'package:chess/models/user_detail_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constant.dart';
import '../../controller/api_service/confirm_controller.dart';
import '../../controller/api_service/home_controller.dart';
import '../../controller/api_service/login_signup_api.dart';
import '../../controller/notification/push_notification.dart';
import '../../exports.dart';
import '../../models/all_users_details.dart';
import '../../widget/time_tile.dart';

class HomeScreen extends StatefulWidget {
  final bool? gameIsRunning;

  const HomeScreen({Key? key, this.gameIsRunning = false}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool selected = false;
  int? currentIndex;
  final homeController = Get.put(HomeController());
  final loginAndSignUp = Get.put(LoginAndSignUp());
  final loadingCont = Get.put(LoadingController());
  final pushNotification = Get.put(PushNotification());
  bool _isloading = false;
  final searchController = TextEditingController();
  final confrmAndColorController = Get.put(ConfirmController());
  List<AllUsersDetails> searchUser = [];

  getAllUsers() async {
    setState(() {
      _isloading = true;
    });

    await homeController.getAllUsers(loginAndSignUp.currentUserDetail!.token);
    setState(() {
      _isloading = false;
    });
  }

  void runFilter(String query) {
    List<AllUsersDetails> results = [];
    if (query.isEmpty) {
      results = homeController.allUsers;
    } else {
      results = homeController.allUsers
          .where((e) => e.userName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      searchUser = results;
    });
  }

  sendNotification(String senderName, String id) async {
    var token = await pushNotification.getUserTokenDB(id);
    print("this is token $token");
    Map body = {
      "senderName": loginAndSignUp.currentUserDetail!.userName,
      "screen": 1,
    };
    pushNotification.sendPushMessage(token, body, "New Friend Request");
  }

  onRefresh() async {
    await homeController.getAllUsers(loginAndSignUp.currentUserDetail!.token);
  }

  logout() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Do you want to logout"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: loginAndSignUp.logout,
                child: const Text('Logout'),
              ),
            ],
          );
        });
  }


  sendRequest(AllUsersDetails allUsersDetails) async {
    await homeController.sendFriendRequest(
        allUsersDetails.userId!,
        confrmAndColorController.selectedColor.value,
        confrmAndColorController.selectedTiming.value.toString());

    sendNotification(
        loginAndSignUp.currentUserDetail!.userName, allUsersDetails.userId!);
    confrmAndColorController.selectedColor.value = '';
    confrmAndColorController.selectedTiming.value = 0;
    Get.back();
    Get.showSnackbar(GetSnackBar(
      duration: Duration(seconds: 1),
      message: homeController.message.value,
    ));
  }

  @override
  void initState() {
    pushNotification.initInfo();
    getAllUsers();
    searchUser = homeController.allUsers;
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to exit?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: SafeArea(
        child: Scaffold(
          body: _isloading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: green,
                  ),
                )
              : SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profileAndName(),
                        verticalHeight(height: 23.h),
                        Row(
                          children: [
                            Text(
                              "Choose Player",
                              style: black50020,
                            ),
                            // Spacer(),
                            // widget.gameIsRunning!
                            //     ? GestureDetector(
                            //         onTap: () {
                            //           final gameController =
                            //               Get.put(GameBoardController());
                            //           Get.to(() => StartGame(
                            //                 gameId: gameController.gameId.value,
                            //                 opponentName: gameController
                            //                     .opponentName.value,
                            //               ));
                            //         },
                            //         child: Chip(
                            //           shape: StadiumBorder(
                            //               side: BorderSide(
                            //             width: 1,
                            //             color: Colors.redAccent,
                            //           )),
                            //           avatar: Obx(() => Container(
                            //                 height: 10.h,
                            //                 width: 10.w,
                            //                 decoration: BoxDecoration(
                            //                   borderRadius:
                            //                       BorderRadius.circular(5.r),
                            //                   color: homeController.blink.isTrue
                            //                       ? green.withOpacity(0.7)
                            //                       : Colors.transparent,
                            //                 ),
                            //               )),
                            //           label: Text(
                            //             "Game",
                            //             style: TextStyle(color: green),
                            //           ),
                            //         ),
                            //       )
                            //     : SizedBox()
                          ],
                        ),
                        verticalHeight(height: 13.h),
                        TextField(
                          controller: searchController,
                          onChanged: (value) => runFilter(value),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {}, icon: Icon(Icons.search)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 5.h),
                              hintText: "Search name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r))),
                        ),
                        Expanded(
                            child: RefreshIndicator(
                          onRefresh: () async {
                            await homeController.getAllUsers(
                                loginAndSignUp.currentUserDetail!.token);
                            setState(() {
                              searchUser = homeController.allUsers;
                            });
                          },
                          color: green,
                          child: ListView.builder(
                              itemCount: searchUser.length,
                              itemBuilder: (_, i) {
                                AllUsersDetails allUsersDetails = searchUser[i];
                                return buildPlayerCard(
                                    context, allUsersDetails, i);
                              }),
                        )),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildPlayerCard(
      BuildContext context, AllUsersDetails allUsersDetails, int i) {
    // print(userDetails.id);
    // print(homeController.friendRequestList);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Obx(() => ListTile(
            onTap: homeController.checkFriendList(allUsersDetails.userId!) == 2
                ? () {
                    FriendRequestDetail? data =
                        homeController.singleFriendReq(allUsersDetails.userId!);
                    Get.to(() => StartGame(
                          color: data!.colour,
                          playingTime: data.time,
                          player1ID: data.playerOne,
                          player2ID: data.playerTwo,
                          gameId: data.gameId,
                          opponentName: allUsersDetails.userName,
                        ));
                  }
                : null,
            tileColor:
                homeController.checkFriendList(allUsersDetails.userId!) == 2
                    ? green.withOpacity(0.5)
                    : null,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
            contentPadding:
                EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
            leading: CircleAvatar(
              radius: 18.r,
              // backgroundColor: green,
              backgroundImage: AssetImage("assets/svg/7309681.jpg"),
            ),
            title: Text(allUsersDetails.userName!),
            trailing: trailingTile(allUsersDetails),
          )),
    );
  }

  Widget profileAndName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: green,
          radius: 30.r,
          backgroundImage: AssetImage("assets/svg/7309667.jpg"),
        ),
        horizontalWidth(width: 15.w),
        Expanded(
          child: Text(
            "Welcome ${loginAndSignUp.currentUserDetail!.userName}",
            style: black50016,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Spacer(),
        InkWell(
          onTap: logout,
          child: Icon(
            Icons.logout,
            size: 15.w,
          ),
        ),
      ],
    );
  }

  Widget trailingTile(AllUsersDetails allUsersDetails) {
    return Obx(() {
      switch (homeController.checkFriendList(allUsersDetails.userId!)) {
        case 0:
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Send Request to ${allUsersDetails.userName}"),
                          verticalHeight(height: 10.h),
                          Text(
                            "Choose Color",
                            style: black50014,
                          ),
                          verticalHeight(height: 5.h),
                          Obx(() => Container(
                                margin: EdgeInsets.only(left: 5.w),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: Colors.black)),
                                height: 40.h,
                                // width: 150.w,
                                child: Row(children: [
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () {
                                      confrmAndColorController
                                          .selectedColorIndex.value = 1;
                                      confrmAndColorController
                                          .selectedColor("black");
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: confrmAndColorController
                                                    .selectedColorIndex.value ==
                                                1
                                            ? grey
                                            : null,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.r),
                                            bottomLeft: Radius.circular(10.r)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Black",
                                        style: black50012,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )),
                                  Container(
                                    height: double.infinity,
                                    width: 1.w,
                                    child: null,
                                    color: Colors.black,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        confrmAndColorController
                                            .selectedColorIndex.value = 2;
                                        confrmAndColorController
                                            .selectedColor("white");
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: confrmAndColorController
                                                      .selectedColorIndex
                                                      .value ==
                                                  2
                                              ? grey
                                              : null,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.r),
                                              bottomRight:
                                                  Radius.circular(10.r)),
                                        ),
                                        child: Text(
                                          "White",
                                          style: black50012,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              )),
                          verticalHeight(height: 10.h),
                          Column(
                              mainAxisSize: MainAxisSize.min,
                              children: timeTileList
                                  .asMap()
                                  .entries
                                  .map((e) => TimeTile(
                                        title: e.value["1"],
                                        secondPartOne: e.value["2"],
                                        secondPartTwo: e.value["3"],
                                        secondPartThree: e.value["4"],
                                        callback: () {
                                          confrmAndColorController
                                              .selectedTimingTile(e.key);
                                          confrmAndColorController
                                              .selectedTiming(
                                                  int.parse(e.value["2"]));
                                          print(confrmAndColorController
                                              .selectedTiming.value);
                                        },
                                        index: e.key,
                                      ))
                                  .toList()),
                          verticalHeight(height: 5.h),
                          Obx(() =>
                              confrmAndColorController.selectedColor.isEmpty
                                  ? Text(
                                      "Please Select Color",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  : SizedBox())
                        ],
                      ),
                    ),
                    actions: [
                      MaterialButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Get.back();
                            confrmAndColorController.selectedColor("");
                            confrmAndColorController.selectedColorIndex(0);
                          }),
                      Obx(() => MaterialButton(
                          onPressed:
                              confrmAndColorController.selectedColor.isNotEmpty
                                  ? () {
                                      sendRequest(allUsersDetails);
                                    }
                                  : null,
                          child: Text(
                            "Send",
                            style: TextStyle(
                                color: confrmAndColorController
                                        .selectedColor.isEmpty
                                    ? Colors.grey
                                    : null),
                          ))),
                    ],
                  );
                },
              );
            },
            child: SizedBox(
                height: 20.h,
                width: 20.w,
                child: SvgPicture.asset(
                  "assets/svg/blackKing.svg",
                  fit: BoxFit.cover,
                )),
          );
        case 1:
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    homeController.singleUserDetails = allUsersDetails;
                    homeController.singleFriendReq(allUsersDetails.userId!);
                    Get.to(() => GameConfirmation(
                          allUsersDetails: allUsersDetails,
                        ));
                  },
                  icon: Icon(Icons.check_circle_outline, color: Colors.black)),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Colors.black,
                  ))
            ],
          );

        case 2:
          return SizedBox();
          // final socketController = Get.put(SocketConnectionController());
          // return Chip(label: Obx(() => Text(socketController.time.value)));
          // return Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     IconButton(
          //         onPressed: () {
          //           homeController.singleUserDetails = allUsersDetails;
          //           homeController.singleFriendReq(allUsersDetails.userId!);
          //           Get.to(() => GameConfirmation(
          //                 allUsersDetails: allUsersDetails,
          //               ));
          //           print(homeController.onePlayerReqDetail!.time);
          //         },
          //         icon: Icon(Icons.check_circle_outline, color: Colors.black)),
          //     IconButton(
          //         onPressed: () {},
          //         icon: Icon(
          //           Icons.cancel_outlined,
          //           color: Colors.black,
          //         ))
          //   ],
          // );
        default:
          return SizedBox();
      }
    });
  }
}
