abstract class HomeDasboardEvent {}

class FetchHomeDasboardDataEvent extends HomeDasboardEvent {
  String requestDate;
  FetchHomeDasboardDataEvent(this.requestDate);
}

class HomeDasboardUpdateWaterIntakeEvent extends HomeDasboardEvent {
  String requestDate;
  final int updatedWaterIntake;
  HomeDasboardUpdateWaterIntakeEvent(this.requestDate, this.updatedWaterIntake);
}

class HomeDasboardProgressDataFetchedEvent extends HomeDasboardEvent {
  final String progressType;
  final String requestDate;

  HomeDasboardProgressDataFetchedEvent(this.progressType, this.requestDate);
}

class HomeWeightUpdateEvent extends HomeDasboardEvent{
  final String weight;
final String requestDate;
  HomeWeightUpdateEvent(this.weight, this.requestDate);
   
}