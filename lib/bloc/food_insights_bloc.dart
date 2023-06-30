import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/food_tracking_repo.dart';
import '../utils/singleton.dart';
import 'food_insights_bloc.dart';

export 'state/food_insights_state.dart';
export 'event/food_insights_event.dart';

class FoodInsightsBloc extends Bloc<FoodInsightsEvent, FoodInsightsState> {
  final FoodTrackRepo _foodTrackRepo = FoodTrackRepo();
  final sharedRepo = Singleton().sharedRepo;

  FoodInsightsBloc() : super(FoodInsightsInitialState()) {
    on<FoodInsightsFetchedEvent>(_onFoodInsightsFetchedEvent);
  }

  void _onFoodInsightsFetchedEvent(
    FoodInsightsFetchedEvent event,
    Emitter emit,
  ) async {
    emit(FoodInsightsLoadingState());
    try {
      var userId = await sharedRepo.readUserId();
      var profileId = await sharedRepo.readProfileId();
      if (userId != null && profileId != null) {
        var data = {
          "user_id": userId,
          "profile_id": profileId,
          "request_date": event.date,
          "category_type": event.categoryType
        };
        var foodDetailData = await _foodTrackRepo.getFoodInsightData(data);
        emit(FoodInsightsFetchedState(foodDetailData));
      }
    } catch (e) {
      addError(e);
      emit(FoodInsightsErrorState(e.toString()));
    }
  }
}
