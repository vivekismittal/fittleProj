class HomeDashBoardResponse {
  DietWorkoutDataModel? dietWorkoutData;
  List<BannerModel>? bannerData;
  bool? showPopupForWeight;
  Map? targetData;
  HomeDashBoardResponse.fromJson(dynamic json) {
    dietWorkoutData = DietWorkoutDataModel.fromJson(json["diet_workout_data"]);
    bannerData = BannerModel().getBannerDataFrom(json["banner_data"]);
    showPopupForWeight = json["show_popup_for_weight"];
    targetData = json["target_data"];
  }
}

class DietWorkoutDataModel {
  double? targetCalorie;
  double? targetFat;
  double? targetCarbs;
  double? targetProtein;
  double? targetFibre;
  double? caloriePercentage;
  double? fatPercentage;
  double? carbsPercentage;
  double? fibrePercentage;
  double? proteinPercentage;
  double? calorieBurntTarget;
  int? waterTarget;
  int? waterIntake;

  DietWorkoutDataModel.fromJson(dynamic json) {
    targetCalorie = ((json["target_calorie"]) as dynamic).toDouble();
    targetFat = ((json["target_fat"]) as dynamic).toDouble();
    targetCarbs = ((json["target_carbs"]) as dynamic).toDouble();
    targetProtein = ((json["target_protein"]) as dynamic).toDouble();
    targetFibre = ((json["target_fibre"]) as dynamic).toDouble();
    caloriePercentage = ((json["calorie_percentage"]) as dynamic).toDouble();
    fatPercentage = ((json["fat_percentage"]) as dynamic).toDouble();
    carbsPercentage = ((json["carbs_percentage"]) as dynamic).toDouble();
    fibrePercentage = ((json["fibre_percentage"]) as dynamic).toDouble();
    proteinPercentage = ((json["protein_percentage"]) as dynamic).toDouble();
    calorieBurntTarget = ((json["calorie_burnt_target"]) as dynamic).toDouble();
    waterIntake = ((json["water_intake"]) as dynamic).toInt();
    waterTarget = ((json["water_target"]) as dynamic).toInt();
  }
}

class BannerModel {
  String? bannerHeading;
  String? bannerDesription;
  String? bannerImage;
  BannerModel();
  List<BannerModel> getBannerDataFrom(List<dynamic> jsonList) {
    List<BannerModel> bannerData = [];
    for (var json in jsonList) {
      var banner = BannerModel();
      banner.bannerHeading = json["banner_heading"];
      banner.bannerDesription = json["banner_description"];
      banner.bannerImage = json["banner_image"];
      bannerData.add(banner);
    }
    return bannerData;
  }
}
// {
//     "diet_workout_data": {
//         "target_calorie": 2191.7000000000003,
//         "target_fat": 60.88055555555556,
//         "target_carbs": 219.17000000000004,
//         "target_protein": 191.77375,
//         "target_fibre": 25,
//         "calorie_percentage": 0,
//         "fat_percentage": 0,
//         "protein_percentage": 0,
//         "carbs_percentage": 0,
//         "fibre_percentage": 0,
//         "calorie_burnt_target": 2191.7000000000003,
//         "water_target": 8,
//         "water_intake": 0
//     },
//     "progress_data": true,
//     "banner_data": [
//         {
//             "banner_heading": "Drink Chaach",
//             "banner_desription": "this will provide 25 Kcal"
//         }
//     ]
// }