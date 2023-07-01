import 'package:fittle_ai/model/food_detail_model.dart';
import 'package:fittle_ai/model/food_search_model.dart';
import 'package:fittle_ai/model/food_tracking_model.dart';

abstract class FoodTrackState {}

class FoodTrackInititalState extends FoodTrackState {}

class FoodTrackLoadingState extends FoodTrackState {}

class FoodTrackInitialState extends FoodTrackState {}

class FoodTrackSaveBtnEnabledState extends FoodTrackState {}

class FoodTrackErrorState extends FoodTrackState {
  final String message;

  FoodTrackErrorState(this.message);
}

class FoodTrackSuccessState extends FoodTrackState {
  final FoodTrackingData foodData;
final String? message;
final bool isUpdated;
  FoodTrackSuccessState(this.foodData, this.isUpdated, {this.message});
}

class FoodSearchLoadingState extends FoodTrackState {}

class FoodSearchErrorState extends FoodTrackState {
  final String message;
  final bool isFrequent;
  FoodSearchErrorState(this.message, {this.isFrequent = false});
}

class FoodSearchedState extends FoodTrackState {
  final bool isFrequent;
  final List<FoodList> foodList;

  FoodSearchedState(this.foodList, {this.isFrequent = false});
}

class FoodDetailFetchedState extends FoodTrackState {
  final FoodDetailModel foodDetail;

  FoodDetailFetchedState(this.foodDetail);
}

class FoodDetailLoadingState extends FoodTrackState {}

class FoodDetailErrorState extends FoodTrackState {
  final String message;

  FoodDetailErrorState(this.message);
}
