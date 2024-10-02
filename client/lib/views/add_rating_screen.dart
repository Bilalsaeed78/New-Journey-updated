import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/widgets/custom_text.dart';

import '../constants/themes/app_colors.dart';
import '../constants/value_manager.dart';
import '../controllers/rating_controller.dart';
import '../widgets/custom_button.dart';

class AddRatingScreen extends StatelessWidget {
  AddRatingScreen(
      {super.key,
      required this.propertyId,
      required this.guestId,
      required this.type});

  final ratingController = Get.put(RatingController());
  final String propertyId;
  final String guestId;
  final String type;

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
        title: Txt(
          text: "Add Ratings",
          color: isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: MarginManager.marginL,
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: RatingBar(
                initialRating: ratingController.rating.value,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: const Icon(Icons.star, color: AppColors.primary),
                  half: const Icon(Icons.star_half, color: AppColors.primary),
                  empty: const Icon(Icons.star_border_outlined,
                      color: AppColors.primary),
                ),
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  ratingController.updateRating(rating);
                },
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: ratingController.reviewController,
              autofocus: false,
              cursorColor: isDarkMode
                  ? DarkModeColors.whiteGreyColor
                  : AppColors.secondary,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: isDarkMode
                        ? DarkModeColors.whiteGreyColor
                        : AppColors.secondary,
                  )),
                  label: Txt(
                    text: "Review",
                    color: isDarkMode
                        ? DarkModeColors.whiteGreyColor
                        : AppColors.secondary,
                  ),
                  labelStyle: TextStyle(
                      fontSize: 16,
                      color: isDarkMode
                          ? DarkModeColors.whiteGreyColor
                          : AppColors.secondary),
                  floatingLabelStyle: TextStyle(
                      fontSize: 16,
                      color: isDarkMode
                          ? DarkModeColors.whiteGreyColor
                          : AppColors.secondary),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isDarkMode
                              ? DarkModeColors.whiteGreyColor
                              : AppColors.secondary)),
                  prefixIcon: const Icon(
                    Icons.reviews,
                    color: AppColors.primary,
                  ),
                  alignLabelWithHint: true),
              maxLines: 4,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 50),
            Obx(
              () => CustomButton(
                color: AppColors.primary,
                hasInfiniteWidth: true,
                loadingWidget: ratingController.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(
                          color: isDarkMode
                              ? DarkModeColors.backgroundColor
                              : AppColors.background,
                          backgroundColor: AppColors.primary,
                        ),
                      )
                    : null,
                onPressed: () async {
                  await ratingController.addRatings(propertyId, guestId, type);
                },
                text: "Add Ratings",
                textColor: isDarkMode
                    ? DarkModeColors.backgroundColor
                    : AppColors.background,
                buttonType: ButtonType.loading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
