
import 'package:flutter_dotenv/flutter_dotenv.dart';
abstract class AppUrls {

   static final  String? baseUrl = dotenv.env["BASEURL"];
  static final String? searchBaseUrl = dotenv.env["SEARCHBASEURL"];

  static final String sendOtpUrl = "$baseUrl/user/api/send-otp/";
  static final String verifyOtpUrl = "$baseUrl/user/api/verify-otp/";
  static final String resendOtpUrl = "$baseUrl/user/api/resend-otp/";
  static final String createUpdateProfileUrl =
      "$baseUrl/user/api/create-update-user-profile/";
  static final String getHomeDashboardDataUrl =
      "$baseUrl/user/api/get-dashboard/";
  static final String getCategoryWiseFoodDataUrl =
      "$baseUrl/user/api/get-category-data/";
  static final String searchFoodUrl = "$searchBaseUrl/search/food-item/";
  static final String getFrequentFoodUrl =
      "$searchBaseUrl/search/get-frequent/";
  static final String foodDetailUrl = "$searchBaseUrl/search/food-page/";
  static final String foodInsightUrl = "$baseUrl/user/api/get-insights/";
  static final String getWorkoutTrackDataUrl =
      "$baseUrl/user/api/get-exercise-data/";
  static final String searchWorkoutUrl = "$searchBaseUrl/search/exercise-item/";
  static final String getFrequentWorkoutUrl =
      "$searchBaseUrl/search/get-frequent-exercise/";
  static final String getWorkoutDetailDataUrl =
      "$searchBaseUrl/search/exercise-page/";
  static final updateWaterIntakeUrl = "$baseUrl/user/api/water-update/";
  static final updateWorkoutTrackUrl =
      "$baseUrl/user/api/update-exercise-data/";
  static final getUserProfileData = "$baseUrl/user/api/get-user-profile/";
  static final getProgressData = "$baseUrl/user/api/get-progress-bar/";
  static final updateFoodTrackUrl= "$baseUrl/user/api/update-category-data/";
  static final copyMoveFoodTrackUrl= "$baseUrl/user/api/copy-move-category-data/";
  static final deleteFoodTrackUrl= "$baseUrl/user/api/delete-category-food/";
  static final reportIssuesUrl = "$baseUrl/user/api/report-issue/";
  static final deleteWorkoutTrackUrl = "$baseUrl/user/api/delete-exercise-data/";
  static final missingFoodWorkoutUrl="$searchBaseUrl/missing/add-food-exercise-data/";
}
