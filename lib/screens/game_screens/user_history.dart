import 'package:chess/controller/api_service/login_signup_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/api_service/user_history_controller.dart';
import '../../exports.dart';
import '../view_pdf/view_pdf_screen.dart';

class UserHistoryScreen extends StatefulWidget {
  const UserHistoryScreen({Key? key}) : super(key: key);

  @override
  State<UserHistoryScreen> createState() => _UserHistoryScreenState();
}

class _UserHistoryScreenState extends State<UserHistoryScreen> {
  final userHistoryController = Get.put(UserHistoryController());
  final authController = Get.put(LoginAndSignUpController());


  getUserHistory() async {
    userHistoryController.getUserHistory();
  }

  @override
  void initState() {
    getUserHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() => userHistoryController.userHistoryLoading.value == true
          ? Center(
              child: CircularProgressIndicator(
                color: green,
              ),
            )
          : Scaffold(
              body: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        topBar(context),
                        Divider(
                          thickness: 1.w,
                          color: Color(0xff545454),
                        ),
                        // buildShowResult(),
                        // verticalHeight(height: 10.h),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Game History",
                                style: black50016,
                              ),
                              // Text(
                              //   "Played with you 2 times",
                              //   style: black50012,
                              // ),
                            ],
                          ),
                        ),
                       ...userHistoryController.userHistoryList.map((e) {
                         return  Padding(
                           padding: EdgeInsets.only(left: 15.w, right: 15.w),
                           child: SizedBox(
                             height: 80,
                             child: Card(
                               shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10.r),),
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Row(children: [
                                   CircleAvatar(
                                     // backgroundColor: grey,
                                     backgroundImage:
                                     AssetImage("assets/svg/7309681.jpg"),
                                   ),
                                   horizontalWidth(width: 10.w),
                                   Text(
                                     e.playerName!,
                                     style: black50016,
                                   ),
                                   Spacer(),
                                   Text(
                                     e.status!,
                                     style: green50016,
                                   ),
                                   horizontalWidth(width: 10.w),
                                   Padding(
                                     padding:  EdgeInsets.only(right: 10.w),
                                     child: InkWell(onTap: (){
                                       print(e.gameId);
                                       // print(e.g)
                                       // userHistoryController.getPdfLink(e.gameId!);
                                       //     .then((value) {
                                       //   showModalBottomSheet(
                                       //       context: context,
                                       //       showDragHandle: true,
                                       //       builder: (context) {
                                       //         return SizedBox(
                                       //           width: double.infinity,
                                       //           child: Padding(
                                       //             padding:
                                       //             EdgeInsets.symmetric(
                                       //                 horizontal: 10.w,
                                       //                 vertical: 20.h),
                                       //             child: Column(
                                       //               mainAxisSize:
                                       //               MainAxisSize.min,
                                       //               mainAxisAlignment:
                                       //               MainAxisAlignment
                                       //                   .center,
                                       //               crossAxisAlignment:
                                       //               CrossAxisAlignment
                                       //                   .start,
                                       //               children: [
                                       //                 InkWell(
                                       //                   onTap: () {
                                       //                     Get.back();
                                       //                     Get.to(()=>ViewPdfScreen(pdfUrl: userHistoryController.pdfLink!,));
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
                                       //                   onTap: (){
                                       //                     Get.back();
                                       //                     List<XFile> fileList = [XFile(userHistoryController.pdfPath!)];
                                       //                     Share.shareXFiles(fileList);
                                       //                   },
                                       //                   child: Row(
                                       //                     children: [
                                       //                       Icon(Icons.share),
                                       //                       horizontalWidth(
                                       //                           width: 10.w),
                                       //                       Text("Share as Pdf"),
                                       //                     ],
                                       //                   ),
                                       //                 ),
                                       //                 // Divider(),
                                       //                 verticalHeight(
                                       //                     height: 20),
                                       //                 InkWell(
                                       //                   onTap: (){
                                       //                     Get.back();
                                       //                     Share
                                       //                         .share(userHistoryController.pdfLink!);
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


                                     },child: Icon(Icons.picture_as_pdf)),
                                   )
                                 ]),
                               ),
                             ),
                           ),
                         );
                       }),
                      ]),
                ),
              ),
            ),
      ),
    );
  }

  Row buildShowResult() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      winDrawLostButton("Wins : 5"),
      winDrawLostButton("Draws : 1"),
      winDrawLostButton("Lost : 2"),
    ]);
  }

  Container winDrawLostButton(String buttonName) {
    return Container(
      height: 35.h,
      width: 100.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: violet),
          borderRadius: BorderRadius.circular(10.r)),
      child: Text(
        buttonName,
        style: black50014,
      ),
    );
  }

  Padding topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                backgroundImage: AssetImage("assets/svg/7309667.jpg"),
              ),
              horizontalWidth(width: 10.w),
              Text(
                authController.currentUserDetail!.userName,
                style: black50020,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
