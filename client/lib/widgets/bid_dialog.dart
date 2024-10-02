import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/controllers/request_controller.dart';
import 'package:new_journey_app/widgets/custom_text_form_field.dart';

import '../constants/font_manager.dart';
import '../constants/themes/app_colors.dart';
import 'custom_text.dart';

class BidDialog extends StatelessWidget {
  const BidDialog({
    Key? key,
    required this.requestController,
    required this.basePrice,
  }) : super(key: key);

  final RequestController requestController;
  final int basePrice;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Form(
      key: requestController.bidFormKey,
      child: AlertDialog(
        backgroundColor:
            isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
        title: Txt(
          text: "Enter Bid Price",
          color: isDarkMode ? DarkModeColors.whiteColor : Colors.black,
          fontSize: FontSize.textFontSize,
          fontWeight: FontWeight.bold,
        ),
        content: CustomTextFormField(
          controller: requestController.bidController,
          labelText: "Bid Price",
          autofocus: false,
          keyboardType: TextInputType.number,
          prefixIconData: Icons.monetization_on,
          validator: (value) {
            if (value!.isEmpty) {
              return "Bid price cannot be empty.";
            }
            int bidPrice = int.tryParse(value)!;
            int minBid = (basePrice * 0.8).floor();
            if (bidPrice < minBid) {
              return "Bid price must be more or equal to $minBid Rs.";
            }
            return null;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: null);
            },
            child: Txt(
              text: "Cancel",
              color: isDarkMode ? DarkModeColors.whiteColor : Colors.black,
              fontSize: FontSize.subTitleFontSize,
              fontWeight: FontWeight.normal,
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.primary),
            ),
            onPressed: () {
              if (requestController.bidFormKey.currentState!.validate()) {
                int val = int.parse(requestController.bidController.text);
                Get.back(result: val);
              }
            },
            child: const Txt(
              text: "Submit",
              color: Colors.black,
              fontSize: FontSize.subTitleFontSize,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
