
class WorkoutDetailData {
    final ExercisePageData? exercisePageData;

    WorkoutDetailData({
        this.exercisePageData,
    });

    factory WorkoutDetailData.fromJson(Map<String, dynamic> json) => WorkoutDetailData(
        exercisePageData: json["exercise_page_data"] == null ? null : ExercisePageData.fromJson(json["exercise_page_data"]),
    );

    Map<String, dynamic> toJson() => {
        "exercise_page_data": exercisePageData?.toJson(),
    };
}

class ExercisePageData {
    final int? id;
    final DateTime? createdAt;
    final DateTime? modifiedAt;
    final String? exerciseId;
    final String? exerciseName;
    final String? exerciseImage;
    final List<String>? exerciseKeys;
    final String? exerciseType;
    final String? exerciseCategory;

    ExercisePageData({
        this.id,
        this.createdAt,
        this.modifiedAt,
        this.exerciseId,
        this.exerciseName,
        this.exerciseImage,
        this.exerciseKeys,
        this.exerciseType,
        this.exerciseCategory,
    });

    factory ExercisePageData.fromJson(Map<String, dynamic> json) => ExercisePageData(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        modifiedAt: json["modified_at"] == null ? null : DateTime.parse(json["modified_at"]),
        exerciseId: json["exercise_id"],
        exerciseName: json["exercise_name"],
        exerciseImage: json["exercise_image"],
        exerciseKeys: json["exercise_keys"] == null ? [] : List<String>.from(json["exercise_keys"]!.map((x) => x)),
        exerciseType: json["exercise_type"],
        exerciseCategory: json["exercise_category"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "modified_at": modifiedAt?.toIso8601String(),
        "exercise_id": exerciseId,
        "exercise_name": exerciseName,
        "exercise_image": exerciseImage,
        "exercise_keys": exerciseKeys == null ? [] : List<dynamic>.from(exerciseKeys!.map((x) => x)),
        "exercise_type": exerciseType,
        "exercise_category": exerciseCategory,
    };
}
