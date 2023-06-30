class FoodInsightData {
    final double? targetCalorie;
    final double? targetFat;
    final double? targetCarbs;
    final double? targetProtein;
    final double? targetFibre;
    final double? eatenCalorie;
    final double? eatenFat;
    final double? eatenCarbs;
    final double? eatenProtein;
    final double? eatenFibre;
    final double? caloriePercentage;
    final double? fatPercentage;
    final double? proteinPercentage;
    final double? carbsPercentage;
    final double? fibrePercentage;

    FoodInsightData({
        this.targetCalorie,
        this.targetFat,
        this.targetCarbs,
        this.targetProtein,
        this.targetFibre,
        this.eatenCalorie,
        this.eatenFat,
        this.eatenCarbs,
        this.eatenProtein,
        this.eatenFibre,
        this.caloriePercentage,
        this.fatPercentage,
        this.proteinPercentage,
        this.carbsPercentage,
        this.fibrePercentage,
    });

    factory FoodInsightData.fromJson(Map<String, dynamic> json) => FoodInsightData(
        targetCalorie: json["target_calorie"]?.toDouble(),
        targetFat: json["target_fat"]?.toDouble(),
        targetCarbs: json["target_carbs"]?.toDouble(),
        targetProtein: json["target_protein"]?.toDouble(),
        targetFibre: json["target_fibre"]?.toDouble(),
        eatenCalorie: json["eaten_calorie"]?.toDouble()?.toDouble(),
        eatenFat: json["eaten_fat"]?.toDouble(),
        eatenCarbs: json["eaten_carbs"]?.toDouble(),
        eatenProtein: json["eaten_protein"]?.toDouble(),
        eatenFibre: json["eaten_fibre"]?.toDouble(),
        caloriePercentage: json["calorie_percentage"]?.toDouble(),
        fatPercentage: json["fat_percentage"]?.toDouble(),
        proteinPercentage: json["protein_percentage"]?.toDouble(),
        carbsPercentage: json["carbs_percentage"]?.toDouble(),
        fibrePercentage: json["fibre_percentage"]?.toDouble(),
    );
}
