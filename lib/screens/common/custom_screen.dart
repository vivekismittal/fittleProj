import 'package:fittle_ai/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CustomScreen extends StatelessWidget {
  const CustomScreen({super.key, required this.scaffold});

  final Widget scaffold;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationBloc, NavigationState>(
      listener: (context, navigationState) {
        print("//////Navigation listener//////");
        NavigatorState navigation = Navigator.of(context);
        switch (navigationState.runtimeType) {
          case PushedAndRemoveUntilState:
            {
              navigation.pushNamedAndRemoveUntil(
                (navigationState as PushedAndRemoveUntilState).routePath,
                (route) => false,
                arguments: navigationState.arguments,
              );
              break;
            }
          case PushedState:
            {
              navigation.pushNamed(
                (navigationState as PushedState).routePath,
                arguments: navigationState.arguments,
              );
              break;
            }
          case PopState:
            {
              print("pop");
              navigation.pop();
              break;
            }
          default:
            break;
        }
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: scaffold,
      ),
    );
  }
}
