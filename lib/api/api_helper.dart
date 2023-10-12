import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_constant.dart';

class ApiHelper {
  apiPost({required url, required jsonBody}) async {
    var uri = baseUrl + url;
    var request = http.Request('POST', Uri.parse(uri));
    request.bodyFields = jsonBody;
    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();
        var responseData = jsonDecode(value);
        return responseData;
      } else if (response.statusCode != 200) {
        var value = await response.stream.bytesToString();
        var responseData = jsonDecode(value);
        throw responseData;
      } else {
        throw "Something went wrong";
      }
    } on HttpException catch (e) {
      rethrow;
    }
  }

  apiTypeGet(url, String token) async {
    Uri uri = Uri.parse(baseUrl + url);
    var header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.Request('GET', uri);
    request.headers.addAll(header);
    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();
        var responseData = jsonDecode(value);
        return responseData;
      }
    } on HttpException {
      print(HttpException);
    }
  }

  apiType({required url,
    required jsonBody,
    required token,
    required String methodType}) async {
    var uri = baseUrl + url;
    print("this is url $uri");
    var header = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.Request(methodType, Uri.parse(uri));
    request.bodyFields = jsonBody;
    request.headers.addAll(header);
    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();
        var responseData = jsonDecode(value);
        return responseData;
      } else {
        var value = await response.stream.bytesToString();
        var responseData = jsonDecode(value);
        // throw responseData;
        return responseData;
      }
      // else{
      //   throw "Something Went Wrong";
      // }

    } on HttpException catch (_) {
      print(HttpException);
      rethrow;
    }
  }


  putApiContentJsonType({required url,
    required jsonBody,
    required token})async{
    try{
      String uri = baseUrl + url;
      Map<String,String> header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var response = await http.put(Uri.parse(uri),body: jsonBody,headers: header);
      return response.body;
    }catch(e){
      rethrow;
    }



  }

}
