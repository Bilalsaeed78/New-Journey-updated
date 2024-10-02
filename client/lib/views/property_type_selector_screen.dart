import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/constants/themes/app_colors.dart';
import 'package:new_journey_app/controllers/property_controller.dart';
import 'package:new_journey_app/views/add_property_screen.dart';
import 'package:new_journey_app/widgets/custom_button.dart';

import '../constants/font_manager.dart';
import '../constants/value_manager.dart';
import '../widgets/custom_text.dart';

class PropertyTypeSelectorScreen extends StatelessWidget {
  const PropertyTypeSelectorScreen(
      {super.key, required this.propertyController});

  final PropertyController propertyController;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            propertyController.clearFields();
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary,
          ),
        ),
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
            color:
                isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(
              horizontal: MarginManager.marginL,
              vertical: MarginManager.marginM),
          child: ListView(
            children: [
              const SizedBox(
                height: SizeManager.sizeXXL * 0.8,
              ),
              Container(
                height: isDarkMode ? 150 : 200,
                width: 200,
                alignment: Alignment.center,
                child: Image.asset(
                  isDarkMode
                      ? 'assets/icons/logos_png/logo_dark.png'
                      : 'assets/icons/logos_png/logo.png',
                ),
              ),
              const SizedBox(
                height: SizeManager.sizeL,
              ),
              Txt(
                textAlign: TextAlign.center,
                text: "Property Type?",
                fontSize: FontSize.textFontSize,
                color: isDarkMode
                    ? DarkModeColors.whiteColor
                    : AppColors.secondary,
                fontWeight: FontWeightManager.bold,
              ),
              Txt(
                textAlign: TextAlign.center,
                text: "Please select your type to add property.",
                fontSize: FontSize.subTitleFontSize + 2,
                color: isDarkMode
                    ? DarkModeColors.whiteColor
                    : AppColors.secondary,
                fontWeight: FontWeightManager.medium,
              ),
              const SizedBox(
                height: SizeManager.sizeXL,
              ),
              CustomButton(
                color: AppColors.primary,
                textColor: AppColors.secondary,
                text: "Room",
                onPressed: () {
                  propertyController.clearFields();
                  Get.to(AddPropertyScreen(
                    propertyController: propertyController,
                    type: "room",
                    isEdit: false,
                  ));
                },
                hasInfiniteWidth: true,
              ),
              const SizedBox(
                height: SizeManager.sizeL,
              ),
              CustomButton(
                color: AppColors.primary,
                textColor: AppColors.secondary,
                text: "Office",
                onPressed: () {
                  propertyController.clearFields();
                  Get.to(AddPropertyScreen(
                    propertyController: propertyController,
                    type: "office",
                    isEdit: false,
                  ));
                },
                hasInfiniteWidth: true,
              ),
              const SizedBox(
                height: SizeManager.sizeL,
              ),
              CustomButton(
                color: AppColors.primary,
                textColor: AppColors.secondary,
                text: "Apartment",
                onPressed: () {
                  propertyController.clearFields();
                  Get.to(AddPropertyScreen(
                    propertyController: propertyController,
                    type: "apartment",
                    isEdit: false,
                  ));
                },
                hasInfiniteWidth: true,
              ),
              const SizedBox(
                height: SizeManager.sizeXL,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
