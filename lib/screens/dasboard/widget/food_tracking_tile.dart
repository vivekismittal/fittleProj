import 'package:fittle_ai/screens/dasboard/widget/picker_button.dart';
import 'package:flutter/material.dart';

import '../../../model/food_tracking_model.dart';
import '../../../resources/resources.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions.dart';
import 'nutrients_value.dart';

class FoodTrackingTile extends StatefulWidget {
  const FoodTrackingTile({
    super.key,
    required this.foodTileData,
    required this.onQuantityChange,
    required this.onPopUpButtonClicked,
  });
  final UserFoodDatum foodTileData;
  final void Function(UserFoodDatum) onQuantityChange;
  final void Function(int) onPopUpButtonClicked;

  @override
  State<FoodTrackingTile> createState() => _FoodTrackingTileState();
}

class _FoodTrackingTileState extends State<FoodTrackingTile> {
  late UserFoodDatum foodTileData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodTileData = widget.foodTileData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.whiteColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "${foodTileData.foodName?.capitalize()}\n",
                  style: p12_400BlackTextStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PickerButton(
                      selectedQuantity: foodTileData.foodQuantity ?? 100,
                      title: "Pick the Quantity (in gm)",
                      onSave: (selectedQuantity) {
                        updateValues(foodTileData, selectedQuantity);
                        foodTileData.foodQuantity = selectedQuantity;
                        widget.onQuantityChange(foodTileData);
                        setState(() {});
                      },
                    ),
                    Expanded(
                      child: PopupMenuButton(
                        child: const Icon(
                          Icons.more_vert_outlined,
                          color: AppColor.lightBlackColor,
                        ),
                        onOpened: () {},
                        onSelected: (value) {
                          widget.onPopUpButtonClicked(value);
                        },
                        itemBuilder: (ctx) => [
                          _buildPopupMenuItem('Delete', FoodTrackingOptions.delete.index),
                          _buildPopupMenuItem('Move to', FoodTrackingOptions.move.index),
                          _buildPopupMenuItem('Copy to', FoodTrackingOptions.copy.index),
                          _buildPopupMenuItem(
                              'Report Issue', FoodTrackingOptions.report.index),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            "${foodTileData.foodCalorie?.toStringAsFixed(0)} KCal",
            style: p8_400LBlackTextStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NutrientsValue(
                  title: "Protein",
                  asset: Constant.proteinPng,
                  value: foodTileData.foodProtein ?? 0),
              NutrientsValue(
                  title: "Carbs",
                  asset: Constant.carbsPng,
                  value: foodTileData.foodCarbs ?? 0),
              NutrientsValue(
                  title: "Fat",
                  asset: Constant.fatPng,
                  value: foodTileData.foodFat ?? 0),
              NutrientsValue(
                  title: "Fibre",
                  asset: Constant.fibrePng,
                  value: foodTileData.foodFibre ?? 0),
            ],
          )
        ],
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title, int index) {
    return PopupMenuItem(
      value: index,
      child: Text(
        title,
        style: p12_400BlackTextStyle,
      ),
    );
  }

  void updateValues(UserFoodDatum foodData, int selectedQuantity) {
    foodData.foodCalorie = ((foodData.foodCalorie ?? 0) * selectedQuantity) /
        (foodData.foodQuantity ?? 0);
    foodData.foodProtein = ((foodData.foodProtein ?? 0) * selectedQuantity) /
        (foodData.foodQuantity ?? 0);

    foodData.foodFat = ((foodData.foodFat ?? 0) * selectedQuantity) /
        (foodData.foodQuantity ?? 0);
    foodData.foodFibre = ((foodData.foodFibre ?? 0) * selectedQuantity) /
        (foodData.foodQuantity ?? 0);
    foodData.foodCarbs = ((foodData.foodCarbs ?? 0) * selectedQuantity) /
        (foodData.foodQuantity ?? 0);
    foodData.foodQuantity = selectedQuantity;
  }
}
