import 'dart:async';
import 'dart:convert';

import 'package:chess/controller/api_service/home_controller.dart';
import 'package:chess/controller/api_service/login_signup_api.dart';
import 'package:chess/models/player.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../api_service/game_controller.dart';

class SocketConnectionController extends GetxController {
  ///controllers
  final loginController = Get.put(LoginAndSignUp());
  final homeController = Get.put(HomeController());
  final gameController = Get.put(GameController());

  ///dataTypes

  RxBool isActive = false.obs;
  Socket? socket;
  Timer? timer;

  Duration duration = Duration();
  Duration duration2 = Duration();
  RxString time = '00.00'.obs;
  RxString time2 = '00.00'.obs;
  RxBool gameStarted = false.obs;
  RxInt second = 0.obs;
  RxInt second2 = 0.obs;
  RxInt timeDiff = 0.obs;

  @override
  void onInit() {
    time("${homeController.playingTime.value}:00");
    duration = Duration(
        seconds: 0, minutes: int.parse(homeController.playingTime.value));
    super.onInit();
  }

  void checkTimerStatus() {
    if (isActive.value == true) {
      pauseTime();
    } else {
      startTimer();
    }
  }

  void connectToSocket() {
    socket = io('http://15.207.114.155:9000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.on('connect', (_) {
      print("connected");
    });
    socket!.on('message', (data) {
      Map<String, dynamic> socketData = jsonDecode(data);
      isActive(socketData["isActive"]);
      if (loginController.currentUserDetail!.id == gameController.player1ID.value && isActive.isTrue) {
        startTimer();
      }else if(loginController.currentUserDetail!.id == gameController.player2ID.value && isActive.isFalse){
        startTimer();
      }
      else {
        pauseTime();
      }
    });
    socket!.on('disconnect', (_) => print('disconnect'));
  }

  void sendMessage(String gameID, String userId, String move, bool status) {
    Map<String, dynamic> message = {
      "gameId": gameID,
      "userId": userId,
      "move": move,
      "isActive": status
    };

    socket!.emit('message', jsonEncode(message));
  }

  startTimer() {
    const addSecond = 1;
    gameController.getGameStartTime();
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      second.value = duration.inSeconds - addSecond;
      var currentTime = DateTime.now();
      print("Game Start time : ${gameController.gameStartTime.value}");
      try{
        var dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(gameController.gameStartTime.value).add(Duration(hours: 5, minutes: 30));
        print("Date To Millis: ${(dateFormat.millisecondsSinceEpoch)/1000}");
        var timeDiff = currentTime.difference(dateFormat);
        print("Game Start time : ${gameController.gameStartTime.value}, Current Time: ${currentTime}, diff:${timeDiff}, diff in sec:${timeDiff.inSeconds}, duration:${duration.inSeconds-timeDiff.inSeconds}");
        second2.value = (duration.inSeconds+1) - timeDiff.inSeconds;
      } on Exception catch(exception){
        print(exception);
      }
      if (second.value < 0) {
        timer.cancel();
      } else {
        duration = Duration(seconds: second.value);
        duration2 = Duration(seconds: second2.value);
        time.value =
            "${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}";
        time2.value =
            "${duration2.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration2.inSeconds.remainder(60).toString().padLeft(2, "0")}";
        update();
      }
    });
  }

  pauseTime() {
    timer?.cancel();
  }

  void closeConnection(){
    socket?.close();
    print('Connection Closed');
  }
}

// socket.onconnect((data)=>print(data));
// socket.onConnectError((data) => print("Error"));

// startTimer(){
//   remainSeconds = 10;
//   const addSecond = 1;
//   timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
//     if(remainSeconds==0){
//       timer.cancel();
//     }else{
//       int minutes = remainSeconds~/60;
//       int seconds = remainSeconds%60;
//       time.value = "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
//       remainSeconds--;
//     }
//   });
// }
