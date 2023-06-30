// import 'dart:convert';

// FoodTrackingData foodTrackingDataFromJson(String str) => FoodTrackingData.fromJson(json.decode(str));

// String foodTrackingDataToJson(FoodTrackingData data) => json.encode(data.toJson());

class FoodTrackingData {
   List<UserFoodDatum>? userFoodData;
  final double? categoryCalorieTarget;
  final double? categoryCaloriePercentage;

  FoodTrackingData({
    this.userFoodData,
    this.categoryCalorieTarget,
    this.categoryCaloriePercentage,
  });

  factory FoodTrackingData.fromJson(Map<String, dynamic> json) =>
      FoodTrackingData(
        userFoodData: json["user_food_data"] == null
            ? []
            : List<UserFoodDatum>.from(
                json["user_food_data"]!.map((x) => UserFoodDatum.fromJson(x))),
        categoryCalorieTarget: json["category_calorie_target"]?.toDouble(),
        categoryCaloriePercentage:
            json["category_calorie_percentage"]?.toDouble(),
      );

  List toJsonForUpdate() => userFoodData == null
      ? []
      : List<dynamic>.from(userFoodData!.map((x) => x.toJson()));
}

class UserFoodDatum {
  final String? foodId;
  final String? foodName;
  double? foodCalorie;
  double? foodProtein;
  double? foodFat;
  double? foodCarbs;
  double? foodFibre;
  int? foodQuantity;
  final String? foodCategoryType;

  UserFoodDatum({
    this.foodId,
    this.foodName,
    this.foodCalorie,
    this.foodProtein,
    this.foodFat,
    this.foodCarbs,
    this.foodFibre,
    this.foodQuantity,
    this.foodCategoryType,
  });

  factory UserFoodDatum.fromJson(Map<String, dynamic> json) => UserFoodDatum(
        foodId: json["food_id"],
        foodName: json["food_name"],
        foodCalorie: json["food_calorie"]?.toDouble(),
        foodProtein: json["food_protein"]?.toDouble(),
        foodFat: json["food_fat"]?.toDouble(),
        foodCarbs: json["food_carbs"]?.toDouble(),
        foodFibre: json["food_fibre"]?.toDouble(),
        foodQuantity: json["food_quantity"],
        foodCategoryType: json["food_category_type"],
      );

  Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "food_name": foodName,
        "food_calorie": foodCalorie,
        "food_protein": foodProtein,
        "food_fat": foodFat,
        "food_carbs": foodCarbs,
        "food_fibre": foodFibre,
        "food_quantity": foodQuantity,
        "food_category_type": foodCategoryType,
      };
}
