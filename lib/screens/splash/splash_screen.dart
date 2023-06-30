import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../bloc/navigation_bloc.dart';
import '../../screens/common/custom_screen.dart';
import '../../screens/splash/glowing_circle.dart';
import '../../utils/constants.dart';
import '../../utils/screen_paths.dart';




class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

   @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    Timer(
      const Duration(seconds: 2),
      () => context.read<NavigationBloc>().add(
            ScreenPushedAndRemoveUntilEvent(ScreenPaths.authLoginScreenPath.name,"",from: '/'),
          ),
    );

    return CustomScreen(
      scaffold: Scaffold(
          body: Center(
        child: GlowingCircle(
          child: SvgPicture.asset(
            Constant.splashSvg,
            width: deviceWidth,
            height: deviceHeight,
            fit: BoxFit.fill,
          ),
        ),
      )),
    );
  }

}
