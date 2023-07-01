import 'package:fittle_ai/bloc/event/workout_track_event.dart';
import 'package:fittle_ai/bloc/state/workout_track_state.dart';
import 'package:fittle_ai/model/workout_search_model.dart';
import 'package:fittle_ai/repository/workout_track_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/singleton.dart';

class WorkoutTrackBloc
    extends Bloc<WorkoutTrackingEvent, WorkoutTrackingState> {
  final WorkoutTrackRepo _workoutTrackRepo = WorkoutTrackRepo();
  final sharedRepo = Singleton().sharedRepo;
  WorkoutTrackBloc() : super(WorkoutTrackingInitialState()) {
    on<WorkoutTrackingFetchedEvent>(_onWorkoutTrackingFetchedEvent);
    on<WorkoutSearchedEvent>(_onWorkoutSearchedEvent);
    on<WorkoutDetailFetchedEvent>(_onWorkoutDetailFetchedEvent);
    on<PostUpdatedWorkoutTrackEvent>(_onPostUpdatedWorkoutTrackEvent);
    on<WorkoutTrackDeleteEvent>(_onWorkoutTrackDeleteEvent);
  }
  void _onWorkoutDetailFetchedEvent(
    WorkoutDetailFetchedEvent event,
    Emitter emit,
  ) async {
    emit(WorkoutDetailLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      if (userId != null && profileId != null) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "exercise_id": event.exerciseId
        };
        var workoutDetailData =
            await _workoutTrackRepo.getWorkoutDetailData(data);
        emit(WorkoutDetailFetchedState(workoutDetailData));
      }
    } catch (e) {
      addError(e);
      emit(WorkoutDetailErrorState(e.toString()));
    }
  }

  void _onWorkoutTrackingFetchedEvent(
    WorkoutTrackingFetchedEvent event,
    Emitter emit,
  ) async {
    emit(WorkoutTrackingLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var isProfileComplete = await sharedRepo.readProfileCompletionStatus();
      if (userId != null &&
          profileId != null &&
          isProfileComplete != null &&
          isProfileComplete) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "request_date": event.date
        };
        var workoutTrackData =
            await _workoutTrackRepo.fetchWorkoutTrackData(data);
        emit(WorkoutTrackingFetchedState(workoutTrackData));
      }
    } catch (e) {
      addError(e);
      emit(WorkoutTrackingErrorState(e.toString()));
    }
  }

  void _onPostUpdatedWorkoutTrackEvent(
    PostUpdatedWorkoutTrackEvent event,
    Emitter emit,
  ) async {
    emit(WorkoutTrackingLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var isProfileComplete = await sharedRepo.readProfileCompletionStatus();
      if (userId != null &&
          profileId != null &&
          isProfileComplete != null &&
          isProfileComplete) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "request_date": event.date,
          "exercise_raw_data":
              event.workoutTrackData.toJsonForUpdate()["exercise_raw_data"]
        };

        var message = await _workoutTrackRepo.updateWorkoutTrack(data);
        emit(WorkoutTrackingFetchedState(event.workoutTrackData,
            message: message));
      }
    } catch (e) {
      addError(e);
      emit(WorkoutTrackingErrorState(e.toString()));
    }
  }

  void _onWorkoutTrackDeleteEvent(
    WorkoutTrackDeleteEvent event,
    Emitter emit,
  ) async {
    emit(WorkoutTrackingLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var isProfileComplete = await sharedRepo.readProfileCompletionStatus();
      if (userId != null &&
          profileId != null &&
          isProfileComplete != null &&
          isProfileComplete) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "request_date": event.date,
          "exercise_id": event.exerciseId,
        };

        var message = await _workoutTrackRepo.deleteWorkoutTrack(data);
        event.workoutTrackData.userExerciseData
            ?.removeWhere((element) => element.exerciseId == event.exerciseId);
        emit(WorkoutTrackingFetchedState(event.workoutTrackData,
            message: message));
      }
    } catch (e) {
      addError(e);
      emit(WorkoutTrackingErrorState(e.toString()));
    }
  }

  void _onWorkoutSearchedEvent(
    WorkoutSearchedEvent event,
    Emitter emit,
  ) async {
    emit(WorkoutSearchedLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      if (userId != null && profileId != null) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "exercise_name": event.keyword
        };
        List<ExerciseList> exerciseList;
        if (event.isFrequent) {
          exerciseList =
              (await _workoutTrackRepo.getUserFrequentSearchedWorkoutData(data))
                      .frequentSearchedFoodList ??
                  [];
        } else {
          exerciseList = (await _workoutTrackRepo.getSearchedWorkoutData(data))
                  .exerciseList ??
              [];
        }
        emit(WorkoutSearchedState(exerciseList, isFrequent: event.isFrequent));
      }
    } catch (e) {
      addError(e);
      emit(WorkoutSearchedErrorState(e.toString()));
    }
  }
}
