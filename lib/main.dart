import 'package:fittle_ai/bloc/navigation_bloc.dart';
import 'package:fittle_ai/screens/auth/auth_login_screen.dart';
import 'package:fittle_ai/screens/auth/auth_verify_screen.dart';
import 'package:fittle_ai/screens/bottom_navigation/bottom_navigation_screen.dart';
import 'package:fittle_ai/screens/food/food_insights_screen.dart';
import 'package:fittle_ai/screens/food/food_search_screen.dart';
import 'package:fittle_ai/screens/food/food_tracking_screen.dart';
import 'package:fittle_ai/screens/food/food_detail_screen.dart';
import 'package:fittle_ai/screens/profile/edit_profile.dart';
import 'package:fittle_ai/screens/profile_completion/profile_completion_secreen.dart';
import 'package:fittle_ai/screens/splash/splash_screen.dart';
import 'package:fittle_ai/resources/app_theme.dart';
import 'package:fittle_ai/Utils/screen_paths.dart';
import 'package:fittle_ai/screens/workout/workout_search_screen.dart';
import 'package:fittle_ai/screens/workout/workout_track_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/loader_bloc.dart';
import 'bloc/observer/bloc_observer.dart';
import 'screens/workout/workout_detail_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");

  Bloc.observer = AppBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (BuildContext context) => NavigationBloc(),
        ),
        BlocProvider<LoaderBloc>(
          create: (BuildContext context) => LoaderBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme().themeData,
      routes: {
        '/': (context) => const SplashScreen(),
        ScreenPaths.authLoginScreenPath.name: (context) =>
            const AuthLoginScreen(),
        ScreenPaths.authVerifyScreenPath.name: (context) =>
            const AuthVerifyScreen(),
        ScreenPaths.profileCompletionScreenPath.name: (context) =>
            const ProfileCompeletionScreen(),
        ScreenPaths.homeDashBoardPath.name: (context) =>
            const BottomNavigationScreen(),
        ScreenPaths.foodTrackScreenPath.name: (context) =>
            const FoodTrackingScreen(),
        ScreenPaths.foodSearchScreenPath.name: (context) =>
            const FoodSearchScreen(),
        ScreenPaths.foodDetailScreenPath.name: (context) =>
            const FoodDetailScreen(),
        ScreenPaths.foodInsightsScreenPath.name: (context) =>
            const FoodInsightsScreen(),
        ScreenPaths.workoutTrackScreenPath.name: (context) =>
            const WorkoutTrackingScreen(),
        ScreenPaths.workoutSearchScreenPath.name: (context) =>
            const WorkoutSearchScreen(),
        ScreenPaths.workoutDetailScreenPath.name: (context) =>
            const WorkoutDetailScreen(),
        ScreenPaths.editProfileScreenPath.name: (context) =>
            const EditProfileScreen()
      },
    );
  }
}
