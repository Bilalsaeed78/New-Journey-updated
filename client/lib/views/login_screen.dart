import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/views/signup_screen.dart';

import '../constants/font_manager.dart';
import '../constants/themes/app_colors.dart';
import '../constants/value_manager.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String routeName = '/loginScreen';

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor:
          isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: isDarkMode ? 220 : 300,
                      width: 300,
                      alignment: Alignment.center,
                      child: Image.asset(
                        isDarkMode
                            ? 'assets/icons/logos_png/full_dark.png'
                            : 'assets/icons/logos_png/full.png',
                      ),
                    ),
                    SizedBox(
                      height: isDarkMode ? SizeManager.sizeXL : 0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Txt(
                        text: "Welcome back, please enter your details",
                        textAlign: TextAlign.center,
                        color: isDarkMode
                            ? DarkModeColors.whiteGreyColor
                            : AppColors.subtitleColor,
                        fontWeight: FontWeight.normal,
                        fontSize: FontSize.subTitleFontSize + 2,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    CustomTextFormField(
                      controller: controller.emailController,
                      labelText: "Email",
                      autofocus: false,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
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
                          await controller.login(
                            controller.emailController.text,
                            controller.passwordController.text,
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
                      height: SizeManager.sizeM,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.bottomRight,
                        child: Txt(
                          text: "Forgot password?",
                          color: isDarkMode
                              ? DarkModeColors.whiteGreyColor
                              : AppColors.secondary,
                          fontSize: FontSize.subTitleFontSize,
                          fontWeight: FontWeightManager.medium,
                        ),
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
                          await controller.login(
                            controller.emailController.text,
                            controller.passwordController.text,
                          );
                        },
                        text: "Login",
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
                          text: "Don't have an account? ",
                          fontSize: FontSize.subTitleFontSize,
                          color: isDarkMode
                              ? DarkModeColors.whiteGreyColor
                              : AppColors.subtitleColor,
                        ),
                        InkWell(
                          onTap: () {
                            controller.clearFields();
                            Get.offAll(const SignupScreen());
                          },
                          child: const Txt(
                            text: "Sign Up",
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
