import 'package:fittle_ai/model/food_search_model.dart';
import 'package:fittle_ai/repository/food_tracking_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/singleton.dart';
import 'food_track_bloc.dart';

export 'package:fittle_ai/bloc/event/food_track_event.dart';
export 'package:fittle_ai/bloc/state/food_track_state.dart';

class FoodTrackBloc extends Bloc<FoodTrackEvent, FoodTrackState> {
  final FoodTrackRepo _foodTrackRepo = FoodTrackRepo();
  final sharedRepo = Singleton().sharedRepo;

  FoodTrackBloc() : super(FoodTrackInititalState()) {
    on<FetchFoodTrackDataEvent>(_onFetchFoodTrackDataEvent);
    on<FoodTrackSaveBtnEnabledEvent>(
        (event, emit) => emit(FoodTrackSaveBtnEnabledState()));
    on<FoodSearchedEvent>(_onFoodSearchedEvent);
    on<FoodDetailFetchedEvent>(_onFoodDetailFetchedEvent);
    on<FoodTrackDataUpdatedEvent>(_onFoodTrackDataUpdatedEvent);
    on<FoodTrackDataMoveCopyEvent>(_onFoodTrackDataMoveCopyEvent);
    on<FoodTrackDataDeleteEvent>(_onFoodTrackDataDeleteEvent);
    on<FoodTrackReportIssuesEvent>(_onFoodTrackReportIssuesEvent);
    on<FoodReportMissingEvent>(_onFoodReportMissingEvent);
  }

  void _onFoodTrackDataMoveCopyEvent(
    FoodTrackDataMoveCopyEvent event,
    Emitter emit,
  ) async {
    emit(FoodTrackLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var profileIndex = await sharedRepo.readProfileIndex();
      if (userId != null &&
          profileId != null &&
          profileIndex != null &&
          profileIndex == -1) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "request_date": event.date,
          "category_from": event.categoryTypeFrom,
          "category_to": event.categoryTypeto,
          "is_move": event.isMove,
          "food_id": event.foodId,
        };
        var (updatedFoodTrack, message) =
            await _foodTrackRepo.copyMoveFoodTrackData(data);
        emit(FoodTrackSuccessState(updatedFoodTrack, false, message: message));
      }
    } catch (e) {
      addError(e);
      emit(FoodTrackErrorState(e.toString()));
    }
  }

  void _onFoodTrackReportIssuesEvent(
    FoodTrackReportIssuesEvent event,
    Emitter emit,
  ) async {
    emit(FoodTrackLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var profileIndex = await sharedRepo.readProfileIndex();
      if (userId != null &&
          profileId != null &&
          profileIndex != null &&
          profileIndex == -1) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "food_id": event.foodId,
          "food_name": event.foodName,
          "issue_reported": event.reportIssues
        };
        var message = await _foodTrackRepo.reportIssues(data);
        emit(FoodTrackErrorState(message));
      }
    } catch (e) {
      addError(e);
      emit(FoodTrackErrorState(e.toString()));
    }
  }

  void _onFoodReportMissingEvent(
    FoodReportMissingEvent event,
    Emitter emit,
  ) async {
    // emit(FoodTrackLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var profileIndex = await sharedRepo.readProfileIndex();
      if (userId != null &&
          profileId != null &&
          profileIndex != null &&
          profileIndex == -1) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "food_or_exercise_name": event.foodName,
          "type": "food"
        };
        var _ = await _foodTrackRepo.reportMissingFoodWorkout(data);
        // emit(FoodSearchErrorState(message));
      }
    } catch (e) {
      addError(e);
      emit(FoodSearchErrorState(e.toString()));
    }
  }

  void _onFoodTrackDataDeleteEvent(
    FoodTrackDataDeleteEvent event,
    Emitter emit,
  ) async {
    emit(FoodTrackLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var profileIndex = await sharedRepo.readProfileIndex();
      if (userId != null &&
          profileId != null &&
          profileIndex != null &&
          profileIndex == -1) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "request_date": event.date,
          "category_from": event.categoryTypeFrom,
          "food_id": event.foodId,
          "is_delete": true,
        };
        var message = await _foodTrackRepo.deleteFoodTrackData(data);
        emit(FoodTrackSuccessState(event.updatedData, true, message: message));
      }
    } catch (e) {
      addError(e);
      emit(FoodTrackErrorState(e.toString()));
    }
  }

  void _onFoodTrackDataUpdatedEvent(
    FoodTrackDataUpdatedEvent event,
    Emitter emit,
  ) async {
    emit(FoodTrackLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var profileIndex = await sharedRepo.readProfileIndex();
      if (userId != null &&
          profileId != null &&
          profileIndex != null &&
          profileIndex == -1) {
        var foodRawData = event.updatedFoodTrack.toJsonForUpdate();

        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "request_date": event.date,
          "category_type": event.categoryType,
          "food_raw_data": foodRawData
        };

        var message = await _foodTrackRepo.updateFoodTrackData(data);
        emit(FoodTrackSuccessState(event.updatedFoodTrack, true,
            message: message));
      }
    } catch (e) {
      addError(e);
      emit(FoodTrackErrorState(e.toString()));
    }
  }

  void _onFoodDetailFetchedEvent(
    FoodDetailFetchedEvent event,
    Emitter emit,
  ) async {
    emit(FoodDetailLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      if (userId != null && profileId != null) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "food_id": event.foodId
        };
        var foodDetailData = await _foodTrackRepo.getFoodDetailData(data);
        emit(FoodDetailFetchedState(foodDetailData));
      }
    } catch (e) {
      addError(e);
      emit(FoodDetailErrorState(e.toString()));
    }
  }

  void _onFetchFoodTrackDataEvent(
    FetchFoodTrackDataEvent event,
    Emitter emit,
  ) async {
    emit(FoodTrackLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var profileIndex = await sharedRepo.readProfileIndex();
      if (userId != null &&
          profileId != null &&
          profileIndex != null &&
          profileIndex == -1) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "request_date": event.requestDate,
          "category_type": event.categoryType
        };
        var foodTrackData = await _foodTrackRepo.getCategoryWiseFoodData(data);
        emit(FoodTrackSuccessState(foodTrackData, false));
      }
    } catch (e) {
      addError(e);
      emit(FoodTrackErrorState(e.toString()));
    }
  }

  void _onFoodSearchedEvent(
    FoodSearchedEvent event,
    Emitter emit,
  ) async {
    emit(FoodSearchLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      if (userId != null && profileId != null) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "food_name": event.foodKeyword
        };
        List<FoodList> foodList;
        if (event.isFrequent) {
          foodList =
              (await _foodTrackRepo.getUserFrequentSearchedFoodData(data))
                      .frequentSearchedFoodList ??
                  [];
        } else {
          foodList =
              (await _foodTrackRepo.getSearchedFoodData(data)).foodList ?? [];
        }
        emit(FoodSearchedState(foodList, isFrequent: event.isFrequent));
      }
    } catch (e) {
      addError(e);
      emit(FoodSearchErrorState(e.toString()));
    }
  }
}
