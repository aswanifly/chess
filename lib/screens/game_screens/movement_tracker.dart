import 'package:chess/controller/api_service/login_signup_api.dart';
import 'package:chess/controller/loading_cont/laoding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/api_service/game_controller.dart';
import '../../exports.dart';
import '../view_pdf/view_pdf_screen.dart';
import 'user_history.dart';

class MovementTracker extends StatelessWidget {
  final String gameId;

  MovementTracker({Key? key, required this.gameId}) : super(key: key);

  final gameBoardController = Get.put(GameController());
  final loginController = Get.put(LoginAndSignUpController());
  final loadingController = Get.put(LoadingController());

  confirmMoves() async {
    loadingController.isLoading(true);
    try {
      // var data = await gameBoardController
      //     .addingToDB(loginController.currentUserDetail!.token);

      // String pdfLink = await gameBoardController.getPdfLink(
      //     loginController.currentUserDetail!.token, gameId);
      // print(data);
      await gameBoardController.clearLocalMoves();
      // Get.to(() => FinalResult());
      Get.to(() => UserHistoryScreen());
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: "Something Went Wrong",
        duration: Duration(seconds: 2),
      ));
    }
    // Get.to(()=>ViewPdfScreen());
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
                      // timeSection(context),
                      verticalHeight(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 15.w, right: 15.w),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              // color: Colors.red,
                              child: gameBoardController.loadingPdfLink.value ==
                                      true
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        // gameBoardController
                                        //     .getPdfLink(
                                        //         loginController
                                        //             .currentUserDetail!.token,
                                        //         gameId)
                                        //     .then((responseData) {
                                        //   showModalBottomSheet(
                                        //       context: context,
                                        //       showDragHandle: true,
                                        //       builder: (context) {
                                        //         return SizedBox(
                                        //           width: double.infinity,
                                        //           child: Padding(
                                        //             padding:
                                        //                 EdgeInsets.symmetric(
                                        //                     horizontal: 10.w,
                                        //                     vertical: 20.h),
                                        //             child: Column(
                                        //               mainAxisSize:
                                        //                   MainAxisSize.min,
                                        //               mainAxisAlignment:
                                        //                   MainAxisAlignment
                                        //                       .center,
                                        //               crossAxisAlignment:
                                        //                   CrossAxisAlignment
                                        //                       .start,
                                        //               children: [
                                        //                 InkWell(
                                        //                   onTap: () {
                                        //                     Get.back();
                                        //                     Get.to(() =>
                                        //                         ViewPdfScreen(
                                        //                           pdfUrl: gameBoardController
                                        //                               .pdfLink!,
                                        //                         ));
                                        //                   },
                                        //                   child: Row(
                                        //                     children: [
                                        //                       Icon(Icons
                                        //                           .picture_as_pdf),
                                        //                       horizontalWidth(
                                        //                           width: 10.w),
                                        //                       Text("View Pdf"),
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //                 verticalHeight(
                                        //                     height: 20),
                                        //                 InkWell(
                                        //                   onTap: () {
                                        //                     Get.back();
                                        //                     List<XFile>
                                        //                         fileList = [
                                        //                       XFile(
                                        //                           gameBoardController
                                        //                               .pdfPath!)
                                        //                     ];
                                        //                     Share.shareXFiles(
                                        //                         fileList);
                                        //                   },
                                        //                   child: Row(
                                        //                     children: [
                                        //                       Icon(Icons.share),
                                        //                       horizontalWidth(
                                        //                           width: 10.w),
                                        //                       Text(
                                        //                           "Share as Pdf"),
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //                 // Divider(),
                                        //                 verticalHeight(
                                        //                     height: 20),
                                        //                 InkWell(
                                        //                   onTap: () {
                                        //                     Get.back();
                                        //                     Share.share(
                                        //                         gameBoardController
                                        //                             .pdfLink!);
                                        //                   },
                                        //                   child: Row(
                                        //                     children: [
                                        //                       Icon(Icons.share),
                                        //                       horizontalWidth(
                                        //                           width: 10.w),
                                        //                       Text(
                                        //                           "Share Pdf link"),
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //           ),
                                        //         );
                                        //       });
                                        // });
                                      },
                                      icon: Icon(Icons.share)),
                            )),
                      ),
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
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Loading",
                                style: TextStyle(color: Colors.white),
                              ),
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
          child: Obx(() => ListView.builder(
              shrinkWrap: true,
              itemCount: gameBoardController.moveList.length,
              itemBuilder: (_, i) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 3,horizontal: 15),
                  width: double.infinity,
                  height: 45,
                  alignment:loginController.currentUserDetail!.id ==
                      gameBoardController.moveList[i].userId ? Alignment.centerLeft : Alignment.centerRight,
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffB0B0B0)))),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("${i+1}. ",style: black50014,),
                        Text(
                          gameBoardController.moveList[i].playerMove,
                          style: black50014,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ])

                    // trailing: IconButton(
                    //     onPressed: () {
                    //       gameBoardController
                    //           .deleteMoves(gameBoardController.moveList[i].id);
                    //     },
                    //     icon: Icon(
                    //       Icons.delete,
                    //       size: 18.w,
                    //     )),

                );
              }))),
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
              // Text(
              //   "12 points",
              //   style: violet50013,
              // ),
              Spacer(),
              SvgPicture.asset("assets/svg/whiteKing.svg"),
              horizontalWidth(width: 13.w),
              // Text(
              //   "10 points",
              //   style: violet50013,
              // ),
            ],
          ),
        ],
      ),
    );
  }

  MaterialButton customButton(String name, Color color, Function()? onTap) =>
      MaterialButton(
        onPressed: onTap,
        height: 40.h,
        minWidth: 110.w,
        color: color,
        child: Text(
          name,
          style: white50016,
        ),
      );
}
