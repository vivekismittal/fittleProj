import 'package:fittle_ai/model/wokout_track_model.dart';
import 'package:fittle_ai/model/workout_search_model.dart';

import '../model/workout_detail_model.dart';
import '../network/base_api_services.dart';
import '../network/network_api_services.dart';
import '../resources/app_urls.dart';

class WorkoutTrackRepo {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<WorkoutTrackData> fetchWorkoutTrackData(dynamic data) async {
    dynamic response =
        await _apiServices.postApiResponse(AppUrls.getWorkoutTrackDataUrl,data);
    try {
      return WorkoutTrackData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<WorkoutSearchData> getSearchedWorkoutData(dynamic data) async {
    dynamic response = await _apiServices
        .postApiResponse(AppUrls.searchWorkoutUrl, data, isSearch: true);
    try {
      return WorkoutSearchData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<WorkoutFrequentSearchData> getUserFrequentSearchedWorkoutData(
      dynamic data) async {
    dynamic response = await _apiServices
        .postApiResponse(AppUrls.getFrequentWorkoutUrl, data, isSearch: true);
    try {
      return WorkoutFrequentSearchData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

   Future<WorkoutDetailData> getWorkoutDetailData(
      dynamic data) async {
    dynamic response = await _apiServices
        .postApiResponse(AppUrls.getWorkoutDetailDataUrl, data, isSearch: true);
    try {
      return WorkoutDetailData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
     Future<String> updateWorkoutTrack(
      dynamic data) async {
    dynamic response = await _apiServices
        .postApiResponse(AppUrls.updateWorkoutTrackUrl, data);
    try {
      return response["message"];
    } catch (e) {
      rethrow;
    }
  }
}
