import 'package:flutter_bloc/flutter_bloc.dart';

/// Loading States
abstract class LoaderState {}
class InitialState extends LoaderState{}
class LoadingDisabled extends LoaderState {
  final String id;

  LoadingDisabled(this.id);
}

class LoadingEnabled extends LoaderState {
  final String id;

  LoadingEnabled(this.id);
}

/// Loading Events

abstract class LoaderEvent {
  final String id;

  LoaderEvent(this.id);
}

class EnabledLoadingEvent extends LoaderEvent {
  EnabledLoadingEvent(super.id);
}

class DisabledLoadingEvent extends LoaderEvent {
  DisabledLoadingEvent(super.id);
}

///Loading Bloc
class LoaderBloc extends Bloc<LoaderEvent, LoaderState> {
  LoaderBloc() : super(InitialState()) {
    on<EnabledLoadingEvent>(
      (event, emit) => emit(LoadingEnabled(event.id)),
    );
    on<DisabledLoadingEvent>(
      (event, emit) => emit(LoadingDisabled(event.id)),
    );
  }
}
