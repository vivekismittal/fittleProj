import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../resources/app_exception.dart';
import 'base_api_services.dart';

class NetworkApiService extends BaseApiServices {
  static const _authToken = "Token 4b7842c6b2d92924c2d3fa2e4f483989458205d2";
  static const _searchAuthToken =
      "Token cf1b4c3e9cbd26e88096ec385fff6607d761967d";

  //For Post Api's
  @override
  Future postApiResponse(String url, dynamic data,
      {bool isSearch = false}) async {
    debugPrint("request body:: $data");
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
