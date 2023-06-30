
class WorkoutTrackData {
    final List<UserExerciseDatum>? userExerciseData;

    WorkoutTrackData({
        this.userExerciseData,
    });

    factory WorkoutTrackData.fromJson(Map<String, dynamic> json) => WorkoutTrackData(
        userExerciseData: json["user_exercise_data"] == null ? [] : List<UserExerciseDatum>.from(json["user_exercise_data"]!.map((x) => UserExerciseDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user_exercise_data": userExerciseData == null ? [] : List<dynamic>.from(userExerciseData!.map((x) => x.toJson())),
    };
    Map<String, dynamic> toJsonForUpdate() => {
        "exercise_raw_data": userExerciseData == null ? [] : List<dynamic>.from(userExerciseData!.map((x) => x.toJson())),
    };
}

class UserExerciseDatum {
    final String? exerciseId;
    final String? exerciseName;
    final Map<String,dynamic>? exerciseData;

    UserExerciseDatum({
        this.exerciseId,
        this.exerciseName,
        this.exerciseData,
    });

    factory UserExerciseDatum.fromJson(Map<String, dynamic> json) => UserExerciseDatum(
        exerciseId: json["exercise_id"],
        exerciseName: json["exercise_name"],
        exerciseData: json["exercise_data"] ,
    );

    Map<String, dynamic> toJson() => {
        "exercise_id": exerciseId,
        "exercise_name": exerciseName,
        "exercise_data": exerciseData,
    };
}

// class ExerciseData {
//     final int? reps;
//     final int? sets;
//     final int? weight;

//     ExerciseData({
//         this.reps,
//         this.sets,
//         this.weight,
//     });

//     factory ExerciseData.fromJson(Map<String, dynamic> json) => ExerciseData(
//         reps: json["reps"],
//         sets: json["sets"],
//         weight: json["weight"],
//     );

//     Map<String, dynamic> toJson() => {
//         "reps": reps,
//         "sets": sets,
//         "weight": weight,
//     };
// }
