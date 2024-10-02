import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/controllers/auth_controller.dart';
import 'package:new_journey_app/controllers/history_controller.dart';
import 'package:new_journey_app/controllers/property_controller.dart';
import 'package:new_journey_app/widgets/owner_drawer.dart';

import '../constants/font_manager.dart';
import '../constants/themes/app_colors.dart';
import '../constants/value_manager.dart';
import '../models/user_model.dart';
import '../widgets/custom_text.dart';
import '../widgets/history_card.dart';

class OwnerHistoryScreen extends StatelessWidget {
  OwnerHistoryScreen({
    super.key,
    required this.user,
    required this.authController,
  });

  final User user;
  final AuthController authController;

  final historyController = Get.put(HistoryController());

  final propertyController = Get.put(PropertyController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
      drawer: OwnerDrawer(controller: authController),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color:
                isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary),
        backgroundColor:
            isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Txt(
          text: "Renting History",
          color: isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary,
        ),
      ),
      body: Obx(
        () {
          if (historyController.isLoading.value) {
            return SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            );
          } else if (historyController.myProperties.isEmpty) {
            return SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: SizeManager.sizeL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/no_data.svg",
                        height: 200,
                        width: 200,
                        fit: BoxFit.scaleDown,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Txt(
                          text: "No requests available!",
                          color: isDarkMode
                              ? DarkModeColors.whiteGreyColor
                              : AppColors.secondary,
                          fontSize: FontSize.subTitleFontSize,
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: historyController.myProperties.length,
              itemBuilder: (context, index) {
                return HistoryCard(
                  property: historyController.myProperties[index],
                  propertyController: propertyController,
                  isGuestRoutes: false,
                );
              },
            );
          }
        },
      ),
    );
  }
}
