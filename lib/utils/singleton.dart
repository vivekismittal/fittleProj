import 'package:fittle_ai/repository/shared_repo.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }
final sharedRepo = SharedRepo();
  Singleton._internal();
}