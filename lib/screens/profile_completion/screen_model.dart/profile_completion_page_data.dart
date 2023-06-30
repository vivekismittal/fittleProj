import 'package:fittle_ai/screens/profile_completion/pages/activity_level.dart';
import 'package:fittle_ai/screens/profile_completion/pages/height_ruler.dart';
import 'package:fittle_ai/screens/profile_completion/pages/how_old.dart';
import 'package:fittle_ai/screens/profile_completion/pages/wieght_ruler.dart';
import 'package:fittle_ai/screens/profile_completion/pages/your_detail.dart';
import 'package:fittle_ai/screens/profile_completion/pages/your_goal_options.dart';
import 'package:fittle_ai/screens/profile_completion/screen_model.dart/profile_completion_data.dart';
import 'package:flutter/material.dart';

import '../pages/gender_selection.dart';
import '../pages/work_life_cycle.dart';

class ProfileCompletionPageData {
  final String title;
  final String subTitle;
  final Widget child;

  ProfileCompletionPageData({
    this.title = "",
    this.subTitle = "",
    required this.child,
  });
}

List<ProfileCompletionPageData> listOfCompleteProfilePages(
    ProfileCompletionData profileCompletionData) {
  List<ProfileCompletionPageData> pages = [];

  ///1
  pages.add(
    ProfileCompletionPageData(
      title: "Set Your Goal",
      subTitle:
          "Let’s take a minute to check if we have got everything right about you",
      child: SelectableGoalGridTiles(
        goalModel: (profileCompletionData.goalModelObj as GoalModel),
      ),
    ),
  );

  ///2
  pages.add(
    ProfileCompletionPageData(
      title: "Fill Your Profile",
      subTitle:
          "Let’s take a minute to check if we have got everything right about you",
      child: YourDetailFields(
        yourDetailModel: (profileCompletionData.detailModelObj as DetailModel),
      ),
    ),
  );

  ///3
  pages.add(
    ProfileCompletionPageData(
      title: "Tell Us About Yourself",
      subTitle:
          "To give you a better experience and result we need to know your gender",
      child: GenderSelection(
        genderSelectionModel: (profileCompletionData.genderSelectionModelObj
            as GenderSelectionModel),
      ),
    ),
  );

  ///4
  pages.add(
    ProfileCompletionPageData(
      title: "How Old Are You?",
      subTitle:
          "Age in years. This will help us to personalize an exercise program plan that suits you.",
      child: SlidingCalender(
        howOldModel: (profileCompletionData.howOldModelObj as HowOldModel),
      ),
    ),
  );

  ///5
  pages.add(
    ProfileCompletionPageData(
      title: "What Is your Weight?",
      subTitle:
          "This is used to set up recommendations just for you. You can always change it later.",
      child: WeightRulerPage(
          weightRulerModel:
              profileCompletionData.weightRulerModelObj as WeightRulerModel),
    ),
  );

  ///6
  pages.add(
    ProfileCompletionPageData(
      title: "What is Your Height?",
      subTitle:
          "This is used to set up recommendations just for you. You can always change it later.",
      child: HeightRulerPage(
          heightRulerModel:
              profileCompletionData.heightRulerModelObj as HeightRulerModel),
    ),
  );

  ///7
  pages.add(
    ProfileCompletionPageData(
      title: "Physical Activity Level?",
      subTitle:
          "Choose your regular activity levsel. This will help us to personalize plans for you.",
      child: ActivityLevel(
        activityModel:
            (profileCompletionData.activityModelObj as ActivityModel),
      ),
    ),
  );

  //8
  pages.add(
    ProfileCompletionPageData(
      title: "Choose Work Life Style?",
      subTitle:
          "Choose your regular activity levsel. This will help us to personalize plans for you.",
      child: WorkLifeCycle(
        workLifeCycleModel:
            (profileCompletionData.workLifeCycleModelObj as WorkLifeCycleModel),
      ),
    ),
  );

  return pages;
}
