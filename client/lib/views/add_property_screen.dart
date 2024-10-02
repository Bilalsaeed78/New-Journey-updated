import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/constants/themes/app_colors.dart';
import 'package:new_journey_app/controllers/property_controller.dart';
import 'package:new_journey_app/models/apartment_model.dart';
import 'package:new_journey_app/models/office_model.dart';
import 'package:new_journey_app/views/images_viewer_screen.dart';
import 'package:new_journey_app/views/search_location_screen.dart';
import 'package:new_journey_app/widgets/custom_text.dart';
import 'package:new_journey_app/widgets/custom_text_form_field.dart';

import '../constants/font_manager.dart';
import '../constants/value_manager.dart';
import '../models/room_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/packages/group_radio_buttons/grouped_buttons.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({
    super.key,
    required this.propertyController,
    required this.type,
    required this.isEdit,
    this.data,
  });

  final PropertyController propertyController;
  final String type;
  final bool isEdit;
  final Map<String, dynamic>? data;

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      final controller = widget.propertyController;
      if (widget.type == 'room') {
        Room room = Room.fromJson(widget.data!);
        controller.roomNumberController.text = room.roomNumber;
        controller.propertyAddressController.text = room.address;
        controller.overviewController.text = room.overview;
        controller.rentalPriceController.text =
            room.rentalPrice.toStringAsFixed(0);
        controller.maxCapacityController.text = room.maxCapacity.toString();
        controller.wifiAvailable = room.wifiAvailable;
        controller.contactController.text = room.contactNumber;
        controller.maxCapacityController.text = room.maxCapacity.toString();
      } else if (widget.type == 'office') {
        Office office = Office.fromJson(widget.data!);
        controller.officeNumberController.text = office.officeAddress;
        controller.propertyAddressController.text = office.address;
        controller.overviewController.text = office.overview!;
        controller.rentalPriceController.text =
            office.rentalPrice.toStringAsFixed(0);
        controller.maxCapacityController.text = office.maxCapacity.toString();
        controller.contactController.text = office.contactNumber;
        controller.wifiAvailable = office.wifiAvailable;
        controller.acAvailable = office.acAvailable;
        controller.cabinsController.text = office.cabinsAvailable.toString();
      } else {
        Apartment apartment = Apartment.fromJson(widget.data!);
        controller.apartmentNumberController.text = apartment.apartmentNumber;
        controller.propertyAddressController.text = apartment.address;
        controller.overviewController.text = apartment.overview!;
        controller.rentalPriceController.text =
            apartment.rentalPrice.toStringAsFixed(0);
        controller.maxCapacityController.text =
            apartment.maxCapacity.toString();
        controller.contactController.text = apartment.contactNumber;
        controller.floorController.text = apartment.floor.toString();
        controller.roomsController.text = apartment.rooms.toString();
        controller.liftAvailable = apartment.liftAvailable;
      }
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
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Txt(
          text: widget.isEdit
              ? "Edit ${widget.type.capitalizeFirst!}"
              : "Add ${widget.type.capitalizeFirst!}",
          color: isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: MarginManager.marginL,
          ),
          child: Form(
            key: widget.propertyController.formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 14,
                ),
                if (widget.type == 'room')
                  CustomTextFormField(
                    controller: widget.propertyController.roomNumberController,
                    labelText: "Room Number",
                    hintText: "Room 03/B, Flat ABC",
                    autofocus: false,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    prefixIconData: Icons.home,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Room number cannot be empty.";
                      }
                      return null;
                    },
                  ),
                if (widget.type == 'apartment')
                  CustomTextFormField(
                    controller:
                        widget.propertyController.apartmentNumberController,
                    labelText: "Apartment Number",
                    hintText: "Flat 03/B, Abc Tower",
                    autofocus: false,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    prefixIconData: Icons.home,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Apartment number cannot be empty.";
                      }
                      return null;
                    },
                  ),
                if (widget.type == 'office')
                  CustomTextFormField(
                    controller:
                        widget.propertyController.officeNumberController,
                    labelText: "Office Number",
                    hintText: "Office # 201, ABC Tower",
                    autofocus: false,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    prefixIconData: Icons.home,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Office number cannot be empty.";
                      }
                      return null;
                    },
                  ),
                const SizedBox(
                  height: SizeManager.sizeM,
                ),
                CustomTextFormField(
                  controller:
                      widget.propertyController.propertyAddressController,
                  labelText: "Property Address",
                  hintText: "Complete property address",
                  autofocus: false,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  prefixIconData: Icons.home_sharp,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Address cannot be empty.";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: SizeManager.sizeM,
                ),
                CustomTextFormField(
                  controller: widget.propertyController.overviewController,
                  labelText: "Description",
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  prefixIconData: Icons.description,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Description cannot be empty.";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: SizeManager.sizeM,
                ),
                CustomTextFormField(
                  controller: widget.propertyController.contactController,
                  labelText: "Contact Number",
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  prefixIconData: Icons.call,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Contact number cannot be empty.";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: SizeManager.sizeM,
                ),
                CustomTextFormField(
                  controller: widget.propertyController.rentalPriceController,
                  labelText: "Rent per month (PKR)",
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  prefixIconData: Icons.attach_money,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Rent cannot be empty.";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: SizeManager.sizeM,
                ),
                CustomTextFormField(
                  controller: widget.propertyController.maxCapacityController,
                  labelText: "Capacity",
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  prefixIconData: Icons.group,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Capacity cannot be empty.";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: SizeManager.sizeM,
                ),
                if (widget.type == 'office')
                  Column(
                    children: [
                      const SizedBox(
                        height: SizeManager.sizeS,
                      ),
                      RadioButtonFormField(
                        labels: const ['Yes', 'No'],
                        icons: const [Icons.check, Icons.close],
                        onChange: (String label, int index) {
                          bool v = label == 'Yes' ? true : false;
                          widget.propertyController.liftAvailable = v;
                        },
                        onSelected: (String label) {
                          bool v = label == 'Yes' ? true : false;
                          widget.propertyController.liftAvailable = v;
                        },
                        decoration: InputDecoration(
                          labelText: 'Lift Available',
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
                            borderRadius: BorderRadius.circular(
                                RadiusManager.fieldRadius),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: SizeManager.sizeM,
                      ),
                      CustomTextFormField(
                        controller: widget.propertyController.cabinsController,
                        labelText: "No. of Cabins",
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        prefixIconData: Icons.keyboard,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Cabins cannot be empty.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: SizeManager.sizeM,
                      ),
                      RadioButtonFormField(
                        labels: const ['Yes', 'No'],
                        icons: const [Icons.check, Icons.close],
                        onChange: (String label, int index) {
                          bool v = label == 'Yes' ? true : false;
                          widget.propertyController.acAvailable = v;
                        },
                        onSelected: (String label) {
                          bool v = label == 'Yes' ? true : false;
                          widget.propertyController.acAvailable = v;
                        },
                        decoration: InputDecoration(
                          labelText: 'AC Available',
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
                            borderRadius: BorderRadius.circular(
                                RadiusManager.fieldRadius),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: SizeManager.sizeM,
                      ),
                    ],
                  ),
                if (widget.type == 'room')
                  Column(
                    children: [
                      const SizedBox(
                        height: SizeManager.sizeS,
                      ),
                      RadioButtonFormField(
                        labels: const ['Yes', 'No'],
                        icons: const [Icons.check, Icons.close],
                        onChange: (String label, int index) {
                          bool v = label == 'Yes' ? true : false;
                          widget.propertyController.wifiAvailable = v;
                        },
                        onSelected: (String label) {
                          bool v = label == 'Yes' ? true : false;
                          widget.propertyController.wifiAvailable = v;
                        },
                        decoration: InputDecoration(
                          labelText: 'Wifi Available',
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
                            borderRadius: BorderRadius.circular(
                                RadiusManager.fieldRadius),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (widget.type == 'apartment')
                  Column(
                    children: [
                      CustomTextFormField(
                        controller: widget.propertyController.floorController,
                        labelText: "Floors",
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        prefixIconData: Icons.stairs,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Floors cannot be empty.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: SizeManager.sizeM,
                      ),
                      CustomTextFormField(
                        controller: widget.propertyController.roomsController,
                        labelText: "No. of Rooms",
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        prefixIconData: Icons.meeting_room,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Rooms cannot be empty.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: SizeManager.sizeXL,
                      ),
                      RadioButtonFormField(
                        labels: const ['Yes', 'No'],
                        icons: const [Icons.check, Icons.close],
                        onChange: (String label, int index) {
                          bool v = label == 'Yes' ? true : false;
                          widget.propertyController.liftAvailable = v;
                        },
                        onSelected: (String label) {
                          bool v = label == 'Yes' ? true : false;
                          widget.propertyController.liftAvailable = v;
                        },
                        decoration: InputDecoration(
                          labelText: 'Lift Available',
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
                            borderRadius: BorderRadius.circular(
                                RadiusManager.fieldRadius),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: SizeManager.sizeM,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: SizeManager.sizeM,
                ),
                if (!widget.isEdit)
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(ImageViewerScreen(
                                propertyController: widget.propertyController));
                          },
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  RadiusManager.buttonRadius),
                              color: isDarkMode
                                  ? DarkModeColors.cardBackgroundColor
                                  : AppColors.propertyContainer,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  color: isDarkMode
                                      ? DarkModeColors.whiteGreyColor
                                      : AppColors.secondary,
                                ),
                                Txt(
                                  text:
                                      "Add ${widget.type.capitalizeFirst!} Images",
                                  color: isDarkMode
                                      ? DarkModeColors.whiteColor
                                      : AppColors.secondary,
                                  fontWeight: FontWeightManager.medium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        return widget.propertyController.isImagePicked.isFalse
                            ? const Icon(
                                Icons.close_outlined,
                                color: AppColors.error,
                              )
                            : const Icon(
                                Icons.check_box,
                                color: AppColors.success,
                              );
                      }),
                    ],
                  ),
                const SizedBox(
                  height: SizeManager.sizeM,
                ),
                if (!widget.isEdit)
                  InkWell(
                    onTap: () {
                      Get.to(SearchLocationScreen(
                        propertyController: widget.propertyController,
                      ));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? DarkModeColors.cardBackgroundColor
                            : AppColors.propertyContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.map,
                              color: isDarkMode
                                  ? DarkModeColors.whiteGreyColor
                                  : AppColors.secondary),
                          const SizedBox(
                            width: 12,
                          ),
                          Txt(
                            text:
                                widget.propertyController.isLocationPicked.value
                                    ? 'Location Picked'
                                    : 'Pick Location',
                          ),
                          const Spacer(),
                          Obx(() => widget
                                  .propertyController.isLocationPicked.value
                              ? const Icon(Icons.check_box, color: Colors.green)
                              : const Icon(Icons.dangerous, color: Colors.red)),
                          const SizedBox(
                            width: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(
                  height: SizeManager.sizeL,
                ),
                Obx(
                  () => CustomButton(
                    color: AppColors.primary,
                    hasInfiniteWidth: true,
                    loadingWidget: widget.propertyController.isLoading.value
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
                      if (!widget.isEdit) {
                        if (widget.type == 'room') {
                          await widget.propertyController.addRoom();
                        } else if (widget.type == 'office') {
                          await widget.propertyController.addOffice();
                        } else {
                          await widget.propertyController.addApartment();
                        }
                      } else {
                        if (widget.type == 'room') {
                          await widget.propertyController
                              .editRoom(widget.data!['_id']);
                        } else if (widget.type == 'office') {
                          await widget.propertyController
                              .editOFfice(widget.data!['_id']);
                        } else {
                          await widget.propertyController
                              .editApartment(widget.data!['_id']);
                        }
                      }
                    },
                    text: widget.isEdit ? "Edit" : "Add",
                    textColor: isDarkMode
                        ? DarkModeColors.backgroundColor
                        : AppColors.background,
                    buttonType: ButtonType.loading,
                  ),
                ),
                const SizedBox(
                  height: SizeManager.sizeXL,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
