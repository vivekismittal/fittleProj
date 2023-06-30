class WorkoutSearchData {
  final List<ExerciseList>? exerciseList;

  WorkoutSearchData({
    this.exerciseList,
  });

  factory WorkoutSearchData.fromJson(Map<String, dynamic> json) =>
      WorkoutSearchData(
        exerciseList: json["exercise_list"] == null
            ? []
            : List<ExerciseList>.from(
                json["exercise_list"]!.map((x) => ExerciseList.fromJson(x))),
      );
}

class WorkoutFrequentSearchData {
  final List<ExerciseList>? frequentSearchedFoodList;

  WorkoutFrequentSearchData({
    this.frequentSearchedFoodList,
  });

  factory WorkoutFrequentSearchData.fromJson(Map<String, dynamic> json) =>
      WorkoutFrequentSearchData(
        frequentSearchedFoodList: json["frequent_searches"] == null
            ? []
            : List<ExerciseList>.from(json["frequent_searches"]!
                .map((x) => ExerciseList.fromJson(x))),
      );
}

class ExerciseList {
  final String? exerciseId;
  final String? exerciseName;

  ExerciseList({
    this.exerciseId,
    this.exerciseName,
  });

  factory ExerciseList.fromJson(Map<String, dynamic> json) => ExerciseList(
        exerciseId: json["exercise_id"],
        exerciseName: json["exercise_name"],
      );
}
