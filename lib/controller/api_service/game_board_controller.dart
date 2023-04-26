import 'package:chess/models/moves.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GameBoardController extends GetxController {
  RxString displayMoves = "".obs;
  RxList buttonsList = [].obs;
  RxString endTime = "".obs;
  RxList<Moves> moveList = <Moves>[].obs;

  void addMoves(Moves moves) {
    moveList.add(Moves(moveTime: moves.moveTime, playerMove: moves.playerMove));
    buttonsList.clear();
  }

  void addingToList(String move) {
    buttonsList.add(move);
  }

  void clearAllMoves() {
    buttonsList.clear();
  }
}
