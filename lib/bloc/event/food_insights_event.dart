abstract class FoodInsightsEvent{}
class FoodInsightsFetchedEvent extends FoodInsightsEvent{
  final String date;
final String categoryType;
  FoodInsightsFetchedEvent(this.date, this.categoryType);
}