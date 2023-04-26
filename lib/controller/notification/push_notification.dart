import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../api_service/login_signup_api.dart';

class PushNotification extends GetxController {
  final loginController = Get.put(LoginAndSignUp());
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  RxString deviceToken = "".obs;
  RxString token = "".obs;

  initInfo() {
    var androidInitialize =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    // var iOSInitialize = IOSInitializationSettings()
    var initializationSettings =
    InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse? payload) async {
          try {
            if (payload != null) {} else {}
          } catch (e) {}
          return;
        });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("-------message--------------");
      print(
          "onMessage : ${message.notification?.title} / ${message.notification
              ?.body}");
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);

      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
          "chess", "chess", importance: Importance.high,
          styleInformation: bigTextStyleInformation,
          priority: Priority.high,
          playSound: true);

      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics
      // iOS:
      );
      await flutterLocalNotificationsPlugin.show(
          0, message.notification?.title, message.notification?.body,
          platformChannelSpecifics, payload: message.data['body']);
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
        .doc(loginController.userDetails!.id)
        .set({"token": deviceToken.value});
  }

  void sendPushMessage(String token, String body, String title) async {
    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    try {
      await http.post(url,
          headers: <String, String>{
            "Content-Type": "application/json",
            "Authorization":
            "key=AAAAxih1zHs:APA91bHtIcBL5BcfXb5gfvue9UojRjBt2WGVSxNTRji0jof9Wb2bA5y8uR47ecTjrtrnXwiIAzf2i-aErsXK1UOrmKN8a_vAbuUnYSdFV1pcgWNr3gFmKx2z9oMtOfo5jTOJ-SmQsud7"
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              // body
              'body': body,
              'title': title,
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "chess"
            },
            "to": token
          }));
    } catch (e) {
      // if (kDebugMode) {
      print("error in push notification");
      // }
    }
  }

  getSnapShot(String id) async {
    DocumentSnapshot snap =
    await FirebaseFirestore.instance.collection("usertoken").doc(id).get();
    token(snap["token"]);
    print("this is token from firebase ${snap["token"]}");
  }
}
