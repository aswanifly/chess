import 'package:chess/controller/api_service/user_history_controller.dart';
import 'package:chess/exports.dart';
import 'package:chess/screens/game_screens/user_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FinalResult extends StatefulWidget {
  const FinalResult({Key? key}) : super(key: key);

  @override
  State<FinalResult> createState() => _FinalResultState();
}

class _FinalResultState extends State<FinalResult> {

  final userHistoryController = Get.put(UserHistoryController());


  Future<bool> _onWillPop() async {
    Get.closeAllSnackbars();
    Get.showSnackbar(GetSnackBar(
      message: "Press on Home",
      duration: Duration(seconds: 1),
      isDismissible: true,
    ));
    return false;
  }

  getUserHistory()async{
    userHistoryController.getUserHistory();
  }


  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  topBar(context),
                  Divider(
                    thickness: 1,
                    color: Color(0xff545454),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                        child: Column(
                      children: [
                        // Divider(),
                        Text(
                          "WON",
                          style: green50024,
                        ),
                        resultCard(context, "You", "assets/svg/blackKing.svg",
                            "assets/svg/7309681.jpg"),
                        verticalHeight(height: 30.h),
                        resultCard(context, "Other", "assets/svg/whiteKing.svg",
                            "assets/svg/7309667.jpg")
                      ],
                    )),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  SizedBox resultCard(
      BuildContext context, String name, String kingImage, String image) {
    return SizedBox(
      child: Column(children: [
        Row(
          children: [
            CircleAvatar(
              // backgroundColor: grey,
              backgroundImage: AssetImage(image),
            ),
            horizontalWidth(width: 15.w),
            Text(
              name,
              style: black50020,
            ),
            horizontalWidth(width: 18.w),
            SvgPicture.asset(
              kingImage,
              height: 20.h,
              width: 18.w,
            ),
          ],
        ),
        verticalHeight(height: 22.h),
        Align(
          alignment: Alignment.centerLeft,
          child: MaterialButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserHistoryScreen()));
            },
            color: violet,
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ),
      ]),
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
              // GestureDetector(
              //     onTap: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: Icon(Icons.arrow_back)),
              // horizontalWidth(width: 50.w),
              Text(
                "Final Result",
                style: black50020,
              ),
              Spacer(),
              IconButton(onPressed: (){Get.offAll(()=>HomeScreen(gameIsRunning: false,));}, icon: Icon(Icons.home_filled)),
            ],
          ),
        ],
      ),
    );
  }
}
