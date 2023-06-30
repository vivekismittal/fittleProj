import 'package:fittle_ai/model/food_detail_model.dart';
import 'package:fittle_ai/model/food_insight_model.dart';
import 'package:fittle_ai/model/food_search_model.dart';
import 'package:fittle_ai/model/food_tracking_model.dart';
import '../network/base_api_services.dart';
import '../network/network_api_services.dart';
import '../resources/app_urls.dart';

class FoodTrackRepo {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<FoodTrackingData> getCategoryWiseFoodData(dynamic data) async {
    dynamic response = await _apiServices.postApiResponse(
        AppUrls.getCategoryWiseFoodDataUrl, data);
    try {
      return FoodTrackingData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<FoodSearchedModel> getSearchedFoodData(dynamic data) async {
    dynamic response = await _apiServices
        .postApiResponse(AppUrls.searchFoodUrl, data, isSearch: true);
    try {
      return FoodSearchedModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<FoodUserFrequentSearchModel> getUserFrequentSearchedFoodData(
      dynamic data) async {
    dynamic response = await _apiServices
        .postApiResponse(AppUrls.getFrequentFoodUrl, data, isSearch: true);
    try {
      return FoodUserFrequentSearchModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<FoodDetailModel> getFoodDetailData(dynamic data) async {
    dynamic response = await _apiServices
        .postApiResponse(AppUrls.foodDetailUrl, data, isSearch: true);
    try {
      return FoodDetailModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<FoodInsightData> getFoodInsightData(dynamic data) async {
    dynamic response =
        await _apiServices.postApiResponse(AppUrls.foodInsightUrl, data);
    try {
      return FoodInsightData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateFoodTrackData(dynamic data) async {
    dynamic response =
        await _apiServices.postApiResponse(AppUrls.updateFoodTrackUrl, data);
    try {
      return response["message"];
    } catch (e) {
      rethrow;
    }
  }

  Future<(FoodTrackingData,String?)> copyMoveFoodTrackData(dynamic data) async {
    dynamic response =
        await _apiServices.postApiResponse(AppUrls.copyMoveFoodTrackUrl, data);
    try {
      String message = response["message"];
     FoodTrackingData data =  FoodTrackingData.fromJson(response["updated_list_data"]);
      return (data,message);
    } catch (e) {
      rethrow;
    } 
  }

  Future<String> deleteFoodTrackData(dynamic data) async {
    dynamic response =
        await _apiServices.postApiResponse(AppUrls.deleteFoodTrackUrl, data);
    try {
      return response["message"];
    } catch (e) {
      rethrow;
    }
  }

  Future<String> reportIssues(dynamic data) async {
    dynamic response =
        await _apiServices.postApiResponse(AppUrls.reportIssuesUrl, data);
    try {
      return response["message"];
    } catch (e) {
      rethrow;
    }
  }
}
