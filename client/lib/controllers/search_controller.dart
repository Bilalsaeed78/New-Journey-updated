import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_journey_app/constants/string_manager.dart';
import 'package:new_journey_app/models/property_model.dart';

import '../models/apartment_model.dart';
import '../models/office_model.dart';
import '../models/room_model.dart';
import 'property_controller.dart';

class SearchFilterController extends GetxController {
  final filterFormKey = GlobalKey<FormState>();

  final Rx<List<Property>> _searchedProperties = Rx<List<Property>>([]);
  List<Property> get searchedProperties => _searchedProperties.value;

  final searchTextController = TextEditingController();
  final maxRent = TextEditingController();

  RxBool isLocationFilterApplied = false.obs;
  RxBool isRentFilterApplied = false.obs;
  RxBool isFilterApplied = false.obs;

  void clearFields() {
    searchTextController.clear();
    isFilterApplied.value = false;
    isLocationFilterApplied.value = false;
    isRentFilterApplied.value = false;
    maxRent.clear();
    _searchedProperties.value = [];
  }

  RxBool isLoading = false.obs;

  void toggleLoading() {
    isLoading.value = !isLoading.value;
  }

  Timer? _debounceTimer;

  Future<void> searchOnText(String query, PropertyController controller) async {
    try {
      _debounceTimer?.cancel();

      _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
        try {
          toggleLoading();
          isFilterApplied.value = true;
          List<Property> retVal = [];
          List<Property> propertyCopy = List.from(controller.allProperties);
          for (var property in propertyCopy) {
            if (property.type == 'room') {
              final roomUrl = Uri.parse(
                  "${AppStrings.BASE_URL}/room/${property.propertyId}");
              final roomResp = await http.get(roomUrl);
              final roomJson = jsonDecode(roomResp.body)['room'];
              final room = Room.fromJson(roomJson);
              if (room.address.toLowerCase().contains(query.toLowerCase())) {
                retVal.add(property);
              }
            } else if (property.type == 'office') {
              final officeUrl = Uri.parse(
                  "${AppStrings.BASE_URL}/office/${property.propertyId}");
              final officeResp = await http.get(officeUrl);
              final officeJson = jsonDecode(officeResp.body)['office'];
              final office = Office.fromJson(officeJson);
              if (office.address.toLowerCase().contains(query.toLowerCase())) {
                retVal.add(property);
              }
            } else {
              final apartmentUrl = Uri.parse(
                  "${AppStrings.BASE_URL}/apartment/${property.propertyId}");
              final apartmentResp = await http.get(apartmentUrl);
              final apartmentJson = jsonDecode(apartmentResp.body)['apartment'];
              final apartment = Apartment.fromJson(apartmentJson);
              if (apartment.address
                  .toLowerCase()
                  .contains(query.toLowerCase())) {
                retVal.add(property);
              }
            }
          }
          print(retVal.length);
          _searchedProperties.value = retVal;
          _searchedProperties.refresh();
        } catch (e) {
          isFilterApplied.value = false;
          Get.snackbar(
            'Error!',
            e.toString(),
          );
        } finally {
          toggleLoading();
        }
      });
    } catch (e) {
      isFilterApplied.value = false;
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    }
  }

  Future<void> searchOnFilters(PropertyController controller) async {
    try {
      if (controller.location.isEmpty && maxRent.text.isEmpty) {
        Get.snackbar("Error", "Apply filters to get filtered data.");
        return;
      }

      toggleLoading();
      isFilterApplied.value = true;
      _searchedProperties.value.clear();
      if (controller.location.isNotEmpty && maxRent.text.isEmpty) {
        isLocationFilterApplied.value = true;
        final url = Uri.parse("${AppStrings.BASE_URL}/filter/location");
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "location": {"coordinates": controller.location}
          }),
        );
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final propertyList = responseData['propertyList'];

          for (var propertyData in propertyList) {
            final distance = propertyData['distance'];
            Property property = Property.fromJson(propertyData['property']);
            property.distance = distance;
            _searchedProperties.value.add(property);
          }
        }
      }

      if (maxRent.text.isNotEmpty && controller.location.isEmpty) {
        final url = Uri.parse("${AppStrings.BASE_URL}/property");
        final resp = await http.get(url);

        final jsonResponse = jsonDecode(resp.body);
        final propertiesJson = jsonResponse['properties'] as List<dynamic>;

        List<Property> properties = propertiesJson
            .map((propertyJson) => Property.fromJson(propertyJson))
            .toList();
        double maxRentValue = double.parse(maxRent.text);
        for (var property in properties) {
          if (property.type == 'room') {
            final roomUrl =
                Uri.parse("${AppStrings.BASE_URL}/room/${property.propertyId}");
            final roomResp = await http.get(roomUrl);
            final roomJson = jsonDecode(roomResp.body)['room'];
            final room = Room.fromJson(roomJson);
            if (room.rentalPrice <= maxRentValue) {
              _searchedProperties.value.add(property);
            }
          } else if (property.type == 'office') {
            final officeUrl = Uri.parse(
                "${AppStrings.BASE_URL}/office/${property.propertyId}");
            final officeResp = await http.get(officeUrl);
            final officeJson = jsonDecode(officeResp.body)['office'];
            final office = Office.fromJson(officeJson);
            if (office.rentalPrice <= maxRentValue) {
              _searchedProperties.value.add(property);
            }
          } else {
            final apartmentUrl = Uri.parse(
                "${AppStrings.BASE_URL}/apartment/${property.propertyId}");
            final apartmentResp = await http.get(apartmentUrl);
            final apartmentJson = jsonDecode(apartmentResp.body)['apartment'];
            final apartment = Apartment.fromJson(apartmentJson);
            if (apartment.rentalPrice <= maxRentValue) {
              _searchedProperties.value.add(property);
            }
          }
        }
      }

      if (controller.location.isNotEmpty && maxRent.text.isNotEmpty) {
        isLocationFilterApplied.value = true;
        final url = Uri.parse("${AppStrings.BASE_URL}/filter/location");
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "location": {"coordinates": controller.location}
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final propertyList = responseData['propertyList'];

          double maxRentValue = double.parse(maxRent.text);
          for (var propertyData in propertyList) {
            final distance = propertyData['distance'];
            Property property = Property.fromJson(propertyData['property']);
            property.distance = distance;
            if (property.type == 'room') {
              final roomUrl = Uri.parse(
                  "${AppStrings.BASE_URL}/room/${property.propertyId}");
              final roomResp = await http.get(roomUrl);
              final roomJson = jsonDecode(roomResp.body)['room'];
              final room = Room.fromJson(roomJson);
              if (room.rentalPrice <= maxRentValue) {
                _searchedProperties.value.add(property);
              }
            } else if (property.type == 'office') {
              final officeUrl = Uri.parse(
                  "${AppStrings.BASE_URL}/office/${property.propertyId}");
              final officeResp = await http.get(officeUrl);
              final officeJson = jsonDecode(officeResp.body)['office'];
              final office = Office.fromJson(officeJson);
              if (office.rentalPrice <= maxRentValue) {
                _searchedProperties.value.add(property);
              }
            } else {
              final apartmentUrl = Uri.parse(
                  "${AppStrings.BASE_URL}/apartment/${property.propertyId}");
              final apartmentResp = await http.get(apartmentUrl);
              final apartmentJson = jsonDecode(apartmentResp.body)['apartment'];
              final apartment = Apartment.fromJson(
                apartmentJson,
              );
              if (apartment.rentalPrice <= maxRentValue) {
                _searchedProperties.value.add(property);
              }
            }
          }
        }
      }
      _searchedProperties.refresh();
      Get.back();
    } catch (e) {
      isLocationFilterApplied.value = false;
      isFilterApplied.value = false;
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    } finally {
      toggleLoading();
    }
  }
}
