import 'dart:convert';

import 'package:chess/api/api_helper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_constant.dart';

// class MovesController extends GetxController {
//
//
//   addMoves(String gameId, String token) async {
//     String url = "${INSERT_MOVES}644be04af427334bcbffd8eb";
//     var jsonBody = {
//       "moves": jsonEncode([
//         {"from": "3e", "playerId": "1", "time": "132"},
//         {"from": "3e", "playerId": "1", "time": "132"},
//         {"from": "3e", "playerId": "1", "time": "132"}
//       ])
//     };
//     print(jsonBody.runtimeType);
//     // try {
//     var data = await ApiHelper().apiType(
//         url: url, jsonBody: jsonBody, token: token, methodType: 'POST');
//     print(data);
//     // } catch (e) {
//     //   rethrow;
//     // }
//   }
//
// }



//
// () => homeController.checkFriendList(allUsersDetails.userId!)
//     ?