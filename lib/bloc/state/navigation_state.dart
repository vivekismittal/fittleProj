/// Navigation States
abstract class NavigationState {
  final Object? arguments;

  NavigationState({this.arguments});
}

class PushedState extends NavigationState {
  final String routePath;

  PushedState(this.routePath, {super.arguments});
}

class InitialState extends NavigationState {
  InitialState({super.arguments});
}

class PushedAndRemoveUntilState extends NavigationState {
  final String routePath;
final String removeUntilPath;
  PushedAndRemoveUntilState(this.routePath, this.removeUntilPath, {super.arguments});
}

class PopState extends NavigationState {
  PopState({super.arguments});
}
