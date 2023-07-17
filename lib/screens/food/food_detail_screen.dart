import 'package:fittle_ai/Utils/constants.dart';
import 'package:fittle_ai/model/food_detail_model.dart';
import 'package:fittle_ai/model/food_tracking_model.dart';
import 'package:fittle_ai/resources/app_color.dart';
import 'package:fittle_ai/resources/components/app_loader.dart';
import 'package:fittle_ai/resources/components/internet_connectivity_check.dart';
import 'package:fittle_ai/resources/components/texts/custom_text.dart';
import 'package:fittle_ai/screens/common/custom_loader_screen.dart';
import 'package:fittle_ai/screens/dasboard/widget/nutrients_value.dart';
import 'package:fittle_ai/screens/dasboard/widget/picker_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/food_track_bloc.dart';
import '../../resources/components/toast.dart';
import '../../utils/screen_paths.dart';

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String foodId =
        (ModalRoute.of(context)!.settings.arguments as List)[0];
    final String categoryType =
        (ModalRoute.of(context)!.settings.arguments as List)[1];

    return CustomScreenWithLoader(
      withGradient: false,
      body: BlocProvider(
        create: (context) => FoodTrackBloc(),
        child: FoodDetailBody(
          categoryType: categoryType,
          foodId: foodId,
        ),
      ),
      id: ScreenPaths.foodDetailScreenPath.name,
    );
  }
}

class FoodDetailBody extends StatelessWidget {
  const FoodDetailBody({
    super.key,
    required this.foodId,
    required this.categoryType,
  });
  final String categoryType;
  final String foodId;

  @override
  Widget build(BuildContext context) {
    FoodPageData foodData;
    return InternetConnectivityChecked(
      onTryAgain: () {
        context.read<FoodTrackBloc>().add(FoodDetailFetchedEvent(foodId));
      },
      child:
          BlocBuilder<FoodTrackBloc, FoodTrackState>(builder: (context, state) {
        if (state is! FoodDetailFetchedState) {
          if (state is FoodDetailErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Toast.show(context, state.message);
            });
            return Center(
              child: IconButton(
                icon: const Icon(Icons.replay_outlined),
                onPressed: () {
                  context
                      .read<FoodTrackBloc>()
                      .add(FoodDetailFetchedEvent(foodId));
                },
              ),
            );
          }

          return Center(child: darkAppLoader());
        }
        foodData = state.foodDetail.foodPageData ?? FoodPageData();
        return Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    foodData.foodImage ?? "",
                    fit: BoxFit.fitWidth,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        Constant.foodDetailPlaceholderPng,
                        fit: BoxFit.fitWidth,
                      );
                    },
                  ),
                ),
                StatefulBuilder(builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 22),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    foodData.foodName ?? "",
                                    style: p14_500BlackTextStyle,
                                    overflow: TextOverflow.clip,
                                    maxLines: 2,
                                  ),
                                  Text(
                                    "Nutritions Value",
                                    style: p10_400LBlackTextStyle,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${foodData.foodWeight} g",
                                    style: p14_500BlackTextStyle,
                                  ),
                                  Text(
                                    "${(foodData.foodCalorie ?? 0).round()} kcal",
                                    style: p10_400LBlackTextStyle,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 48),
                        SizedBox(
                          height: 200,
                          child: PickFromList(
                            title: "Select the Quantity (in gm)",
                            incomingQuantity: foodData.foodWeight ?? 100,
                            onSelect: (selectedQuantity) {
                              updateValues(foodData, selectedQuantity);
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: 56),
                        Text(
                          "Nutrients Breakdown",
                          style: p14_500BlackTextStyle,
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            NutrientsValue(
                              title: "Protein",
                              asset: Constant.proteinPng,
                              value: foodData.foodProtein ?? 0,
                            ),
                            NutrientsValue(
                              title: "Carbs",
                              asset: Constant.carbsPng,
                              value: foodData.foodCarbs ?? 0,
                            ),
                            NutrientsValue(
                              title: "Fat",
                              asset: Constant.fatPng,
                              value: foodData.foodFats ?? 0,
                            ),
                            NutrientsValue(
                              title: "Fibre",
                              asset: Constant.fibrePng,
                              value: foodData.foodFibre ?? 0,
                            ),
                          ],
                        ),
                        // const Spacer(),
                      ],
                    ),
                  );
                }),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 48,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColor.whiteColor,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  var data = UserFoodDatum(
                    foodId: foodData.foodId,
                    foodCalorie: foodData.foodCalorie,
                    foodCarbs: foodData.foodCarbs,
                    foodFat: foodData.foodFats,
                    foodFibre: foodData.foodFibre,
                    foodCategoryType: categoryType.toLowerCase(),
                    foodName: foodData.foodName,
                    foodProtein: foodData.foodProtein,
                    foodQuantity: foodData.foodWeight,
                  );
                  Navigator.pop(context, data);
                },
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    gradient: Constant.backgroundGradient,
                  ),
                  child: Center(
                    child: Text(
                      "Add to $categoryType",
                      style: p12_500WhiteTextStyle,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  void updateValues(FoodPageData foodData, int selectedQuantity) {
    foodData.foodCalorie = ((foodData.foodCalorie ?? 0) * selectedQuantity) /
        (foodData.foodWeight ?? 0);
    foodData.foodProtein = ((foodData.foodProtein ?? 0) * selectedQuantity) /
        (foodData.foodWeight ?? 0);
    foodData.foodFats = ((foodData.foodFats ?? 0) * selectedQuantity) /
        (foodData.foodWeight ?? 0);
    foodData.foodFibre = ((foodData.foodFibre ?? 0) * selectedQuantity) /
        (foodData.foodWeight ?? 0);
    foodData.foodCarbs = ((foodData.foodCarbs ?? 0) * selectedQuantity) /
        (foodData.foodWeight ?? 0);
    foodData.foodWeight = selectedQuantity;
  }
}
