import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/views/owner_history_screen.dart';

import '../constants/font_manager.dart';
import '../constants/themes/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../views/owner_dashboard.dart';
import '../views/profile_screen.dart';
import 'custom_text.dart';
import 'theme_mode_switch.dart';

class OwnerDrawer extends StatefulWidget {
  const OwnerDrawer({
    super.key,
    required this.controller,
  });

  final AuthController controller;

  @override
  State<OwnerDrawer> createState() => _OwnerDrawerState();
}

class _OwnerDrawerState extends State<OwnerDrawer> {
  bool isLoading = true;
  late User user;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    user = (await widget.controller
        .getCurrentUserInfo(widget.controller.getUserId()!))!;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      backgroundColor:
          isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: isDarkMode
                    ? DarkModeColors.backgroundColor
                    : AppColors.background,
                backgroundColor: AppColors.primary,
              ),
            )
          : SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: user.profilePic != null &&
                            user.profilePic!.isNotEmpty
                        ? NetworkImage(user.profilePic!)
                        : const NetworkImage(
                            'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                    backgroundColor: AppColors.card,
                  ),
                  const SizedBox(height: 10),
                  Txt(
                    text: user.fullname,
                    color: isDarkMode
                        ? DarkModeColors.whiteGreyColor
                        : AppColors.secondary,
                    fontSize: FontSize.titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  buildDrawerTile(context, "Profile", Icons.person, () {
                    Get.offAll(ProfileScreen(
                      user: user,
                      authController: widget.controller,
                      isOwner: true,
                    ));
                  }),
                  buildDrawerTile(context, "Dashboard", Icons.home, () {
                    Get.offAll(OwnerDashboard(
                      user: user,
                    ));
                  }),
                  buildDrawerTile(context, "History", Icons.history, () {
                    Get.offAll(OwnerHistoryScreen(
                      user: user,
                      authController: widget.controller,
                    ));
                  }),
                  buildDrawerTile(context, "Logout", Icons.logout, () {
                    Get.dialog(
                      AlertDialog(
                        backgroundColor: isDarkMode
                            ? DarkModeColors.containerColor
                            : AppColors.background,
                        title: Txt(
                          text: "Confirm Logout",
                          color: isDarkMode
                              ? DarkModeColors.whiteColor
                              : Colors.black,
                          fontSize: FontSize.textFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        content: Txt(
                          text: "Are you sure you want to logout?",
                          color: isDarkMode
                              ? DarkModeColors.whiteColor
                              : Colors.black,
                          fontSize: FontSize.subTitleFontSize,
                          fontWeight: FontWeight.normal,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Txt(
                              text: "No",
                              color: isDarkMode
                                  ? DarkModeColors.whiteColor
                                  : Colors.black,
                              fontSize: FontSize.subTitleFontSize,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                              AppColors.primary,
                            )),
                            onPressed: () {
                              widget.controller.logout();
                            },
                            child: const Txt(
                              text: "Yes",
                              color: Colors.black,
                              fontSize: FontSize.subTitleFontSize,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Spacer(),
                  const ThemeModeSwitch(),
                  const SizedBox(height: 18),
                ],
              ),
            ),
    );
  }

  ListTile buildDrawerTile(
      BuildContext context, String text, IconData icon, Function onPressed) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      title: Txt(
        text: text,
        color: isDarkMode ? DarkModeColors.whiteGreyColor : AppColors.secondary,
        fontSize: FontSize.subTitleFontSize,
        fontWeight: FontWeight.normal,
      ),
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      onTap: () => onPressed(),
    );
  }
}
