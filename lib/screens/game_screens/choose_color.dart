import 'package:chess/controller/api_service/login_signup_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/api_service/confirm_controller.dart';
import '../../exports.dart';

class ChooseColor extends StatelessWidget {
  final String? opponentName;
  final String? gameId;
  final String? opponentId;

  ChooseColor({Key? key, this.opponentName, this.gameId, this.opponentId})
      : super(key: key);

  final confrmAndColorController = Get.put(ConfirmController());
  final loginCont = Get.put(LoginAndSignUp());

  @override
  Widget build(BuildContext context) {
    loginCont.opponentId(opponentId);
    print(loginCont.opponentId.value);
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
    ));
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            top(context),
            verticalHeight(height: 36.h),
            Text(
              // "Choose Game Timing type",
              gameId ?? "nothing",
              style: black50014,
            ),
            verticalHeight(height: 15.h),
            Row(
              children: [
                Text(
                  "Name",
                  style: black50015,
                ),
                horizontalWidth(width: 40.w),
                Text(
                  "Timing",
                  style: black50015,
                )
              ],
            ),
            verticalHeight(height: 4.h),
            table(),
            verticalHeight(height: 35.h),
            Align(
                alignment: Alignment.center,
                child: button(
                  context,
                  "Next",
                  green,
                ))
          ]),
    );
  }

  Widget top(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Choose Color",
          style: black50014,
        ),
        Obx(() => Expanded(
              child: Container(
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
                      confrmAndColorController.selectedColorIndex.value = 1;
                      confrmAndColorController.selectedColor("black");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            confrmAndColorController.selectedColorIndex.value ==
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
                        confrmAndColorController.selectedColorIndex.value = 2;
                        confrmAndColorController.selectedColor("white");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: confrmAndColorController
                                      .selectedColorIndex.value ==
                                  2
                              ? grey
                              : null,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.r),
                              bottomRight: Radius.circular(10.r)),
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
              ),
            )),
      ],
    );
  }

  Widget table() {
    return Table(
      defaultColumnWidth: FixedColumnWidth(70.w),
      border: TableBorder(
          horizontalInside: BorderSide(
              width: 1.w, color: Colors.grey, style: BorderStyle.solid)),
      children: [
        TableRow(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text("Bullet"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text("1min"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text("1/1"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text("2/1"),
          )
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text("Blitz"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text("3min"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text("3/2"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text("5min"),
          )
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text("Rapid"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text("10min"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text("15/10"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text("30min"),
          )
        ]),
      ],
    );
  }

  MaterialButton button(BuildContext context, String name, Color color) =>
      MaterialButton(
        onPressed: () {
          if(confrmAndColorController.selectedColor.isEmpty){
            Get.showSnackbar(GetSnackBar(message: "Select Color",duration: Duration(seconds: 1),));
            return ;
          }
          Get.to(()=>StartGame(opponentName: opponentName, gameId: gameId));
        },
        height: 40.h,
        minWidth: 110.w,
        color: color,
        child: Text(
          name,
          style: white50016,
        ),
      );
}
