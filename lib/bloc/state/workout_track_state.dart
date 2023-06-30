import 'package:fittle_ai/model/wokout_track_model.dart';
import 'package:fittle_ai/model/workout_detail_model.dart';
import 'package:fittle_ai/model/workout_search_model.dart';

abstract class WorkoutTrackingState {}

class WorkoutTrackingFetchedState extends WorkoutTrackingState {
  final String? message;
  final WorkoutTrackData data;

  WorkoutTrackingFetchedState(this.data,{this.message});
}

class WorkoutTrackingInitialState extends WorkoutTrackingState {}

class WorkoutTrackingLoadingState extends WorkoutTrackingState {}

class WorkoutTrackingErrorState extends WorkoutTrackingState {
  final String message;

  WorkoutTrackingErrorState(this.message);
}


class WorkoutSearchedState extends WorkoutTrackingState {
  final bool isFrequent;
  final List<ExerciseList> exerciseList;

  WorkoutSearchedState(this.exerciseList, {this.isFrequent = false});
}

class WorkoutSearchedLoadingState extends WorkoutTrackingState {}

class WorkoutSearchedErrorState extends WorkoutTrackingState {
  final String message;

  WorkoutSearchedErrorState(this.message);
}

class WorkoutDetailFetchedState extends WorkoutTrackingState {
  final WorkoutDetailData exerciseDetail;

  WorkoutDetailFetchedState(this.exerciseDetail);
}

class WorkoutDetailLoadingState extends WorkoutTrackingState {}

class WorkoutDetailErrorState extends WorkoutTrackingState {
  final String message;

  WorkoutDetailErrorState(this.message);
}


// class PostUpdatedWorkoutTrackState extends WorkoutTrackingState {
//   final String message;
//     final WorkoutTrackData updatedWorkoutTrackData;

//   PostUpdatedWorkoutTrackState(this.message, this.updatedWorkoutTrackData);
// }

class PostUpdatedWorkoutErrorState extends WorkoutTrackingState {
  final String message;

  PostUpdatedWorkoutErrorState(this.message);
}

class PostUpdatedWorkoutLoadingState extends WorkoutTrackingState {}
