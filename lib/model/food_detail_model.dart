class FoodDetailModel {
    FoodPageData? foodPageData;

    FoodDetailModel({
        this.foodPageData,
    });

    factory FoodDetailModel.fromJson(Map<String, dynamic> json) => FoodDetailModel(
        foodPageData: json["food_page_data"] == null ? null : FoodPageData.fromJson(json["food_page_data"]),
    );

    Map<String, dynamic> toJson() => {
        "food_page_data": foodPageData?.toJson(),
    };
}

class FoodPageData {
    int? id;
    String? foodId;
    String? foodName;
    String? foodImage;
    int? foodWeight;
    double? foodCalorie;
    double? foodProtein;
    double? foodFats;
    double? foodCarbs;
    double? foodFibre;
    List<String>? foodServingSizes;
    String? foodType;

    FoodPageData({
        this.id,
        this.foodId,
        this.foodName,
        this.foodImage,
        this.foodWeight,
        this.foodCalorie,
        this.foodProtein,
        this.foodFats,
        this.foodCarbs,
        this.foodFibre,
        this.foodServingSizes,
        this.foodType,
    });

    factory FoodPageData.fromJson(Map<String, dynamic> json) => FoodPageData(
        id: json["id"],
        foodId: json["food_id"],
        foodName: json["food_name"],
        foodImage: json["food_image"],
        foodWeight: json["food_weight"],
        foodCalorie: json["food_calorie"],
        foodProtein: json["food_protein"],
        foodFats: json["food_fats"],
        foodCarbs: json["food_carbs"],
        foodFibre: json["food_fibre"],
        foodServingSizes: json["food_serving_sizes"] == null ? [] : List<String>.from(json["food_serving_sizes"]!.map((x) => x)),
        foodType: json["food_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "food_id": foodId,
        "food_name": foodName,
        "food_image": foodImage,
        "food_weight": foodWeight,
        "food_calorie": foodCalorie,
        "food_protein": foodProtein,
        "food_fats": foodFats,
        "food_carbs": foodCarbs,
        "food_fibre": foodFibre,
        "food_serving_sizes": foodServingSizes == null ? [] : List<dynamic>.from(foodServingSizes!.map((x) => x)),
        "food_type": foodType,
    };
}
