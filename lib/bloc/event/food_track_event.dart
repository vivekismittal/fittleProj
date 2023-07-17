import 'package:fittle_ai/model/food_tracking_model.dart';

abstract class FoodTrackEvent {}

class FetchFoodTrackDataEvent extends FoodTrackEvent {
  final String categoryType;
  final String requestDate;

  FetchFoodTrackDataEvent(this.categoryType, this.requestDate);
}

class FoodTrackSaveBtnEnabledEvent extends FoodTrackEvent {}

class FoodSearchedEvent extends FoodTrackEvent {
  final String? foodKeyword;
  final bool isFrequent;

  FoodSearchedEvent({this.foodKeyword, this.isFrequent = false});
}

class FoodReportMissingEvent extends FoodTrackEvent {
  final String? foodName;

  FoodReportMissingEvent(this.foodName);
}

class FoodDetailFetchedEvent extends FoodTrackEvent {
  final String foodId;

  FoodDetailFetchedEvent(this.foodId);
}

class FoodTrackDataUpdatedEvent extends FoodTrackEvent {
  final FoodTrackingData updatedFoodTrack;
  final String date;
  final String categoryType;
  FoodTrackDataUpdatedEvent(
      this.updatedFoodTrack, this.date, this.categoryType);
}

class FoodTrackDataMoveCopyEvent extends FoodTrackEvent {
  final String date;
  final String categoryTypeFrom;
  final String categoryTypeto;
  final bool isMove;
  final String foodId;

  FoodTrackDataMoveCopyEvent(
    this.date,
    this.categoryTypeFrom,
    this.categoryTypeto,
    this.isMove,
    this.foodId,
  );
}

class FoodTrackDataDeleteEvent extends FoodTrackEvent {
  final String date;
  final String categoryTypeFrom;
  final bool isDelete;
  final String foodId;
  final FoodTrackingData updatedData;

  FoodTrackDataDeleteEvent(
    this.date,
    this.categoryTypeFrom,
    this.foodId,
    this.isDelete,
    this.updatedData,
  );
}

class FoodTrackReportIssuesEvent extends FoodTrackEvent {
  final String foodId;
  final String foodName;
  final List<String> reportIssues;

  FoodTrackReportIssuesEvent(this.foodId, this.foodName, this.reportIssues);
}
