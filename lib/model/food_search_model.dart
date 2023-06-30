
class FoodSearchedModel {
    final List<FoodList>? foodList;

    FoodSearchedModel({
        this.foodList,
    });

    factory FoodSearchedModel.fromJson(Map<String, dynamic> json) => FoodSearchedModel(
        foodList: json["food_list"] == null ? [] : List<FoodList>.from(json["food_list"]!.map((x) => FoodList.fromJson(x))),
    );
}
class FoodUserFrequentSearchModel {
    final List<FoodList>? frequentSearchedFoodList;

    FoodUserFrequentSearchModel({
        this.frequentSearchedFoodList,
    });

    factory FoodUserFrequentSearchModel.fromJson(Map<String, dynamic> json) => FoodUserFrequentSearchModel(
        frequentSearchedFoodList: json["frequent_searches"] == null ? [] : List<FoodList>.from(json["frequent_searches"]!.map((x) => FoodList.fromJson(x))),
    );
}

class FoodList {
    final String? foodId;
    final String? foodName;

    FoodList({
        this.foodId,
        this.foodName,
    });

    factory FoodList.fromJson(Map<String, dynamic> json) => FoodList(
        foodId: json["food_id"],
        foodName: json["food_name"],
    );

}
