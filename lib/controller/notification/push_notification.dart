import 'dart:convert';
import 'dart:developer';

import 'package:chess/api/api_helper.dart';
import 'package:chess/controller/api_service/game_controller.dart';
import 'package:chess/controller/api_service/home_controller.dart';
import 'package:chess/exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/player.dart';
import '../../screens/game_screens/choose_color.dart';
import '../api_service/login_signup_api.dart';

class PushNotification extends GetxController {
  final loginController = Get.put(LoginAndSignUpController());
  final homeController = Get.put(HomeController());
  final gameController = Get.put(GameController());

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  RxString deviceToken = "".obs;

  initInfo() {
    var androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // var iOSInitialize = IOSInitializationSettings()
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? payload) async {
        try {
          if (payload != null) {
            var m = jsonDecode(payload.payload!);
            // log("payload------------------------------------------------------------------------------------------------------${m.toString()}");
            // log("payload -------------======================== ${payload.payload!.toString()}");
            switch (m["screen"]) {
              case 1:
                Get.to(() => HomeScreen());
                break;
              case 2:
                // gameController.gameId(m["gameId"]);
                // homeController.playingTime(m["time"]);
              // print(m["senderName"]);
              // print(m["gameId"]);
              // print(m["color"]);
              // print(m["player1UserId"]);///coming null
              // print(m["player2UserId"]);///coming null
              // print(m["time"]);
                Get.to(() => StartGame(
                      opponentName: m["senderName"],
                      gameId: m["gameId"],
                      color: m["color"],
                  player1ID: m["player1UserId"],
                  player2ID: m["player2UserId"],
                  playingTime: m["time"],
                    ));

                // Get.showSnackbar(GetSnackBar(
                //   message: "Player Joined",
                //   duration: Duration(seconds: 3),
                // ));

                break;
              default:
                Get.to(() => HomeScreen());
            }

            // Get.to(() => StartGame(opponentName: m["senderName"],gameId: m["gameId"],));
          }
        } catch (e) {
          print(e);
        }
        return;
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("-------message--------------");
      print(
          "onMessage : ${message.notification?.title} / ${message.notification?.body}");
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        "chess",
        "chess",
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics
              // iOS:
              );
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data["body"]);
      print(
          "pushnotification line 71 push cont message data-------------------------------++++++++++++++++ ${message.data.toString()}");
    });
  }

  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    deviceToken(token);
    print("this is device token - $token");
  }

  void saveToken() async {
    await FirebaseFirestore.instance
        .collection("usertoken")
        .doc(loginController.currentUserDetail!.id)
        .set({"token": deviceToken.value});
  }

  void sendPushMessage(String token, Map acceptBody, String bodyTitle) async {
    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    var body = jsonEncode(acceptBody);
    try {
      await http.post(url,
          headers: <String, String>{
            "Content-Type": "application/json",
            "Authorization":
                "key=AAAAxih1zHs:APA91bHtIcBL5BcfXb5gfvue9UojRjBt2WGVSxNTRji0jof9Wb2bA5y8uR47ecTjrtrnXwiIAzf2i-aErsXK1UOrmKN8a_vAbuUnYSdFV1pcgWNr3gFmKx2z9oMtOfo5jTOJ-SmQsud7",
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              // 'body': encoded,
              'body': body,
              'title': acceptBody["senderName"]
              // 'id':"1234567"
            },
            "notification": <String, dynamic>{
              "title": "You have a Request from ${acceptBody["senderName"]}",
              "body": bodyTitle,
              "android_channel_id": "chess"
            },
            "to": token
          }));
    } catch (e) {
      if (kDebugMode) {
        print("error in push notification $e");
      }
    }
  }

  Future<dynamic> getUserTokenDB(String id) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("usertoken").doc(id).get();
    print("this is token from firebase ${snap["token"]}");
    return snap["token"];
    // var url = "/firebase";
    // var body = {
    //   "userId":id
    // };
    // var data  = ApiHelper().apiType(url: url, jsonBody: body, token: snap["token"], methodType: 'POST');
    // print(data);
    // return data;
  }
}
