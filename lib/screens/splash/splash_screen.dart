import 'dart:async';

import 'package:fittle_ai/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../screens/splash/glowing_circle.dart';
import '../../utils/constants.dart';
import '../../utils/screen_paths.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    Timer(const Duration(seconds: 2), () async {
      var _sharedRepo = Singleton().sharedRepo;
      String? userId = await _sharedRepo.readUserId();
      String? profileId = await _sharedRepo.readProfileId();
      var routePath = ScreenPaths.authLoginScreenPath.name;
      bool? isComplete = await _sharedRepo.readProfileCompletionStatus();
      if (userId != null) {
        routePath = ScreenPaths.profileCompletionScreenPath.name;
        if (profileId != null && isComplete != null && isComplete) {
          routePath = ScreenPaths.homeDashBoardPath.name;
        }
      }
      Navigator.pushNamedAndRemoveUntil(context, routePath, (route) => false);
    });

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
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
