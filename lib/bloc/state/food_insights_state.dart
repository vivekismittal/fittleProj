import 'package:fittle_ai/model/food_insight_model.dart';

abstract class FoodInsightsState {}
class FoodInsightsInitialState extends FoodInsightsState {}
class FoodInsightsLoadingState extends FoodInsightsState {}
class FoodInsightsErrorState extends FoodInsightsState {
  final String message;

  FoodInsightsErrorState(this.message);
}
class FoodInsightsFetchedState extends FoodInsightsState {
  final FoodInsightData foodInsightData;

  FoodInsightsFetchedState(this.foodInsightData);
}
