import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/controllers/property_controller.dart';
import 'package:new_journey_app/controllers/request_controller.dart';

import '../constants/font_manager.dart';
import '../constants/themes/app_colors.dart';
import '../constants/value_manager.dart';
import '../widgets/custom_text.dart';
import '../widgets/request_tile.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen(
      {super.key,
      required this.requestController,
      required this.propertyId,
      required this.propertyController,
      required this.type});

  final RequestController requestController;
  final String propertyId;
  final PropertyController propertyController;
  final String type;

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      await widget.requestController.getPropertyRequests(widget.propertyId);
    } catch (e) {
      Get.snackbar(
        'Error',
        "Failed to load data.",
      );
    }
  }

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
        leading: IconButton(
          onPressed: () async {
            widget.propertyController.clearFields();
            widget.propertyController.clearLists();
            await widget.propertyController.loadData();
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Txt(
          text: "Renters Request",
          color: isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary,
        ),
      ),
      body: Obx(() {
        if (widget.requestController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        } else if (widget.requestController.myPropertyRequests.isEmpty) {
          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: SizeManager.sizeL),
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
                      text: "No request available.",
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
          );
        } else {
          return Container(
            margin: const EdgeInsets.symmetric(
                horizontal: MarginManager.marginM,
                vertical: MarginManager.marginS),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.requestController.myPropertyRequests.length,
              itemBuilder: (context, index) {
                var data = widget.requestController.myPropertyRequests[index];
                return RequestTile(
                  requestController: widget.requestController,
                  requestModel: data,
                  isHistoryRoute: false,
                  type: widget.type,
                );
              },
            ),
          );
        }
      }),
    );
  }
}
