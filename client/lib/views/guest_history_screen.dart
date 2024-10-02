import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/controllers/auth_controller.dart';
import 'package:new_journey_app/widgets/guest_drawer.dart';

import '../constants/font_manager.dart';
import '../constants/themes/app_colors.dart';
import '../constants/value_manager.dart';
import '../controllers/history_controller.dart';
import '../controllers/property_controller.dart';
import '../models/user_model.dart';
import '../widgets/custom_text.dart';
import '../widgets/history_card.dart';

class GuestHistoryScreen extends StatelessWidget {
  GuestHistoryScreen(
      {super.key, required this.user, required this.authController});

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
      drawer: GuestDrawer(controller: authController),
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
            color:
                isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary),
        title: Txt(
          text: "Requests History",
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
          } else if (historyController.guestAppliedProperties.isEmpty) {
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
                          text: "No request submitted!",
                          color: isDarkMode
                              ? DarkModeColors.whiteColor
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
              itemCount: historyController.guestAppliedProperties.length,
              itemBuilder: (context, index) {
                return HistoryCard(
                  property: historyController.guestAppliedProperties[index],
                  propertyController: propertyController,
                  isGuestRoutes: true,
                  historyController: historyController,
                );
              },
            );
          }
        },
      ),
    );
  }
}
