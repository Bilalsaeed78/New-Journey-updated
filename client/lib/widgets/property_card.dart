import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/controllers/property_controller.dart';
import 'package:new_journey_app/models/property_model.dart';
import 'package:new_journey_app/views/property_details_screen.dart';

import '../constants/font_manager.dart';
import '../constants/themes/app_colors.dart';
import '../constants/value_manager.dart';
import 'custom_text.dart';

class PropertyCard extends StatefulWidget {
  const PropertyCard({
    super.key,
    required this.propertyController,
    required this.property,
    required this.isGuest,
    required this.isLocationFilterApplied,
  });

  final PropertyController propertyController;
  final Property property;
  final bool isGuest;
  final bool isLocationFilterApplied;

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  late Map<String, dynamic> propertyData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      if (widget.property.type == 'room') {
        var data = await widget.propertyController
            .getData('room', widget.property.propertyId);
        setState(() {
          propertyData = data['room'];
          isLoading = false;
        });
      } else if (widget.property.type == 'office') {
        var data = await widget.propertyController
            .getData('office', widget.property.propertyId);
        setState(() {
          propertyData = data['office'];
          isLoading = false;
        });
      } else {
        var data = await widget.propertyController
            .getData('apartment', widget.property.propertyId);
        setState(() {
          propertyData = data['apartment'];
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Get.to(PropertyDetailsScreem(
          propertyData: propertyData,
          type: widget.property.type,
          propertyController: widget.propertyController,
          propertyId: widget.property.id!,
          isGuest: widget.isGuest,
          isHistoryRoutes: false,
        ));
      },
      child: Container(
        height: Get.height * 0.39,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          vertical: MarginManager.marginM,
        ),
        decoration: BoxDecoration(
          color: isDarkMode
              ? DarkModeColors.cardBackgroundColor
              : AppColors.propertyContainer,
          borderRadius: BorderRadius.circular(
            RadiusManager.buttonRadius,
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: Image.network(
                          propertyData['images'][0],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      if (!widget.isGuest)
                        Positioned(
                          right: 5,
                          top: 5,
                          child: Chip(
                            side: BorderSide.none,
                            backgroundColor: isDarkMode
                                ? DarkModeColors.backgroundColor
                                : AppColors.background,
                            labelPadding: const EdgeInsets.all(0),
                            label: Txt(
                              text: widget.property.isOccupied
                                  ? "Occupied"
                                  : "Vacant",
                              color: isDarkMode
                                  ? DarkModeColors.whiteColor
                                  : AppColors.secondary,
                              useOverflow: true,
                              fontSize: FontSize.subTitleFontSize,
                            ),
                          ),
                        ),
                      if (widget.isLocationFilterApplied)
                        Positioned(
                          right: 5,
                          top: 5,
                          child: Chip(
                            side: BorderSide.none,
                            backgroundColor: isDarkMode
                                ? DarkModeColors.backgroundColor
                                : AppColors.background,
                            labelPadding: const EdgeInsets.all(0),
                            label: Txt(
                              text:
                                  "${widget.property.distance!.toStringAsFixed(2)} KMs away",
                              color: isDarkMode
                                  ? DarkModeColors.whiteColor
                                  : AppColors.secondary,
                              useOverflow: true,
                              fontSize: FontSize.subTitleFontSize,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: MarginManager.marginS,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.5,
                                    child: Txt(
                                      textAlign: TextAlign.start,
                                      text: widget.property.type == 'room'
                                          ? propertyData['room_number']
                                          : (widget.property.type == 'apartment'
                                              ? propertyData['apartment_number']
                                              : propertyData['office_address']),
                                      useOverflow: true,
                                      color: isDarkMode
                                          ? DarkModeColors.whiteColor
                                          : Colors.black,
                                      fontSize: FontSize.textFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.6,
                                    child: Txt(
                                      textAlign: TextAlign.start,
                                      useOverflow: true,
                                      text: propertyData['address'],
                                      color: isDarkMode
                                          ? DarkModeColors.whiteColor
                                          : Colors.black,
                                      fontSize: FontSize.subTitleFontSize,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Chip(
                              side: BorderSide.none,
                              backgroundColor: AppColors.primaryLight,
                              labelPadding: const EdgeInsets.all(0),
                              label: Txt(
                                text: widget.property.type.capitalizeFirst,
                                color: isDarkMode
                                    ? DarkModeColors.backgroundColor
                                    : AppColors.secondary,
                                useOverflow: true,
                                fontSize: FontSize.subTitleFontSize - 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: AppColors.primaryLight,
                                  child: Icon(
                                    Icons.group,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Txt(
                                  text: propertyData['max_capacity'] == 0
                                      ? "Capacity Full"
                                      : "${propertyData['max_capacity']} Persons",
                                  color: isDarkMode
                                      ? DarkModeColors.whiteColor
                                      : AppColors.secondary,
                                  fontSize: FontSize.subTitleFontSize,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: AppColors.primaryLight,
                                  child: Icon(
                                    Icons.attach_money,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Txt(
                                  text: "${propertyData['rental_price']} RS",
                                  color: isDarkMode
                                      ? DarkModeColors.whiteColor
                                      : AppColors.secondary,
                                  fontSize: FontSize.subTitleFontSize,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
