import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/controllers/request_controller.dart';
import 'package:new_journey_app/models/request_model.dart';
import 'package:new_journey_app/models/user_model.dart';

import '../constants/themes/app_colors.dart';
import 'custom_text.dart';
import 'user_profile_dialog.dart';

class RequestTile extends StatefulWidget {
  const RequestTile({
    super.key,
    required this.requestModel,
    required this.requestController,
    required this.isHistoryRoute,
    required this.type,
  });

  final RequestModel requestModel;
  final RequestController requestController;
  final bool isHistoryRoute;
  final String type;

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  late User user;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading = true;
      await Future.delayed(const Duration(seconds: 1));
      user = (await widget.requestController
          .getCurrentUserInfo(widget.requestModel.guestId))!;
      isLoading = false;
      setState(() {});
    } catch (error) {
      isLoading = false;
      Get.snackbar(
        'Error',
        "Failed to load data.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? _buildShimmerEffect(context) : _buildTileContent();
  }

  Widget _buildShimmerEffect(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDarkMode ? DarkModeColors.darkGreyColor : Colors.grey[300]!,
      highlightColor:
          isDarkMode ? DarkModeColors.lightGreyColor : Colors.grey[100]!,
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.white),
        title: Container(color: Colors.white, height: 20.0, width: 100.0),
        subtitle: Container(color: Colors.white, height: 12.0, width: 150.0),
      ),
    );
  }

  Padding _buildTileContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        iconColor: AppColors.primary,
        tileColor: widget.requestModel.status == 'accepted'
            ? AppColors.success.withOpacity(0.4)
            : widget.requestModel.status == 'rejected'
                ? AppColors.error.withOpacity(0.3)
                : AppColors.whiteShade,
        leading: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return UserProfileDialog(
                  ownerId: user.uid!,
                  bid: widget.requestModel.bid,
                );
              },
            );
          },
          child: CircleAvatar(
            radius: 24,
            backgroundImage: user.profilePic != null &&
                    user.profilePic!.isNotEmpty
                ? NetworkImage(user.profilePic!)
                : const NetworkImage(
                    'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
            backgroundColor: AppColors.card,
          ),
        ),
        title: Txt(
          text: user.fullname!.split(' ').first.capitalize,
          useOverflow: true,
        ),
        subtitle: Txt(
          text: widget.requestModel.status == 'accepted'
              ? 'Accepted'
              : widget.requestModel.status == 'rejected'
                  ? 'Rejected'
                  : "Bid: ${widget.requestModel.bid} Rs",
        ),
        trailing: widget.isHistoryRoute
            ? (widget.requestModel.status == 'pending'
                ? const Icon(
                    Icons.error,
                    color: Colors.amber,
                    size: 30,
                  )
                : widget.requestModel.status == 'rejected'
                    ? const Icon(
                        Icons.cancel,
                        color: AppColors.error,
                        size: 30,
                      )
                    : const Icon(
                        Icons.check_box,
                        color: AppColors.success,
                        size: 30,
                      ))
            : SizedBox(
                width: Get.width * 0.27,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (widget.requestModel.status != 'accepted') {
                          await widget.requestController.updateRequestStatus(
                              widget.requestModel.id!, 'accepted', widget.type);
                        }
                      },
                      icon: const Icon(
                        Icons.check_box,
                        color: AppColors.success,
                        size: 30,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        if (widget.requestModel.status != 'rejected') {
                          await widget.requestController.updateRequestStatus(
                              widget.requestModel.id!, 'rejected', widget.type);
                        }
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: AppColors.error,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
