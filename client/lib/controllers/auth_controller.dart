import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:new_journey_app/constants/string_manager.dart';
import 'package:new_journey_app/storage/local_storage.dart';
import 'package:new_journey_app/views/guest_dashboard.dart';
import 'package:new_journey_app/views/owner_dashboard.dart';

import '../models/user_model.dart';
import '../views/login_screen.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController with LocalStorage {
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController userTypeController =
      TextEditingController(text: 'Guest');

  Rx<bool> isObscure = true.obs;
  Rx<bool> isLoading = false.obs;

  void toggleVisibility() {
    isObscure.value = !isObscure.value;
  }

  void toggleLoading() {
    isLoading.value = !isLoading.value;
  }

  void checkLoginStatus() async {
    final userType = getUserType();
    if (userType == null || userType.isEmpty) {
      Get.off(const LoginScreen());
    } else {
      var user = await getCurrentUserInfo(getUserId()!);
      if (userType == "guest") {
        Get.offAll(GuestDashbaord(
          user: user!,
        ));
      } else {
        Get.offAll(OwnerDashboard(
          user: user!,
        ));
      }
    }
  }

  Future<User?> getCurrentUserInfo(String id) async {
    try {
      toggleLoading();
      final url = Uri.parse("${AppStrings.BASE_URL}/user/current/$id");
      final response = await http.get(url);
      if (response.statusCode == 201) {
        final res = jsonDecode(response.body);
        final user = User.fromJson(res['user']);
        return user;
      } else {
        Get.snackbar('Error', 'Failed to fetch user information.');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    } finally {
      toggleLoading();
    }
  }

  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String cnic,
    required String role,
  }) async {
    try {
      if (signupFormKey.currentState!.validate()) {
        signupFormKey.currentState!.save();
        toggleLoading();
        User user = User(
          email: email,
          password: password,
          role: role,
          fullname: name,
          contactNo: phone,
          cnic: cnic,
        );
        var url = Uri.parse("${AppStrings.BASE_URL}/user/register");
        final response = await http.post(
          url,
          body: user.toJson(),
        );

        var data = jsonDecode(response.body);

        if (response.statusCode == 201) {
          clearFields();
          Get.offAll(const LoginScreen());
          Get.snackbar(
            'Success',
            "Account created successfully.",
          );
        } else {
          Get.snackbar(
            'Error',
            data['message'],
          );
        }
      }
    } catch (err) {
      Get.snackbar(
        'Error registering.',
        err.toString(),
      );
    } finally {
      toggleLoading();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      if (loginFormKey.currentState!.validate()) {
        loginFormKey.currentState!.save();
        toggleLoading();
        final url = Uri.parse("${AppStrings.BASE_URL}/user/authenticate");
        final response = await http.post(
          url,
          body: {
            'email': email,
            'password': password,
          },
        );
        final res = jsonDecode(response.body);
        if (response.statusCode == 201) {
          final user = User.fromJson(res['user']);
          setUserId(user.uid!);
          setUserType(user.role!);
          if (user.role == 'owner') {
            Get.offAll(OwnerDashboard(
              user: user,
            ));
          } else {
            Get.offAll(GuestDashbaord(
              user: user,
            ));
          }
        } else {
          Get.snackbar(
            'Error',
            res['message'],
          );
        }
      }
    } catch (err) {
      Get.snackbar(
        'Error Logging in',
        err.toString(),
      );
    } finally {
      toggleLoading();
    }
  }

  void logout() async {
    removeToken();
    removeUserId();
    clearFields();
    Get.offAll(const LoginScreen());
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    cnicController.clear();
    userTypeController.text = 'Guest';
  }
}
