import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_journey_app/storage/local_storage.dart';

import '../constants/string_manager.dart';
import '../models/user_model.dart';

class ProfileController extends GetxController with LocalStorage {
  Rx<bool> isLoading = false.obs;
  final Rx<File?> _pickedImage = Rx<File?>(null);
  File? get profilePhoto => _pickedImage.value;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  late Rx<User> user;

  GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    user = User().obs;
    getCurrentUserInfo(getUserId()!);
  }

  Future<void> getCurrentUserInfo(String id) async {
    try {
      toggleLoading();
      final url = Uri.parse("${AppStrings.BASE_URL}/user/current/$id");
      final response = await http.get(
        url,
      );
      if (response.statusCode == 201) {
        final res = jsonDecode(response.body);
        user.value = User.fromJson(res['user']);
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch user information.',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
      );
    } finally {
      toggleLoading();
    }
  }

  void toggleLoading() {
    isLoading.value = !isLoading.value;
  }

  Future<void> pickProfile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        _pickedImage.value = file;
        await _uploadToStorage();
      }
    } catch (e) {
      Get.snackbar('Error!', e.toString());
    }
  }

  Future<void> _uploadToStorage() async {
    String id = getUserId()!;
    final url = Uri.parse('${AppStrings.BASE_URL}/profile/image/$id');
    var request = http.MultipartRequest('PUT', url);
    request.files.add(await http.MultipartFile.fromPath(
        'profilePic', _pickedImage.value!.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar('Success!', 'Profile picture uploaded successfully');
      } else {
        Get.snackbar('Error!', 'Failed to upload profile picture');
      }
    } catch (e) {
      Get.snackbar('Error!', e.toString());
    }
  }

  Future<void> updateProfile() async {
    if (editProfileFormKey.currentState!.validate()) {
      try {
        toggleLoading();

        String id = getUserId()!;
        var url = Uri.parse('${AppStrings.BASE_URL}/profile/update/$id');
        var response = await http.put(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'fullname': nameController.text,
            'contact_no': phoneController.text,
          }),
        );
        if (response.statusCode == 200) {
          user.value = User.fromJson(jsonDecode(response.body)['user']);
          update();
          Get.back();
          Get.snackbar('Success!', 'Profile updated successfully');
        } else {
          Get.snackbar('Error!', 'Failed to update profile');
        }
      } catch (e) {
        Get.snackbar('Error!', e.toString());
      } finally {
        toggleLoading();
      }
    }
  }

  void clearFields() {
    nameController.clear();
    phoneController.clear();
    isLoading.value = false;
  }
}
