import 'package:fittle_ai/model/home_dashboard_response.dart';

abstract class HomeDasboardState {}

class HomeDasboardLoadingState extends HomeDasboardState {}

class HomeDasboardInitialState extends HomeDasboardState {}

class HomeDasboardErrorState extends HomeDasboardState {
  final String message;

  HomeDasboardErrorState(this.message);
}

class HomeDasboardSuccessState extends HomeDasboardState {
  final HomeDashBoardResponse homeData;

  HomeDasboardSuccessState(this.homeData);
}

class HomeDasboardWaterIntakeLoadingState extends HomeDasboardState {}

class HomeDasboardWaterIntakeErrorState extends HomeDasboardState {
  final String message;

  HomeDasboardWaterIntakeErrorState(this.message);
}

class HomeDasboardWaterIntakeSuccessState extends HomeDasboardState {
  final String message;
  final int updatedIntake;
  HomeDasboardWaterIntakeSuccessState(this.message, this.updatedIntake);
}

class HomeDasboardProgressDataFetchedState extends HomeDasboardState {
  final List<Map<String, double>> progressData;

  HomeDasboardProgressDataFetchedState(this.progressData);
}

class HomeDasboardProgressDataLoadingState extends HomeDasboardState {}

class HomeDasboardProgressDataErrorState extends HomeDasboardState {
  final String message;

  HomeDasboardProgressDataErrorState(this.message);
}

