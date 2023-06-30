/// Navigation Events

abstract class NavigationEvent {
  final Object? arguments;

  NavigationEvent({this.arguments});
}

class ScreenPushedEvent extends NavigationEvent {
  final String routePath;

  ScreenPushedEvent(this.routePath, {super.arguments});
}

class ScreenPushedAndRemoveUntilEvent extends NavigationEvent {
  final String routePath;
  final String removeUntilPath;
  final String? from;

  ScreenPushedAndRemoveUntilEvent(this.routePath, this.removeUntilPath,
      {this.from, super.arguments});
}

class ScreenPopEvent extends NavigationEvent {
  ScreenPopEvent({super.arguments});
}

