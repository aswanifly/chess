import 'package:get/get.dart';

import '../../api/api_helper.dart';

class GetAllPlayersController extends GetxController {
  getAllPlayers(String token) async {
    String url = "http://10.0.2.2:7000/getAllUsers";
    var data = await ApiHelper().apiTypeGet(url, token);
    print(data);
  }
}
