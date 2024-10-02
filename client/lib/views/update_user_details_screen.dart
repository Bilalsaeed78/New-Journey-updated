import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/controllers/profile_controller.dart';

import '../constants/font_manager.dart';
import '../constants/themes/app_colors.dart';
import '../constants/value_manager.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_form_field.dart';

class UpdateUserDetailsScreen extends StatefulWidget {
  const UpdateUserDetailsScreen({super.key, required this.profileController});

  final ProfileController profileController;

  @override
  State<UpdateUserDetailsScreen> createState() =>
      _UpdateUserDetailsScreenState();
}

class _UpdateUserDetailsScreenState extends State<UpdateUserDetailsScreen> {
  @override
  void initState() {
    super.initState();
    widget.profileController.nameController.text =
        widget.profileController.user.value.fullname!;
    widget.profileController.phoneController.text =
        widget.profileController.user.value.contactNo!;
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
        title: Txt(
          text: "Update Profile Details",
          color: isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary,
          fontSize: FontSize.textFontSize,
          fontWeight: FontWeightManager.medium,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        child: Form(
          key: widget.profileController.editProfileFormKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: widget.profileController.nameController,
                labelText: "Full Name",
                autofocus: false,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                prefixIconData: Icons.person,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Name cannot be empty.";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: SizeManager.sizeSemiM,
              ),
              CustomTextFormField(
                controller: widget.profileController.phoneController,
                labelText: "Contact Number",
                autofocus: false,
                hintText: "033X-XXXXXXX",
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                prefixIconData: Icons.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Phone cannot be empty.";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: SizeManager.sizeM,
              ),
              Obx(
                () => CustomButton(
                  color: AppColors.primary,
                  hasInfiniteWidth: true,
                  loadingWidget: widget.profileController.isLoading.value
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
                    FocusScope.of(context).unfocus();
                    await widget.profileController.updateProfile();
                  },
                  text: "Submit",
                  textColor: isDarkMode
                      ? DarkModeColors.backgroundColor
                      : AppColors.background,
                  buttonType: ButtonType.loading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
