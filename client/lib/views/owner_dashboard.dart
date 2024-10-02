import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/constants/themes/app_colors.dart';
import 'package:new_journey_app/controllers/property_controller.dart';
import 'package:new_journey_app/views/property_type_selector_screen.dart';

import '../constants/font_manager.dart';
import '../constants/value_manager.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../widgets/custom_text.dart';
import '../widgets/owner_drawer.dart';
import '../widgets/property_card.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final propertyController = Get.put(PropertyController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
      drawer: OwnerDrawer(
        controller: authController,
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor:
            isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
        actions: [
          CircleAvatar(
            radius: 34,
            backgroundImage: user.profilePic != null &&
                    user.profilePic!.isNotEmpty
                ? NetworkImage(user.profilePic!)
                : const NetworkImage(
                    'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
            backgroundColor: AppColors.card,
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: MarginManager.marginL,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Txt(
                  text: "Welcome, ",
                  fontSize: FontSize.titleFontSize,
                  color: isDarkMode
                      ? DarkModeColors.whiteColor
                      : AppColors.secondary,
                  fontWeight: FontWeightManager.medium,
                ),
                Txt(
                  text: "${user.fullname!.split(" ").first}.",
                  fontSize: FontSize.titleFontSize,
                  color: AppColors.primary,
                  fontWeight: FontWeightManager.bold,
                ),
              ],
            ),
            const SizedBox(height: SizeManager.sizeXS),
            SizedBox(
              width: double.infinity,
              child: Txt(
                textAlign: TextAlign.start,
                text: "Find all your added properties here",
                fontSize: FontSize.subTitleFontSize + 2,
                color: isDarkMode
                    ? DarkModeColors.whiteColor
                    : AppColors.secondary,
                fontWeight: FontWeightManager.medium,
              ),
            ),
            const SizedBox(height: SizeManager.sizeL),
            Obx(
              () {
                if (propertyController.isLoading.value) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                } else if (propertyController.myProperties.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: SizeManager.sizeL),
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
                                text: "No properties are added yet!",
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
                  return Obx(
                    () => Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: propertyController.myProperties.length,
                        itemBuilder: (context, index) {
                          return PropertyCard(
                            propertyController: propertyController,
                            property: propertyController.myProperties[index],
                            isGuest: false,
                            isLocationFilterApplied: false,
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: SizeManager.sizeXL),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Get.to(PropertyTypeSelectorScreen(
            propertyController: propertyController,
          ));
        },
        child: const Icon(
          Icons.add,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
