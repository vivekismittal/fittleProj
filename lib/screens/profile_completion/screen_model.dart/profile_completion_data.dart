import 'package:fittle_ai/utils/constants.dart';
import 'package:fittle_ai/utils/extensions.dart';
import 'package:flutter/material.dart';

class ProfileCompletionData {
  static const int goalModelIndex = 0;
  static const int detailModelIndex = 1;
  static const int genderSelectionModelIndex = 2;
  static const int howOldModelIndex = 3;
  static const int weightRulerIndex = 4;
  static const int heightRulerIndex = 5;
  static const int activityModelIndex = 6;
  static const int workLifeCycleModelIndex = 7;

  final ProfilePageModel goalModelObj = GoalModel();
  final ProfilePageModel detailModelObj = DetailModel();
  final ProfilePageModel genderSelectionModelObj = GenderSelectionModel();
  final ProfilePageModel howOldModelObj = HowOldModel();
  final ProfilePageModel activityModelObj = ActivityModel();
  final ProfilePageModel weightRulerModelObj = WeightRulerModel();
  final ProfilePageModel heightRulerModelObj = HeightRulerModel();
  final ProfilePageModel workLifeCycleModelObj = WorkLifeCycleModel();

  List<ProfilePageModel> _profileList = [];

  List<ProfilePageModel> get profileModelList {
    if (_profileList.isEmpty) {
      _profileList = [...List.filled(8, EmptyProfilePage())];
      _profileList[goalModelIndex] = goalModelObj;
      _profileList[detailModelIndex] = detailModelObj;
      _profileList[genderSelectionModelIndex] = genderSelectionModelObj;
      _profileList[howOldModelIndex] = howOldModelObj;
      _profileList[weightRulerIndex] = weightRulerModelObj;
      _profileList[heightRulerIndex] = heightRulerModelObj;
      _profileList[activityModelIndex] = activityModelObj;
      _profileList[workLifeCycleModelIndex] = workLifeCycleModelObj;
    }
    return _profileList;
  }
}

abstract class ProfilePageModel {
  Map<String, dynamic> getData();
}

class EmptyProfilePage extends ProfilePageModel {
  @override
  Map<String, dynamic> getData() {
    return {};
  }
}

class GoalModel extends ProfilePageModel {
  static const goalOptions = Constant.allItemsDict;
  final Set<int> _selectedOptions = {};

  Set<int> get getSelectedOption {
    return _selectedOptions;
  }

  set addSelectedOption(int input) {
    if (input != 2) {
      _selectedOptions.removeWhere((element) => element != 2);
    }
    _selectedOptions.add(input);
  }

  set removeSelectedOption(int input) {
    _selectedOptions.remove(input);
  }

  @override
  getData() {
    List<String> goalsList = [];
    for (var element in _selectedOptions) {
      goalsList.add(goalOptions.keys.toList()[element].toLowerCase());
    }
    return {"profile_goal": goalsList};
  }

  bool get isProceed {
    return _selectedOptions.isNotEmpty;
  }
}

class DetailModel extends ProfilePageModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  getData() {
    Map<String, dynamic> data = {};
    data["full_name"] = nameController.text;
    data["email"] = emailController.text;
    return data;
  }

  bool get isProceed {
    return (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        emailController.text.isValidEmail());
  }
}

class GenderSelectionModel extends ProfilePageModel {
  Map<String, IconData> options = {
    "Male": Icons.male_outlined,
    "Female": Icons.female_outlined,
    "Other": Icons.more_horiz_outlined,
  };
  int _selectedOption = -1;

  int get getSelectedOption {
    return _selectedOption;
  }

  set selectedOption(int input) {
    _selectedOption = input;
  }

  @override
  getData() {
    Map<String, dynamic> data = {};
    if (_selectedOption > -1) {
      data["gender"] = options.keys.toList()[_selectedOption].toLowerCase();
    }
    return data;
  }

  bool get isProceed {
    return _selectedOption != -1;
  }
}

class HowOldModel extends ProfilePageModel {
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  int selectedYear = DateTime.now().year;
  static const List<String> totalMonths = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  getData() {
    var dob =
        "$selectedYear-${selectedMonth < 10 ? "0$selectedMonth" : selectedMonth}-${selectedDay < 10 ? "0$selectedDay" : selectedDay}";
    Map<String, dynamic> data = {};
    data["dob"] = dob;
    return data;
  }
}

class ActivityModel extends ProfilePageModel {
  static const List<String> activityLevelOption = [
    "Beginner",
    "Intermediate",
    "Advanced"
  ];
  int _selectedOption = -1;

  int get getSelectedOption {
    return _selectedOption;
  }

  set selectedOption(int input) {
    _selectedOption = input;
  }

  @override
  getData() {
    Map<String, dynamic> data = {};
    if (_selectedOption > -1) {
      data["workoutlevel"] = activityLevelOption[_selectedOption].toLowerCase();
    }
    return data;
  }

  bool get isProceed {
    return _selectedOption != -1;
  }
}

class WorkLifeCycleModel extends ProfilePageModel {
  static const Map<String, String> workLifeCycleOptions = {
    "Sedentary": "Little or no exercise",
    "Light": "Exercise 1-3 time/week",
    "Moderate": "Exercise 4-5 time/week",
    "Active": "Daily exercise or intense exercise 6-7 time",
  };
  int _selectedOption = -1;

  int get getSelectedOption {
    return _selectedOption;
  }

  set selectedOption(int input) {
    _selectedOption = input;
  }

  @override
  getData() {
    Map<String, dynamic> data = {};
    if (_selectedOption > -1) {
      data["working_lifestyle"] =
          workLifeCycleOptions.keys.toList()[_selectedOption].toLowerCase();
    }
    return data;
  }

  bool get isProceed {
    return _selectedOption != -1;
  }
}

class WeightRulerModel extends ProfilePageModel {
  double weight = 60;
  @override
  Map<String, dynamic> getData() {
    return {"weight": weight, "is_weight_in_lbs": false};
  }
}

class HeightRulerModel extends ProfilePageModel {
  double height = 5;
  @override
  Map<String, dynamic> getData() {
    return {"height": height, "is_height_in_feet": true};
  }
}
