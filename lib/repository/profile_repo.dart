import 'package:fittle_ai/model/create_update_profile_response.dart';
import 'package:fittle_ai/model/profile_data.dart';
import 'package:fittle_ai/resources/app_urls.dart';
import 'package:fittle_ai/network/base_api_services.dart';
import 'package:fittle_ai/network/network_api_services.dart';

class ProfileRepo {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<CreateUpdateProfileResponse> createUpdateProfile(dynamic data) async {
    dynamic response = await _apiServices.postApiResponse(
        AppUrls.createUpdateProfileUrl, data);
    try {
      return CreateUpdateProfileResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
    Future<ProfileData> getUserProfile(dynamic data) async {
    dynamic response = await _apiServices.postApiResponse(
        AppUrls.getUserProfileData, data);
    try {
      return ProfileData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
