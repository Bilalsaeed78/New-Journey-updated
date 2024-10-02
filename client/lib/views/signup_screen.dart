import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/font_manager.dart';
import '../constants/value_manager.dart';
import '../constants/themes/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/packages/group_radio_buttons/src/radio_button_field.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  static const String routeName = '/signupScreen';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Form(
                key: controller.signupFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: isDarkMode ? 120 : 150,
                      width: 150,
                      alignment: Alignment.center,
                      child: Image.asset(
                        isDarkMode
                            ? 'assets/icons/logos_png/logo_dark.png'
                            : 'assets/icons/logos_png/logo.png',
                      ),
                    ),
                    SizedBox(
                      height: isDarkMode ? SizeManager.sizeXL : 0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Txt(
                        text: "Create your Account",
                        textAlign: TextAlign.center,
                        color: isDarkMode
                            ? DarkModeColors.whiteGreyColor
                            : AppColors.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.titleFontSize,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Txt(
                        text: "Sign up now to get started with an account",
                        textAlign: TextAlign.center,
                        color: isDarkMode
                            ? DarkModeColors.whiteGreyColor
                            : AppColors.subtitleColor,
                        fontWeight: FontWeight.normal,
                        fontSize: FontSize.subTitleFontSize,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    CustomTextFormField(
                      controller: controller.nameController,
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
                      controller: controller.emailController,
                      labelText: "Email",
                      autofocus: false,
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIconData: Icons.email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email cannot be empty.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    CustomTextFormField(
                      controller: controller.phoneController,
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
                      height: SizeManager.sizeSemiM,
                    ),
                    CustomTextFormField(
                      controller: controller.cnicController,
                      labelText: "CNIC",
                      hintText: "XXXXX-XXXXXXX-X",
                      textCapitalization: TextCapitalization.none,
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      prefixIconData: Icons.credit_card,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "CNIC cannot be empty.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    RadioButtonFormField(
                      labels: const ['Guest', 'Owner'],
                      icons: const [Icons.person, Icons.home],
                      onChange: (String label, int index) =>
                          controller.userTypeController.text = label,
                      onSelected: (String label) =>
                          controller.userTypeController.text = label,
                      decoration: InputDecoration(
                        labelText: 'User Type',
                        alignLabelWithHint: true,
                        contentPadding: const EdgeInsets.all(0.0),
                        labelStyle: TextStyle(
                          color: isDarkMode
                              ? DarkModeColors.whiteGreyColor
                              : AppColors.secondary,
                          fontSize: FontSize.textFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: TextStyle(
                          color: isDarkMode
                              ? DarkModeColors.whiteGreyColor
                              : Colors.grey,
                          fontSize: FontSize.textFontSize,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? DarkModeColors.whiteGreyColor
                                : AppColors.secondary,
                            width: 1,
                          ),
                          borderRadius:
                              BorderRadius.circular(RadiusManager.fieldRadius),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    Obx(
                      () => CustomTextFormField(
                        controller: controller.passwordController,
                        autofocus: false,
                        labelText: "Password",
                        obscureText: controller.isObscure.value,
                        prefixIconData: Icons.vpn_key_rounded,
                        textCapitalization: TextCapitalization.none,
                        suffixIconData: controller.isObscure.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        onSuffixTap: controller.toggleVisibility,
                        textInputAction: TextInputAction.done,
                        onFieldSubmit: (_) async {
                          await controller.signUpUser(
                            email: controller.emailController.text,
                            name: controller.nameController.text,
                            password: controller.passwordController.text,
                            phone: controller.phoneController.text,
                            cnic: controller.cnicController.text,
                            role: controller.userTypeController.text,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password cannot be empty.";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    Obx(
                      () => CustomButton(
                        color: AppColors.primary,
                        hasInfiniteWidth: true,
                        loadingWidget: controller.isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: isDarkMode
                                      ? DarkModeColors.backgroundColor
                                      : Colors.white,
                                  backgroundColor: AppColors.primary,
                                ),
                              )
                            : null,
                        onPressed: () async {
                          await controller.signUpUser(
                            email: controller.emailController.text,
                            name: controller.nameController.text,
                            password: controller.passwordController.text,
                            phone: controller.phoneController.text,
                            cnic: controller.cnicController.text,
                            role: controller.userTypeController.text,
                          );
                        },
                        text: "Register",
                        textColor: isDarkMode
                            ? DarkModeColors.backgroundColor
                            : AppColors.background,
                        buttonType: ButtonType.loading,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeL,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Txt(
                          text: "Already have an account? ",
                          fontSize: FontSize.subTitleFontSize,
                          color: isDarkMode
                              ? DarkModeColors.whiteGreyColor
                              : AppColors.subtitleColor,
                        ),
                        InkWell(
                          onTap: () {
                            controller.clearFields();
                            Get.offAll(const LoginScreen());
                          },
                          child: const Txt(
                            text: "Login",
                            fontSize: FontSize.subTitleFontSize,
                            color: AppColors.primary,
                            fontWeight: FontWeightManager.semibold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
