import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../resources/app_exception.dart';
import 'base_api_services.dart';

class NetworkApiService extends BaseApiServices {
  static final _authToken = dotenv.env["AUTHTOKEN"] ?? "";
  static final _searchAuthToken = dotenv.env["SEARCHAUTHTOKEN"] ?? "";

  //For Post Api's
  @override
  Future postApiResponse(String url, dynamic data,
      {bool isSearch = false}) async {
    debugPrint("request body:: $data \n on uri:: $url");
    dynamic responseJson;
    try {
      http.Response response =
          await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        "Authorization": isSearch ? _searchAuthToken : _authToken,
      }).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw RequestTimeOutException(),
      );
      responseJson = returnResponse(response);
      debugPrint("response body:: $responseJson");
    } on SocketException {
      throw ClientRequestException(message: "No Internet Conection");
    }

    //if true then it'll return json response
    return responseJson;
  }

  //For Get Api's
  @override
  Future getApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": _authToken,
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw RequestTimeOutException(),
      );
      responseJson = returnResponse(response);
      debugPrint("response body:: $responseJson");
    } on SocketException {
      throw ClientRequestException(message: "No Internet Conection");
    }

    //if true then it'll return json respose

    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    Response status;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      status = Response.success;
    } else if (response.statusCode < 500) {
      status = Response.fail;
    } else {
      status = Response.serverError;
    }
    switch (status) {
      case Response.success:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      case Response.fail:
        dynamic responseJson = jsonDecode(response.body);
        var message = responseJson["message"];
        throw BadRequestException(
            message: (message is String) ? message : message[0]);

      default:
        throw ServerException(
            message: "///Server Error ${response.statusCode}///");
    }
  }
}

enum Response {
  success,
  fail,
  serverError,
}
