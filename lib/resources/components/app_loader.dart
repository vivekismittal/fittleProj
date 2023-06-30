import 'package:fittle_ai/Utils/constants.dart';
import 'package:lottie/lottie.dart';

LottieBuilder appLoader({double? width, double? height}) => LottieBuilder.asset(
      Constant.loaderLottie,
      height: height,
      width: width,
    );

LottieBuilder darkAppLoader({double? width, double? height}) =>
    LottieBuilder.asset(
      Constant.darkLoaderLottie,
      height: height,
      width: width,
    );
