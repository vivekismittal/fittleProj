import 'package:fittle_ai/utils/screen_paths.dart';
import 'package:fittle_ai/bloc/navigation_bloc.dart';
import 'package:fittle_ai/repository/shared_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/singleton.dart';

export 'event/navigation_event.dart';
export 'state/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final SharedRepo _sharedRepo = Singleton().sharedRepo;
  NavigationBloc() : super(InitialState()) {
    on<ScreenPushedEvent>(
      (event, emit) =>
          emit(PushedState(event.routePath, arguments: event.arguments)),
    );
    on<ScreenPushedAndRemoveUntilEvent>(_onScreenPushedReplacementEvent);
    on<ScreenPopEvent>(
      (event, emit) {

         emit(PopState(arguments: event.arguments));
         emit(InitialState());
      },
    );
  }

  void _onScreenPushedReplacementEvent(
    ScreenPushedAndRemoveUntilEvent event,
    Emitter<NavigationState> emit,
  ) async {
    var fromPath = event.from;
    var routePath = event.routePath;
    if (fromPath == '/') {
      String? userId = await _sharedRepo.readUserId();
      String? profileId = await _sharedRepo.readProfileId();
      var profileIndex = await _sharedRepo.readProfileIndex();
      if (userId != null) {
        routePath = ScreenPaths.profileCompletionScreenPath.name;
        if (profileId != null && profileIndex!=null && profileIndex==-1) {
          routePath = ScreenPaths.homeDashBoardPath.name;
        }
      }
    }
    emit(PushedAndRemoveUntilState(routePath, event.removeUntilPath,
        arguments: event.arguments));
  }
}
