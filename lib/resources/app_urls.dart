class AppUrls {
  static const baseUrl = "https://94fa-103-95-83-105.ngrok-free.app";
  static const searchBaseUrl = "https://5b7c-103-95-83-220.ngrok-free.app";

  static const String sendOtpUrl = "$baseUrl/user/api/send-otp/";
  static const String verifyOtpUrl = "$baseUrl/user/api/verify-otp/";
  static const String resendOtpUrl = "$baseUrl/user/api/resend-otp/";
  static const String createUpdateProfileUrl =
      "$baseUrl/user/api/create-update-user-profile/";
  static const String getHomeDashboardDataUrl =
      "$baseUrl/user/api/get-dashboard/";
  static const String getCategoryWiseFoodDataUrl =
      "$baseUrl/user/api/get-category-data/";
  static const String searchFoodUrl = "$searchBaseUrl/search/food-item/";
  static const String getFrequentFoodUrl =
      "$searchBaseUrl/search/get-frequent/";
  static const String foodDetailUrl = "$searchBaseUrl/search/food-page/";
  static const String foodInsightUrl = "$baseUrl/user/api/get-insights/";
  static const String getWorkoutTrackDataUrl =
      "$baseUrl/user/api/get-exercise-data/";
  static const String searchWorkoutUrl = "$searchBaseUrl/search/exercise-item/";
  static const String getFrequentWorkoutUrl =
      "$searchBaseUrl/search/get-frequent-exercise/";
  static const String getWorkoutDetailDataUrl =
      "$searchBaseUrl/search/exercise-page/";
  static const updateWaterIntakeUrl = "$baseUrl/user/api/water-update/";
  static const updateWorkoutTrackUrl =
      "$baseUrl/user/api/update-exercise-data/";
  static const getUserProfileData = "$baseUrl/user/api/get-user-profile/";
  static const getProgressData = "$baseUrl/user/api/get-progress-bar/";
  static const updateFoodTrackUrl= "$baseUrl/user/api/update-category-data/";
  static const copyMoveFoodTrackUrl= "$baseUrl/user/api/copy-move-category-data/";
  static const deleteFoodTrackUrl= "$baseUrl/user/api/delete-category-food/";
  static const reportIssuesUrl = "$baseUrl/user/api/report-issue/";
  

}
