import 'package:flutter/material.dart';
import 'package:new_journey_app/constants/themes/app_colors.dart';

import 'custom_text.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    Key? key,
    required this.location,
    required this.press,
  }) : super(key: key);

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading: Icon(Icons.location_on,
              color:
                  isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary),
          minLeadingWidth: 40,
          title: Txt(
            text: location,
            maxLines: 2,
            useOverflow: true,
            fontSize: 14,
          ),
        ),
        Divider(
          height: 2,
          thickness: 1,
          color: isDarkMode
              ? DarkModeColors.whiteColor.withOpacity(0.4)
              : AppColors.divider,
        ),
      ],
    );
  }
}
