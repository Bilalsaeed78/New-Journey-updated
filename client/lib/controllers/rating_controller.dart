import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_journey_app/models/user_model.dart';

import '../constants/string_manager.dart';
import '../models/review_model.dart';

class RatingController extends GetxController {
  final reviewController = TextEditingController(text: "");

  Rx<double> rating = 1.0.obs;

  Rx<bool> isLoading = false.obs;

  void toggleLoading() {
    isLoading.value = !isLoading.value;
  }

  void updateRating(double val) {
    rating.value = val;
  }

  void clearFields() {
    reviewController.clear();
    rating.value = 1.0;
  }

  final Rx<List<Review>> _myPropertyReviews = Rx<List<Review>>([]);
  List<Review> get myPropertyReviews => _myPropertyReviews.value;

  final Rx<List<User>> _reviewsUsers = Rx<List<User>>([]);
  List<User> get reviewsUsers => _reviewsUsers.value;

  Future<void> getPropertyReviews(String propertyId) async {
    try {
      toggleLoading();
      final url =
          Uri.parse("${AppStrings.BASE_URL}/review/property/$propertyId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final reviewsJson = jsonResponse['reviews'] as List<dynamic>;

        _reviewsUsers.value.clear();
        _myPropertyReviews.value.clear();

        List<Review> reviews = [];
        for (var reviewJson in reviewsJson) {
          User userData = User.fromJson(reviewJson['user_id']);
          _reviewsUsers.value.add(userData);
          reviews.add(Review.fromJson(reviewJson));
        }

        _myPropertyReviews.value = reviews;
      } else {
        throw Exception('Failed to load property reviews');
      }
    } catch (e) {
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    } finally {
      toggleLoading();
    }
  }

  Future<void> addRatings(
      String propertyId, String guestId, String type) async {
    try {
      toggleLoading();
      Review review = Review(
          userId: guestId,
          propertyId: propertyId,
          type: type,
          rating: rating.value,
          comments:
              reviewController.text == "" ? "" : reviewController.text.trim());
      final url = Uri.parse("${AppStrings.BASE_URL}/review/");
      final response = await http.post(
        url,
        body: review.toJson(),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        clearFields();
        Get.back();
        Get.snackbar(
          'Success!',
          "Review added successfully.",
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    } finally {
      toggleLoading();
    }
  }
}
