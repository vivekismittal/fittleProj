import 'package:fittle_ai/model/hash_token_model.dart';
import 'package:fittle_ai/model/otp_verified_response.dart';
import 'package:fittle_ai/resources/app_urls.dart';
import 'package:fittle_ai/network/base_api_services.dart';
import 'package:fittle_ai/network/network_api_services.dart';

class AuthRepo {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<HashToken> sendOtp(dynamic data) async {
    dynamic response =
        await _apiServices.postApiResponse(AppUrls.sendOtpUrl, data);
    try {
      return HashToken.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OtpVerifiedResponse> verifyOtp(dynamic data) async {
    dynamic response =
        await _apiServices.postApiResponse(AppUrls.verifyOtpUrl, data);
    try {
      return OtpVerifiedResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<HashToken> resendOtp(dynamic data) async {
    dynamic response =
        await _apiServices.postApiResponse(AppUrls.resendOtpUrl, data);
    try {
      return HashToken.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
