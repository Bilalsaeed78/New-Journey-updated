import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/constants/themes/app_colors.dart';
import 'package:new_journey_app/controllers/auth_controller.dart';
import 'package:new_journey_app/controllers/profile_controller.dart';
import 'package:new_journey_app/extensions/string_extensions.dart';
import 'package:new_journey_app/widgets/custom_text.dart';
import 'package:new_journey_app/widgets/guest_drawer.dart';

import '../models/user_model.dart';
import '../widgets/owner_drawer.dart';
import 'update_user_details_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen(
      {super.key,
      required this.user,
      required this.authController,
      required this.isOwner});

  final User user;
  final AuthController authController;
  final bool isOwner;

  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
      drawer: isOwner
          ? OwnerDrawer(
              controller: authController,
            )
          : GuestDrawer(
              controller: authController,
            ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor:
            isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
        title: const Txt(text: 'Profile'),
        centerTitle: true,
      ),
      body: Obx(
        () => profileController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: isDarkMode
                      ? DarkModeColors.backgroundColor
                      : AppColors.background,
                  backgroundColor: AppColors.primary,
                ),
              )
            : Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Get.height * 0.06,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Obx(
                            () => CircleAvatar(
                              radius: 80,
                              backgroundImage: profileController.profilePhoto !=
                                      null
                                  ? Image.file(profileController.profilePhoto!)
                                      .image
                                  : (profileController.user.value.profilePic !=
                                              null &&
                                          profileController.user.value
                                              .profilePic!.isNotEmpty)
                                      ? NetworkImage(profileController
                                          .user.value.profilePic!)
                                      : const NetworkImage(
                                          'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                              backgroundColor: AppColors.card,
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () =>
                                    profileController.pickProfile(),
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  color: AppColors.secondary,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Obx(
                      () => Txt(
                        textAlign: TextAlign.center,
                        text: profileController
                            .user.value.fullname!.capitalizeFirstOfEach,
                        color: isDarkMode
                            ? DarkModeColors.whiteColor
                            : AppColors.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Txt(
                      textAlign: TextAlign.center,
                      text: profileController.user.value.email,
                      color: isDarkMode
                          ? DarkModeColors.whiteColor
                          : AppColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Divider(
                      height: 2,
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    ListTile(
                      onTap: () {
                        Get.to(UpdateUserDetailsScreen(
                          profileController: profileController,
                        ));
                      },
                      tileColor: AppColors.primaryLight
                          .withOpacity(isDarkMode ? 0.5 : 0.3),
                      leading: Icon(
                        Icons.person,
                        color: isDarkMode
                            ? DarkModeColors.whiteColor
                            : AppColors.secondary,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: isDarkMode
                            ? DarkModeColors.whiteColor
                            : AppColors.secondary,
                        size: 16,
                      ),
                      title: Txt(
                        textAlign: TextAlign.start,
                        text: 'Update User Details',
                        color: isDarkMode
                            ? DarkModeColors.whiteColor
                            : AppColors.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    // const SizedBox(
                    //   height: 14,
                    // ),
                    // ListTile(
                    //   onTap: () {},
                    //   tileColor: AppColors.primaryLight
                    //       .withOpacity(isDarkMode ? 0.5 : 0.3),
                    //   leading: Icon(
                    //     Icons.lock,
                    //     color: isDarkMode
                    //         ? DarkModeColors.whiteColor
                    //         : AppColors.secondary,
                    //   ),
                    //   trailing: Icon(
                    //     Icons.arrow_forward_ios_outlined,
                    //     color: isDarkMode
                    //         ? DarkModeColors.whiteColor
                    //         : AppColors.secondary,
                    //     size: 16,
                    //   ),
                    //   title: Txt(
                    //     textAlign: TextAlign.start,
                    //     text: 'Change Password',
                    //     color: isDarkMode
                    //         ? DarkModeColors.whiteColor
                    //         : AppColors.secondary,
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.normal,
                    //   ),
                    // ),
                    const Spacer(),
                    Txt(
                      textAlign: TextAlign.start,
                      text: 'Powered By New Journey ©',
                      color: isDarkMode
                          ? DarkModeColors.whiteColor
                          : AppColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
