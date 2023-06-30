import 'package:flutter/material.dart';

class Constant {
  ///svgs
  static const String splashSvg = "assets/svg/splash.svg";
  static const String whatsappSvg = "assets/svg/whatsApp.svg";

  static const String musclePng = "assets/png/muscle.png";
  static const String pilatesPng = "assets/png/pilates.png";
  static const String voltmeterPng = "assets/png/voltmeter.png";
  static const String yogaPng = "assets/png/yoga.png";
  static const String activityInsightPng = "assets/png/Activityinsight.png";
  static const String restaurantPng = "assets/png/Restaurant.png";
  static const String waterGlassPng = "assets/png/Group_water_glass.png";
  static const String dumbbellPng = "assets/png/Dumbbell.png";
  static const String carbsPng = "assets/png/carbs.png";
  static const String fatPng = "assets/png/fat.png";
  static const String proteinPng = "assets/png/protein.png";
  static const String fibrePng = "assets/png/fibre.png";
  static const String humanPng = "assets/png/human.png";
  static const String workoutTilePng = "assets/png/workout_tile.png";
  static const String foodDetailPlaceholderPng =
      "assets/png/food_detail_placeholder.png";
  static const String exerciseDetailPlaceholder =
      "assets/png/exercise_detail_placeholder.png";
  static const String homePng = "assets/png/home.png";
  static const String profilePng = "assets/png/profile.png";
  static const String planPng = "assets/png/plan.png";
  static const String insightSvg = "assets/svg/insight.svg";
  static const String dissapointedEmojiSvg = "assets/svg/disappointed-face.svg";
  static const String dissapointedEmojiPng = "assets/png/emoji-disappointed.png";


  ///lotties
  static const String loaderLottie = "assets/lotties/app-loader.json";
  static const String darkLoaderLottie = "assets/lotties/black_loader.json";

  ///Linear Gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xff6D63FF),
      Color(0xff3B32C0),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  //values
  static const int otpLength = 6;
  static const subTitleText =
      "Let’s take a minute to check if we have got\neverything right about you";

  static const allItemsDict = {
    "Weight Gain": musclePng,
    "Weight Loss": voltmeterPng,
    "Strength": pilatesPng,
    "Maintain Body": yogaPng,
  };

  static const quantities = [
    5,
    10,
    15,
    20,
    30,
    50,
    75,
    100,
    125,
    200,
    250,
    300,
    350,
    400,
    450,
    500,
    600,
    750,
    800,
    900,
    1000
  ];
}

enum Options { delete, move, copy, report }

// def calculate_age(dob):
//     today = date.today()
//     age = today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
//     return age