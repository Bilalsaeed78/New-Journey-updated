import 'dart:convert';

import 'package:get/get.dart';
import 'package:new_journey_app/storage/local_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/string_manager.dart';
import '../models/property_model.dart';
import '../models/request_model.dart';

class HistoryController extends GetxController with LocalStorage {
  Rx<bool> isLoading = false.obs;

  void toggleLoading() {
    isLoading.value = !isLoading.value;
  }

  final Rx<List<RequestModel>> _myPropertyRequests = Rx<List<RequestModel>>([]);
  List<RequestModel> get myPropertyRequests => _myPropertyRequests.value;

  final Rx<List<Property>> _myProperties = Rx<List<Property>>([]);
  List<Property> get myProperties => _myProperties.value;

  final Rx<List<Property>> _guestAppliedProperties = Rx<List<Property>>([]);
  List<Property> get guestAppliedProperties => _guestAppliedProperties.value;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> getGuestProperties() async {
    try {
      final url = Uri.parse(
          "${AppStrings.BASE_URL}/request/byGuestApplication/${getUserId()}");
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final jsonResponse = jsonDecode(resp.body);
        final propertiesJson = jsonResponse['properties'] as List<dynamic>;
        List<Property> properties = propertiesJson
            .map((propertyJson) => Property.fromJson(propertyJson))
            .toList();

        _guestAppliedProperties.value.addAll(properties);
      }
    } catch (e) {
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    }
  }

  Future<String?>? getPropertyAccomodationStatus(String propertyId) async {
    try {
      final userId = getUserId();
      final url = Uri.parse(
          '${AppStrings.BASE_URL}/request/checkStatus?propertyId=$propertyId&guestId=$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final resp = jsonResponse['request'];
        return resp['status'];
      } else {
        return null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        "Failed to load data.",
      );
      return null;
    }
  }

  Future<void> loadData() async {
    try {
      toggleLoading();
      final url = Uri.parse("${AppStrings.BASE_URL}/property");
      final resp = await http.get(url);

      final jsonResponse = jsonDecode(resp.body);
      final propertiesJson = jsonResponse['properties'] as List<dynamic>;

      List<Property> properties = propertiesJson
          .map((propertyJson) => Property.fromJson(propertyJson))
          .toList();

      for (int i = 0; i < properties.length; i++) {
        if (properties[i].ownerId == getUserId()) {
          _myProperties.value.add(properties[i]);
        }
      }
      await getGuestProperties();
    } catch (e) {
      Get.snackbar(
        'Error!',
        e.toString(),
      );
    } finally {
      toggleLoading();
    }
  }

  Future<void> getPropertyRequests(String propertyId) async {
    try {
      toggleLoading();
      _myPropertyRequests.value.clear();
      final url =
          Uri.parse('${AppStrings.BASE_URL}/request/byProperty/$propertyId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final reqJson = jsonResponse['requests'] as List<dynamic>;
        List<RequestModel> requests =
            reqJson.map((req) => RequestModel.fromJson(req)).toList();
        _myPropertyRequests.value.addAll(requests);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        "Failed to load data.",
      );
    } finally {
      toggleLoading();
    }
  }
}
