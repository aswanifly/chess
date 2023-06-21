import 'dart:async';
import 'dart:convert';

import 'package:chess/controller/api_service/game_controller.dart';
import 'package:chess/controller/api_service/home_controller.dart';
import 'package:chess/exports.dart';
import 'package:chess/models/moves.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/api_service/login_signup_api.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final loginAndSignUp = Get.put(LoginAndSignUp());
  // final gameBoardController = Get.put(GameController());

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    Map<String, dynamic> extractedData =
        jsonDecode(prefs.getString("userData")!);
    loginAndSignUp.emailC.value.text = extractedData["userEmail"];
    loginAndSignUp.passwordC.value.text = extractedData["userPassword"];
    print(extractedData.toString());
    await loginAndSignUp.login();
    if (loginAndSignUp.currentUserDetail != null) {
      return true;
    } else {
      return false;
    }
  }

  // Future<bool> checkMoves() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey("localMoves")) {
  //     return false;
  //   }
  //   var extractedData = jsonDecode(prefs.getString("localMoves")!);
  //   List secondAndMinute = extractedData["lastTime"].split(':');
  //   // print(extractedData.toString());
  //   gameBoardController.fetchFromLocalStorage(
  //       int.parse(secondAndMinute[1]),
  //       int.parse(secondAndMinute[0]),
  //       extractedData["moves"],
  //       extractedData["opponentName"],
  //       extractedData["gameId"],
  //       extractedData["color"],
  //       extractedData["opponentId"]);
  //   return true;
  // }

  getScreen() async {
    if (await autoLogin()) {
      // if (await checkMoves()) {
      //   return Get.offAll(() => HomeScreen(
      //         gameIsRunning: true,
            // ));
      // }
      return Get.offAll(() => HomeScreen());
    } else {
      return Get.offAll(() => Login());
    }
  }

  @override
  void initState() {
    Timer(Duration(seconds: 2), () => getScreen());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/svg/7Yya.gif",
                height: 200.h,
                width: 200.w,
              ),
              Text(
                "Chess",
                style: black60030,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
