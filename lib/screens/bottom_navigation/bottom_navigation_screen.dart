import 'package:fittle_ai/Utils/constants.dart';
import 'package:fittle_ai/bloc/profile_bloc.dart';
import 'package:fittle_ai/resources/app_color.dart';
import 'package:fittle_ai/resources/components/texts/custom_text.dart';
import 'package:fittle_ai/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home_dashboard_bloc.dart';
import '../../utils/screen_paths.dart';
import '../common/custom_loader_screen.dart';
import '../dasboard/home_dashboard_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int selectedTabIndex = 0;
  Widget getTabsBodyWidget(int index) {
    switch (index) {
      case 0:
        {
          return BlocProvider(
            create: (context) => HomeDashboardBloc(),
            child: const HomeDasboardBody(),
          );
        }
      case 2:
        return BlocProvider(
          create: (context) => ProfileBloc(),
          child: ProfileBody(
            onUpgradeClick: () {
              setState(() {
                selectedTabIndex = 1;
              });
            },
          ),
        );
      default:
        return const Center(
          child: Text("Coming Soon....."),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreenWithLoader(
      withGradient: false,
      body: getTabsBodyWidget(selectedTabIndex),
      id: ScreenPaths.homeDashBoardPath.name,
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: selectedTabIndex,
          items: [
            bottomNavigationBarItem(
                "Home", Constant.homePng, selectedTabIndex == 0),
            bottomNavigationBarItem(
                "Plan", Constant.planPng, selectedTabIndex == 1),
            bottomNavigationBarItem(
                "Profile", Constant.profilePng, selectedTabIndex == 2),
          ],
          onTap: (value) {
            if (value != selectedTabIndex) {
              setState(() {
                selectedTabIndex = value;
              });
            }
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem bottomNavigationBarItem(
    String label,
    String iconAsset,
    bool isSelected,
  ) {
    return BottomNavigationBarItem(
      label: "",
      icon: Container(
        height: 36,
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: (isSelected ? AppColor.progressBarColor : AppColor.d6d6d6Color)
              .withOpacity(.15),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  isSelected ? AppColor.progressBarColor : AppColor.d6d6d6Color,
              radius: 18,
              child: Image.asset(
                iconAsset,
                color:
                    isSelected ? AppColor.whiteColor : AppColor.offBlackColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style:
                  isSelected ? p10_400BlackTextStyle : p10_400OffBlackTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
