import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_journey_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import '../constants/font_manager.dart';
import '../constants/string_manager.dart';
import '../constants/themes/app_colors.dart';
import 'custom_text.dart';

class UserProfileDialog extends StatelessWidget {
  const UserProfileDialog({Key? key, required this.ownerId, this.bid})
      : super(key: key);

  final String ownerId;
  final int? bid;

  Future<User?>? getCurrentUserInfo(String id) async {
    final url = Uri.parse("${AppStrings.BASE_URL}/user/current/$id");
    final response = await http.get(
      url,
    );
    if (response.statusCode == 201) {
      final res = jsonDecode(response.body);
      final user = User.fromJson(res['user']);
      return user;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return FutureBuilder<User?>(
      future: getCurrentUserInfo(ownerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching user information'),
          );
        } else {
          final user = snapshot.data!;
          return AlertDialog(
            backgroundColor: isDarkMode
                ? DarkModeColors.containerColor
                : AppColors.background,
            title: SizedBox(
              width: double.infinity,
              child: Txt(
                textAlign: TextAlign.center,
                text: "Personal Details",
                color: isDarkMode ? DarkModeColors.whiteColor : Colors.black,
                fontSize: FontSize.textFontSize,
                fontWeight: FontWeightManager.semibold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundImage: user.profilePic != null &&
                          user.profilePic!.isNotEmpty
                      ? NetworkImage(user.profilePic!)
                      : const NetworkImage(
                          'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                  backgroundColor: AppColors.card,
                ),
                const SizedBox(height: 10),
                bid != null
                    ? Container(
                        color: AppColors.primaryLight,
                        width: double.infinity,
                        child: Txt(
                          textAlign: TextAlign.center,
                          text: "Bid: ${bid.toString()} Rs",
                          color: Colors.black,
                          fontSize: FontSize.textFontSize,
                          fontWeight: FontWeightManager.bold,
                        ),
                      )
                    : Container(),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Txt(
                    textAlign: TextAlign.center,
                    text: user.fullname,
                    color:
                        isDarkMode ? DarkModeColors.whiteColor : Colors.black,
                    fontSize: FontSize.subTitleFontSize,
                    fontWeight: FontWeightManager.regular,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Txt(
                    textAlign: TextAlign.center,
                    text: user.contactNo,
                    color:
                        isDarkMode ? DarkModeColors.whiteColor : Colors.black,
                    fontSize: FontSize.subTitleFontSize,
                    fontWeight: FontWeightManager.regular,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Txt(
                    textAlign: TextAlign.center,
                    text: user.email,
                    color:
                        isDarkMode ? DarkModeColors.whiteColor : Colors.black,
                    fontSize: FontSize.subTitleFontSize,
                    fontWeight: FontWeightManager.regular,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
