import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  // @override
  // void onChange(BlocBase bloc, Change change) {
  //   super.onChange(bloc, change);
  //   debugPrint('${bloc.runtimeType} $change');
  // }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint("/////////////////////  TRANSITION  ////////////////////////");
    debugPrint('${bloc.runtimeType} $transition');
    debugPrint("/////////////////////////////////////////////");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint("/////////////////////  ERROR  ////////////////////////");
    debugPrint('${bloc.runtimeType} $error \n$stackTrace');
    debugPrint("/////////////////////////////////////////////");
    super.onError(bloc, error, stackTrace);
  }
}
