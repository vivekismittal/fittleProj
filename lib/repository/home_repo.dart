import 'package:fittle_ai/model/home_dashboard_response.dart';

import '../network/base_api_services.dart';
import '../network/network_api_services.dart';
import '../resources/app_urls.dart';

class HomeRepo {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<HomeDashBoardResponse> getHomeDashboardData(dynamic data) async {
    dynamic response = await _apiServices.postApiResponse(
        AppUrls.getHomeDashboardDataUrl, data);
    try {
      return HomeDashBoardResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateWaterIntake(dynamic data) async {
    dynamic response =
        await _apiServices.postApiResponse(AppUrls.updateWaterIntakeUrl, data);
    try {
      return response["message"];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, double>>> getProgressData(dynamic data) async {
    Map<String, dynamic> response =
        await _apiServices.postApiResponse(AppUrls.getProgressData, data);
    try {
      List<Map<String, double>> progressDataList = [];
      for (var e in (response["progress_data"] as List)) {
        (e as Map).forEach((key, value) {
          progressDataList
              .add({(key as String): (double.tryParse(value.toString()) ?? 0)});
        });
      }
      return progressDataList;
    } catch (e) {
      rethrow;
    }
  }
}
