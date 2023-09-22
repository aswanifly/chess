import 'dart:convert';
import 'package:chess/api/api_helper.dart';
import 'package:chess/controller/api_service/login_signup_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chess/models/moves.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../api/api_constant.dart';
import '../socket/socket.dart';
import 'confirm_controller.dart';

class GameController extends GetxController {



  RxString opponentName = "".obs;
  RxString gameId = "".obs;
  RxString player1ID="".obs;
  RxString player2ID="".obs;
  RxString displayMoves = "".obs;
  RxList buttonsList = [].obs;
  List fetchedMoveList = [];


  ///for button
  RxString endTime = "".obs;
  RxList<Moves> moveList = <Moves>[].obs;

  ///moves
  RxList<dynamic> localMovesList = <dynamic>[].obs;

  ///storing into localStorage
  RxInt minute = 0.obs;
  RxInt second = 0.obs;
  RxInt currentPiece = 0.obs;
  final Rx<TextEditingController> editingMoveController =
      TextEditingController().obs;
  final loginController = Get.put(LoginAndSignUp());
  final colorController = Get.put(ConfirmController());
  RxString gameStartTime = "".obs;

  void pieceMove() {
    switch (currentPiece.value) {
      case 0:

      ///pawn
        displayMoves(".${buttonsList.join('')}");
        break;
      case 1:

      ///knight
        displayMoves("N${buttonsList.join('')}");
        break;
      case 2:

      ///rook
        displayMoves("R${buttonsList.join('')}");
        break;
      case 3:

      ///bishop
        displayMoves("B${buttonsList.join('')}");
        break;
      case 4:

      ///queen
        displayMoves("Q${buttonsList.join('')}");
        break;
      case 5:

      ///king
        displayMoves("K${buttonsList.join('')}");
        break;
      default:
        displayMoves(".${buttonsList.join('')}");
    }
  }

  // void addMoves(Moves moves) {
  //   moveList.add(Moves(moveTime: moves.moveTime, playerMove: moves.playerMove));
  //   buttonsList.clear();
  // }

  void addingToList(String move) {
    buttonsList.add(move);
  }

  void clearButtonList() {
    buttonsList.clear();
  }

  addToLocalStorage(Moves moves) async {
    localMovesList.add({
      "from": moves.playerMove,
      "playerId": loginController.currentUserDetail!.id,
      "time": moves.moveTime
    });
    final prefs = await SharedPreferences.getInstance();
    var localMoves = jsonEncode({
      "moves": localMovesList,
      "lastTime": moves.moveTime,
      "opponentName": opponentName.value,
      "gameId": gameId.value,
      "color": colorController.selectedColor.value,
      "opponentId": loginController.opponentId.value,
    });

    prefs.setString("localMoves", localMoves);
    // moveList.add(Moves(moveTime: moves.moveTime, playerMove: moves.playerMove));
    buttonsList.clear();
  }

  clearLocalMoves() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("localMoves");
    moveList.clear();
    localMovesList.clear();
  }

  fetchFromLocalStorage(int lastSecond,
      int lastMinute,
      List<dynamic> storedMovesList,
      String localOpponentName,
      String localGameID,
      String color,
      String opponentId) {
    minute(lastMinute);
    second(lastSecond);
    localMovesList.value = storedMovesList;
    opponentName(localOpponentName);
    gameId(localGameID);
    colorController.selectedColor(color);
    loginController.opponentId(opponentId);
    for (int i = 0; i < storedMovesList.length; i++) {
      // moveList.add(Moves(
      //     moveTime: storedMovesList[i]["time"],
      //     playerMove: storedMovesList[i]["from"]));
    }
  }

  addingToDB(String token) async {
    var url =
    Uri.parse("http://15.207.114.155:7000/insertbulkmoves/${gameId.value}");
    var header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = jsonEncode({"moves": localMovesList});
    try {
      var req = await http.post(url, headers: header, body: body);
      if (req.statusCode == 200) {
        return jsonDecode(req.body);
      } else {
        throw "Something Went wrong";
      }
    } catch (_) {
      rethrow;
    }
  }

  editMove(int i) {
    moveList[i].playerMove = editingMoveController.value.text.trim();
    localMovesList[i]["from"] = editingMoveController.value.text.trim();
    editingMoveController.value.clear();
    moveList.refresh();
    localMovesList.refresh();
  }

  bool checkMove() {
    var exp = RegExp(r'([a-z0-9])\1');
    bool check = exp.hasMatch(displayMoves.value);
    return check;
  }

  getMoves() async {
    var url = GET_SINGLE_MOVE + gameId.value;
    var data =
    ApiHelper().apiTypeGet(url, loginController.currentUserDetail!.token);
    return data;
  }

  sendMove(String time) async {
    String url = SEND_MOVE + gameId.value;
    final Map<String, String> jsonBody = {
      "move": displayMoves.value,
      "userId": loginController.currentUserDetail!.id,
      "time": time
    };
    print(jsonBody);
    try {
      await ApiHelper().apiType(url: url,
          jsonBody: jsonBody,
          token: loginController.currentUserDetail!.token,
          methodType: 'POST');
      buttonsList.clear();
    } catch (e) {
      print(e);
    }
  }

  getGameStartTime() async {
    String url = START_TIME + gameId.value; // gameId.value; // "649559f38c80e49cb9ba4f21"; // 649a815ead10e3f00d8e7c81 // 649d33423833d765361201de
    final Map<String, String> jsonBody= {};
    try {
      Map<String, dynamic> res = await ApiHelper().apiType(url: url,
          jsonBody: jsonBody,
          token: loginController.currentUserDetail!.token,
          methodType: 'PUT');
      print(res.toString());
      print("Start Time From API: "+res["startTime"]);
      gameStartTime.value = res["startTime"];
    } catch (e) {
      print(e);
    }
  }

  addCurrentUserMove(){
    moveList.clear();
    for(var i in fetchedMoveList){
      if(loginController.currentUserDetail!.id ==  i["userId"]){
        moveList.add(Moves(id: DateTime.now().toIso8601String(), moveTime: "", playerMove: i["move"]));
      }
    }
  }

  deleteMoves(String id){
    int i = moveList.indexWhere((element) => element.id == id);
    print(moveList[i].playerMove);
    moveList.removeAt(i);
  }

}
