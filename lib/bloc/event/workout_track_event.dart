import '../../model/wokout_track_model.dart';

abstract class WorkoutTrackingEvent {}

class WorkoutTrackingFetchedEvent extends WorkoutTrackingEvent {
  final String date;

  WorkoutTrackingFetchedEvent(this.date);
}

class WorkoutSearchedEvent extends WorkoutTrackingEvent {
  final String? keyword;
  final bool isFrequent;

  WorkoutSearchedEvent({this.keyword, this.isFrequent = false});
}

class WorkoutDetailFetchedEvent extends WorkoutTrackingEvent {
  final String exerciseId;

  WorkoutDetailFetchedEvent(this.exerciseId);
}

class PostUpdatedWorkoutTrackEvent extends WorkoutTrackingEvent {
  final WorkoutTrackData workoutTrackData;
  final String date;
  PostUpdatedWorkoutTrackEvent(this.workoutTrackData, this.date);
}

class WorkoutTrackDeleteEvent extends WorkoutTrackingEvent {
  final String date;
  final String exerciseId;
    final WorkoutTrackData workoutTrackData;


  WorkoutTrackDeleteEvent(this.workoutTrackData, {required this.date, required this.exerciseId});
}
