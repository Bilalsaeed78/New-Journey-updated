import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:new_journey_app/controllers/property_controller.dart';

import '../constants/font_manager.dart';
import '../constants/themes/app_colors.dart';
import '../constants/value_manager.dart';
import '../widgets/custom_text.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({super.key, required this.propertyController});

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
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
            color:
                isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              propertyController.multiImageController.hasNoImages
                  ? propertyController.isImagePicked.value = false
                  : propertyController.isImagePicked.value = true;
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color:
                  isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary,
            )),
        title: Txt(
          text: "Add Images",
          color: isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: MarginManager.marginL,
        ),
        child: MultiImagePickerView(
          controller: propertyController.multiImageController,
          builder: (context, ImageFile imageFile) {
            return DefaultDraggableItemWidget(
              imageFile: imageFile,
              boxDecoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(RadiusManager.buttonRadius)),
              closeButtonAlignment: Alignment.topLeft,
              fit: BoxFit.cover,
              closeButtonIcon:
                  const Icon(Icons.delete_rounded, color: Colors.red),
              closeButtonBoxDecoration: null,
              showCloseButton: true,
              closeButtonMargin: const EdgeInsets.all(3),
              closeButtonPadding: const EdgeInsets.all(3),
            );
          },
          initialWidget: DefaultInitialWidget(
            centerWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  color: isDarkMode
                      ? DarkModeColors.whiteColor
                      : AppColors.secondary,
                ),
                Txt(
                  text: "Add Images",
                  color: isDarkMode
                      ? DarkModeColors.whiteColor
                      : AppColors.secondary,
                  fontWeight: FontWeightManager.medium,
                ),
              ],
            ),
            backgroundColor: isDarkMode
                ? DarkModeColors.cardBackgroundColor
                : AppColors.propertyContainer,
            margin: EdgeInsets.zero,
          ),
          addMoreButton: DefaultAddMoreWidget(
              icon: Icon(
                Icons.add,
                color: isDarkMode
                    ? DarkModeColors.whiteColor
                    : AppColors.secondary,
              ),
              backgroundColor: isDarkMode
                  ? DarkModeColors.cardBackgroundColor
                  : AppColors.propertyContainer),
        ),
      ),
    );
  }
}
