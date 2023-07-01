import 'package:fittle_ai/bloc/event/profile_event.dart';
import 'package:fittle_ai/bloc/state/profile_state.dart';
import 'package:fittle_ai/model/create_update_profile_response.dart';
import 'package:fittle_ai/repository/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/shared_repo.dart';
import '../utils/singleton.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SharedRepo _sharedRepo = Singleton().sharedRepo;
  final ProfileRepo _profileRepo = ProfileRepo();

  ProfileBloc() : super(ProfileInitialState()) {
    on<ProfileCreatedUpdatedEvent>(_onProfileCreatedUpdatedEvent);
    on<ProfileBackEvent>((event, emit) => emit(ProfileBackState()));
    on<ProfileEnabledProceedEvent>(
        (event, emit) => emit(ProfileEnabledProceedState(event.index)));
    on<ProfileDisabledProceedEvent>(
        (event, emit) => emit(ProfileDisabledProceedState(event.index)));
    on<ProfileFetchUserDataEvent>(_onProfileFetchUserDataEvent);
  }

  void _onProfileFetchUserDataEvent(
      ProfileFetchUserDataEvent event, Emitter emit) async {
    emit(ProfileFetchUserDataLoadingState());
    try {
      var userId = await _sharedRepo.readUserId();
      var profileId = await _sharedRepo.readProfileId();
      var isProfileComplete = await _sharedRepo.readProfileCompletionStatus();
      if (userId != null &&
          profileId != null &&
          isProfileComplete != null &&
          isProfileComplete) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
        };
        var userData = await _profileRepo.getUserProfile(data);
        emit(ProfileFetchUserDataState(userData));
      }
    } catch (e) {
      addError(e);
      emit(ProfileFetchUserDataErrorState(e.toString()));
    }
  }

  void _onProfileCreatedUpdatedEvent(
      ProfileCreatedUpdatedEvent event, Emitter emit) async {
    emit(ProfileLoadingState());
    var eventData = event.data;
    try {
      var profileId = await _sharedRepo.readProfileId();
      var userId = await _sharedRepo.readUserId();
      if (userId == null) {
        emit(UserIdNotFoundState());
      } else {
        Map<String, dynamic> data = {
          "profile_index": event.currentIndex + 1,
          "user_id": userId
        };
        if (profileId != null) {
          data["profile_id"] = profileId;
        }
        data.addAll(eventData);

        CreateUpdateProfileResponse createUpdateProfileResponse =
            await _profileRepo.createUpdateProfile(data);
        if (createUpdateProfileResponse.profileId != null &&
            createUpdateProfileResponse.nextProfileIndex != null) {
          await _sharedRepo
              .saveProfileId(createUpdateProfileResponse.profileId!);
          await _sharedRepo.saveProfileCompletionStatus(true);
          emit(ProfileCreatedUpdatedState(
            createUpdateProfileResponse.nextProfileIndex! - 1,
            event.profileData,
            event.isProfileFinished,
          ));
        }
      }
    } catch (e, s) {
      print("errr");
      addError(e, s);
      emit(ProfileErrorState("$e"));
    }
  }
}
