import 'package:chess/controller/api_service/login_signup_api.dart';
import 'package:chess/controller/loading_cont/laoding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controller/api_service/game_controller.dart';
import '../../exports.dart';

class MovementTracker extends StatelessWidget {
  MovementTracker({Key? key}) : super(key: key);

  final gameBoardController = Get.put(GameController());
  final loginController = Get.put(LoginAndSignUp());
  final loadingController = Get.put(LoadingController());

  confirmMoves() async {
    loadingController.isLoading(true);
    try {
      var data = await gameBoardController
          .addingToDB(loginController.currentUserDetail!.token);
      print(data);
      await gameBoardController.clearLocalMoves();
      Get.to(() => FinalResult());
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: "Something Went Wrong",
      ));
    }
    loadingController.isLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(() => Stack(
              children: [
                Scaffold(
                  body: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(children: [
                      topBar(context),
                      Divider(
                        height: 0,
                        thickness: 1,
                        indent: 0,
                      ),
                      timeSection(context),
                      verticalHeight(height: 10.h),
                      allMovementList(),
                      verticalHeight(height: 50.h),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customButton("Cancel", red, () {
                              Get.back();
                            }),
                            horizontalWidth(width: 20.w),
                            customButton("Confirm", green, confirmMoves),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
                if (loadingController.loading)
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black45,
                      child: Center(
                          child: Container(
                        height: 80.h,
                        width: 80.w,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.black,
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,children:  [
                          Text("Loading",style: TextStyle(color: Colors.white),),
                          Padding(
                            padding: EdgeInsets.only(top: 13.h),
                            child: SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(

                                color: green,
                              ),
                            ),
                          ),
                        ]),
                      )),
                    ),
                  )
              ],
            )));
  }

  Widget allMovementList() {
    return Expanded(
      child: Container(
          margin: EdgeInsets.only(left: 15.w, right: 15.w),
          color: grey,
          width: double.infinity,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: gameBoardController.moveList.length,
              itemBuilder: (_, i) {
                return Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffB0B0B0)))),
                  child: ListTile(
                    leading: SizedBox(
                      width: 160.w,
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${i + 1}. ${gameBoardController.moveList[i].playerMove}",
                              style: black50014,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              gameBoardController.moveList[i].moveTime,
                              style: black50014,
                              overflow: TextOverflow.ellipsis,

                            )
                          ]),
                    ),
                    trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.delete,
                          size: 18.w,
                        )),
                  ),
                );
              })),
    );
  }

  Widget timeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Time",
            style: black40020,
          ),
          Container(
            height: 40.h,
            width: 140.w,
            decoration: BoxDecoration(
              color: violet,
              borderRadius: BorderRadius.circular(15.r),
            ),
            alignment: Alignment.center,
            child: Text(gameBoardController.endTime.value, style: white50016),
          ),
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.share,
          //       color: Colors.black,
          //     ))
        ],
      ),
    );
  }

  Padding topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back)),
              horizontalWidth(width: 10.w),
              CircleAvatar(
                // backgroundColor: Colors.grey,
                backgroundImage: AssetImage("assets/svg/7309681.jpg"),
              ),
              horizontalWidth(width: 8.w),
              Text(
                loginController.currentUserDetail!.userName,
                style: black50015,
              ),
              Spacer(),
              Text(
                "vs",
                style: black50015,
              ),
              Spacer(),
              Text(
                gameBoardController.opponentName.value,
                style: black50015,
              ),
              horizontalWidth(width: 8.w),
              CircleAvatar(
                // backgroundColor: Colors.grey,
                backgroundImage: AssetImage("assets/svg/7309667.jpg"),
              ),
            ],
          ),
          verticalHeight(height: 8.h),
          Row(
            children: [
              SvgPicture.asset("assets/svg/blackKing.svg"),
              horizontalWidth(width: 13.w),
              Text(
                "12 points",
                style: violet50013,
              ),
              Spacer(),
              SvgPicture.asset("assets/svg/whiteKing.svg"),
              horizontalWidth(width: 13.w),
              Text(
                "10 points",
                style: violet50013,
              ),
            ],
          ),
        ],
      ),
    );
  }

  MaterialButton customButton(String name, Color color, Function()? ontap) =>
      MaterialButton(
        onPressed: ontap,
        height: 40.h,
        minWidth: 110.w,
        color: color,
        child: Text(
          name,
          style: white50016,
        ),
      );
}
