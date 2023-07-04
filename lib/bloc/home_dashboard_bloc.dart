import 'package:fittle_ai/repository/home_repo.dart';
import 'package:fittle_ai/repository/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/singleton.dart';
import 'home_dashboard_bloc.dart';

export './event/home_dashboard_event.dart';
export './state/home_dashboard_state.dart';

class HomeDashboardBloc extends Bloc<HomeDasboardEvent, HomeDasboardState> {
  final HomeRepo _homeRepo = HomeRepo();
  final sharedRepo = Singleton().sharedRepo;
  final ProfileRepo _profileRepo = ProfileRepo();

  HomeDashboardBloc() : super(HomeDasboardInitialState()) {
    on<FetchHomeDasboardDataEvent>(_onFetchHomeDasboardDataEvent);
    on<HomeDasboardUpdateWaterIntakeEvent>(
        _onHomeDasboardUpdateWaterIntakeEvent);
    on<HomeDasboardProgressDataFetchedEvent>(
        _onHomeDasboardProgressDataFetchedEvent);
    on<HomeWeightUpdateEvent>(_onHomeWeightUpdateEvent);
  }

  void _onHomeWeightUpdateEvent(
    HomeWeightUpdateEvent event,
    Emitter emit,
  ) async {
    emit(HomeDasboardLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var profileIndex = await sharedRepo.readProfileIndex();
      if (userId != null &&
          profileId != null &&
          profileIndex != null &&
          profileIndex==-1) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "weight": event.weight,
          "profile_index": 8,
          "is_weight_in_lbs": false
        };
        await _profileRepo.createUpdateProfile(data);
        add(FetchHomeDasboardDataEvent(event.requestDate));
        // emit(HomeDasboardSuccessState(homeData));
      }
    } catch (e) {
      addError(e);
      emit(HomeDasboardErrorState(e.toString()));
    }
  }

  void _onFetchHomeDasboardDataEvent(
    FetchHomeDasboardDataEvent event,
    Emitter emit,
  ) async {
    emit(HomeDasboardLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var profileIndex = await sharedRepo.readProfileIndex();
      if (userId != null &&
          profileId != null &&
          profileIndex != null &&
          profileIndex==-1) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "request_date": event.requestDate
        };
        var homeData = await _homeRepo.getHomeDashboardData(data);
        emit(HomeDasboardSuccessState(homeData));
      }
    } catch (e) {
      addError(e);
      emit(HomeDasboardErrorState(e.toString()));
    }
  }

  void _onHomeDasboardUpdateWaterIntakeEvent(
    HomeDasboardUpdateWaterIntakeEvent event,
    Emitter emit,
  ) async {
    emit(HomeDasboardWaterIntakeLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var profileIndex = await sharedRepo.readProfileIndex();
      if (userId != null &&
          profileId != null &&
          profileIndex != null &&
          profileIndex==-1) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "request_date": event.requestDate,
          "water_intake": event.updatedWaterIntake,
        };
        var message = await _homeRepo.updateWaterIntake(data);
        emit(HomeDasboardWaterIntakeSuccessState(
            message, event.updatedWaterIntake));
      }
    } catch (e) {
      addError(e);
      emit(HomeDasboardWaterIntakeErrorState(e.toString()));
    }
  }

  void _onHomeDasboardProgressDataFetchedEvent(
    HomeDasboardProgressDataFetchedEvent event,
    Emitter emit,
  ) async {
    emit(HomeDasboardProgressDataLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      var profileIndex = await sharedRepo.readProfileIndex();
      if (userId != null &&
          profileId != null &&
          profileIndex != null &&
          profileIndex==-1) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "request_date": event.requestDate,
          "progress_type": event.progressType,
        };
        var progressData = await _homeRepo.getProgressData(data);
        emit(HomeDasboardProgressDataFetchedState(progressData));
      }
    } catch (e) {
      addError(e);
      emit(HomeDasboardProgressDataErrorState(e.toString()));
    }
  }
}
