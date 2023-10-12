
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:chess/api/api_constant.dart';
import 'package:chess/api/api_helper.dart';
import 'package:chess/controller/api_service/login_signup_api.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/user_history_model.dart';

class UserHistoryController extends GetxController{

  final authController = Get.put(LoginAndSignUpController());
  RxBool userHistoryLoading = false.obs;
  RxBool loadingPdfLink = false.obs;

  String? pdfLink;
  String? pdfPath;

  List<UserHistoryModel> userHistoryList = [];

  getUserHistory()async{
    userHistoryList.clear();
    userHistoryLoading(true);
    String url = USER_HISTORY;
   var response = await ApiHelper().apiTypeGet(url, authController.currentUserDetail!.token);
   List extData = response["userHistory"];

   for( var i in extData){
     userHistoryList.add(UserHistoryModel.fromJson(i));
   }

   Logger().i(response);
   userHistoryLoading(false);
   return response;
  }

  Future<void> getPdfLink(String gameId) async {
    try {
      Map mapData = {"id": gameId};
      Uri url = Uri.parse("http://15.207.114.155:7000/movesPdf");
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authController.currentUserDetail!.userName}'
      };
      print(mapData);
      loadingPdfLink(true);
      var data =
      await http.put(url, headers: headers, body: json.encode(mapData));
      Map<String, dynamic> extractedData = jsonDecode(data.body);
      print(extractedData);
      // pdfLink = extractedData["pdfPath"];
      // print(extractedData["pdfPath"]);
      // File pdfLinkPath = await extractPdf(extractedData["pdfPath"]);
      // pdfPath = pdfLinkPath.path;
      // loadingPdfLink(false);
      // return extractedData["pdfPath"];
    } catch (e) {
      loadingPdfLink(false);
      rethrow;
    }

    // return data;
  }

  extractPdf(String url) async {
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/chess.pdf");
      Logger().e("file path ${file.path}");
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      rethrow;
    }
  }



}