import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../constants/font_manager.dart';
import '../constants/themes/app_colors.dart';
import '../constants/value_manager.dart';
import '../controllers/rating_controller.dart';
import '../widgets/custom_text.dart';

class PropertyReviewsScreen extends StatefulWidget {
  const PropertyReviewsScreen({super.key, required this.propertyId});
  final String propertyId;

  @override
  State<PropertyReviewsScreen> createState() => _PropertyReviewsScreenState();
}

class _PropertyReviewsScreenState extends State<PropertyReviewsScreen> {
  final ratingController = Get.put(RatingController());
  bool isLoading = false;
  int _expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      await ratingController.getPropertyReviews(widget.propertyId);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor:
            isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
        iconTheme: IconThemeData(
            color:
                isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary),
        title: Txt(
          text: "Property Reviews",
          color: isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: MarginManager.marginL,
          vertical: MarginManager.marginM,
        ),
        child: Obx(
          () {
            if (ratingController.isLoading.value) {
              return SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              );
            } else if (ratingController.myPropertyReviews.isEmpty) {
              return SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
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
                            text: "No reviews available!",
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
                itemCount: ratingController.myPropertyReviews.length,
                itemBuilder: (context, index) {
                  final user = ratingController.reviewsUsers[index];
                  final review = ratingController.myPropertyReviews[index];
                  return ExpansionPanelList(
                    elevation: 1,
                    expansionCallback: (int panelIndex, bool isExpanded) {
                      setState(() {
                        _expandedIndex = _expandedIndex == index ? -1 : index;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        backgroundColor: isDarkMode
                            ? DarkModeColors.cardBackgroundColor
                            : AppColors.whiteShade,
                        body: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingBar(
                                initialRating: review.rating,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: const Icon(Icons.star,
                                      color: AppColors.primary),
                                  half: const Icon(Icons.star_half,
                                      color: AppColors.primary),
                                  empty: const Icon(Icons.star_border_outlined,
                                      color: AppColors.primary),
                                ),
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                onRatingUpdate: (_) {},
                                ignoreGestures: true,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Txt(
                                  text: review.comments,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Txt(
                              text: user.fullname,
                              useOverflow: true,
                              fontSize: FontSize.textFontSize + 2,
                              color: isDarkMode
                                  ? DarkModeColors.whiteColor
                                  : AppColors.secondary,
                              fontWeight: FontWeightManager.bold,
                            ),
                          );
                        },
                        isExpanded: _expandedIndex == index,
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
