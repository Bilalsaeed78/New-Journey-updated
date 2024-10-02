import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:new_journey_app/models/property_model.dart';
import 'package:new_journey_app/storage/local_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/string_manager.dart';
import '../models/apartment_model.dart';
import '../models/office_model.dart';
import '../models/room_model.dart';

class PropertyController extends GetxController with LocalStorage {
  final formKey = GlobalKey<FormState>();

  final roomNumberController = TextEditingController();
  final apartmentNumberController = TextEditingController();
  final officeNumberController = TextEditingController();
  final overviewController = TextEditingController();
  final rentalPriceController = TextEditingController();
  final floorController = TextEditingController();
  final roomsController = TextEditingController();
  final maxCapacityController = TextEditingController();
  final contactController = TextEditingController();
  final cabinsController = TextEditingController();
  final propertyAddressController = TextEditingController();
  var liftAvailable = true;
  var wifiAvailable = true;
  var acAvailable = true;
  RxBool isImagePicked = false.obs;
  RxBool isLocationPicked = false.obs;

  RxList<double> location = <double>[].obs;

  final Rx<List<Room>> _myAddedRooms = Rx<List<Room>>([]);
  List<Room> get myAddedRooms => _myAddedRooms.value;

  final Rx<List<Office>> _myAddedOffices = Rx<List<Office>>([]);
  List<Office> get myAddedOffices => _myAddedOffices.value;

  final Rx<List<Apartment>> _myAddedApartments = Rx<List<Apartment>>([]);
  List<Apartment> get myAddedApartments => _myAddedApartments.value;

  final Rx<List<Property>> _allProperties = Rx<List<Property>>([]);
  List<Property> get allProperties => _allProperties.value;

  final Rx<List<Property>> _myProperties = Rx<List<Property>>([]);
  List<Property> get myProperties => _myProperties.value;

  void clearFields() {
    propertyAddressController.clear();
    overviewController.clear();
    roomNumberController.clear();
    apartmentNumberController.clear();
    officeNumberController.clear();
    rentalPriceController.clear();
    floorController.clear();
    roomsController.clear();
    maxCapacityController.clear();
    contactController.clear();
    cabinsController.clear();
    multiImageController.clearImages();
    liftAvailable = true;
    wifiAvailable = true;
    acAvailable = true;
    isImagePicked.value = false;
    isLocationPicked.value = false;
    isLoading.value = false;
  }

  Rx<bool> isLoading = false.obs;

  void toggleLoading() {
    isLoading.value = !isLoading.value;
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void clearLists() {
    _myAddedApartments.value.clear();
    _myAddedOffices.value.clear();
    _myAddedRooms.value.clear();
    _myProperties.value.clear();
    _allProperties.value.clear();
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

      _allProperties.value.addAll(properties);
      for (int i = 0; i < properties.length; i++) {
        if (properties[i].ownerId == getUserId()) {
          _myProperties.value.add(properties[i]);
        }
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

  Future<void> deleteProperty(String id, String type, String propertyId) async {
    try {
      if (type == 'room') {
        final roomUrl = Uri.parse("${AppStrings.BASE_URL}/room/$id");
        await http.delete(roomUrl);
      } else if (type == 'office') {
        final officeUrl = Uri.parse("${AppStrings.BASE_URL}/office/$id");
        await http.delete(officeUrl);
      } else {
        final apartmentUrl = Uri.parse("${AppStrings.BASE_URL}/apartment/$id");
        await http.delete(apartmentUrl);
      }
      final propertyUrl =
          Uri.parse("${AppStrings.BASE_URL}/property/$propertyId");
      await http.delete(propertyUrl);
      clearLists();
      await loadData();
      Get.back();
      Get.back();
      Get.snackbar(
        
        'Success',
        'Property deleted successfully.',
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to delete property.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // multipart images

  var multiImageController =
      MultiImagePickerController(picker: (bool allowMultiple) async {
    final pickedImages = await ImagePicker().pickMultiImage();
    return convertXFilesToImageFiles(pickedImages);
  });

  static List<ImageFile> convertXFilesToImageFiles(List<XFile> xFiles) {
    List<ImageFile> imageFiles = [];
    for (var xFile in xFiles) {
      String fileName = xFile.path.split('/').last;
      String fileExtension = fileName.split('.').last;

      imageFiles.add(ImageFile(
        UniqueKey().toString(),
        name: fileName,
        extension: fileExtension,
        path: xFile.path,
      ));
    }
    return imageFiles;
  }

  // Get Properties
  Future<Map<String, dynamic>> getData(String type, String id) async {
    if (type == 'room') {
      final url = Uri.parse("${AppStrings.BASE_URL}/room/$id");
      final response = await http.get(url);
      return jsonDecode(response.body);
    } else if (type == 'office') {
      final url = Uri.parse("${AppStrings.BASE_URL}/office/$id");
      final response = await http.get(url);
      return jsonDecode(response.body);
    } else {
      final url = Uri.parse("${AppStrings.BASE_URL}/apartment/$id");
      final response = await http.get(url);
      return jsonDecode(response.body);
    }
  }

  // Add Properties

  Future<void> addRoom() async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        if (!isImagePicked.value) {
          Get.snackbar(
            'Empty Field',
            'Please provide images by adding them.',
          );
          isLoading.value = false;
          return;
        }

        if (!isLocationPicked.value) {
          Get.snackbar(
            'Empty Field',
            'Please pick your property location.',
          );
          isLoading.value = false;
          return;
        }

        toggleLoading();
        final List<ImageFile> images = multiImageController.images.toList();
        final formData = {
          'room_number': roomNumberController.text.trim(),
          'address': propertyAddressController.text.trim(),
          'overview': overviewController.text.trim(),
          'rental_price': double.parse(rentalPriceController.text),
          'max_capacity': int.parse(maxCapacityController.text),
          'wifiAvailable': wifiAvailable.toString(),
          'contact_number': contactController.text.trim(),
          'owner': getUserId(),
          'location': jsonEncode({'coordinates': location.toList()}),
        };

        final url = Uri.parse("${AppStrings.BASE_URL}/room");
        var request = http.MultipartRequest('POST', url);
        Map<String, String> headers = {'Content-Type': 'multipart/form-data'};

        request.headers.addAll(headers);

        formData.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        // ignore: avoid_function_literals_in_foreach_calls
        images.forEach((image) async {
          request.files.add(await http.MultipartFile.fromPath(
            'files',
            image.path!,
            contentType: MediaType('image', image.extension),
          ));
        });

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 201) {
          var decoded = jsonDecode(response.body)['room'];
          Room room = Room.fromJson(decoded);
          _myAddedRooms.value.add(room);

          Property property = Property(
              propertyId: room.id, type: 'room', ownerId: getUserId()!);
          var url = Uri.parse("${AppStrings.BASE_URL}/property");
          final propertyResp = await http.post(
            url,
            body: property.toJson(),
          );
          var data = jsonDecode(propertyResp.body);
          _myProperties.value.add(Property.fromJson(data['property']));
          clearFields();
          Get.back();
          Get.snackbar(
            'Success',
            'Room created successfully',
          );
        } else {
          Get.snackbar(
            'Error',
            jsonDecode(response.body)['message'],
          );
        }
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to create room',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addOffice() async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        if (!isImagePicked.value) {
          Get.snackbar(
            'Empty Field',
            'Please provide images by adding them.',
          );
          return;
        }

        if (!isLocationPicked.value) {
          Get.snackbar(
            'Empty Field',
            'Please pick your property location.',
          );
          return;
        }

        toggleLoading();
        final List<ImageFile> images = multiImageController.images.toList();
        final formData = {
          'office_address': officeNumberController.text.trim(),
          'address': propertyAddressController.text.trim(),
          'overview': overviewController.text.trim(),
          'rental_price': double.parse(rentalPriceController.text),
          'cabinsAvailable': int.parse(cabinsController.text),
          'max_capacity': int.parse(maxCapacityController.text),
          'wifiAvailable': wifiAvailable,
          'acAvailable': acAvailable,
          'contact_number': contactController.text.trim(),
          'owner': getUserId(),
          'location': jsonEncode({'coordinates': location.toList()}),
        };

        final url = Uri.parse("${AppStrings.BASE_URL}/office");
        var request = http.MultipartRequest('POST', url);
        Map<String, String> headers = {'Content-Type': 'multipart/form-data'};

        request.headers.addAll(headers);

        formData.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        // ignore: avoid_function_literals_in_foreach_calls
        images.forEach((image) async {
          request.files.add(await http.MultipartFile.fromPath(
            'files',
            image.path!,
            contentType: MediaType('image', image.extension),
          ));
        });

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 201) {
          var decoded = jsonDecode(response.body)['office'];
          Office office = Office.fromJson(decoded);
          _myAddedOffices.value.add(office);

          Property property = Property(
              propertyId: office.id!, type: 'office', ownerId: getUserId()!);

          var url = Uri.parse("${AppStrings.BASE_URL}/property");
          final propertyResp = await http.post(
            url,
            body: property.toJson(),
          );

          var data = jsonDecode(propertyResp.body);
          _myProperties.value.add(Property.fromJson(data['property']));
          clearFields();
          Get.back();
          Get.snackbar(
            'Success',
            'Office created successfully',
          );
        } else {
          Get.snackbar(
            'Error',
            jsonDecode(response.body)['message'],
          );
        }
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to create office',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addApartment() async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        if (!isImagePicked.value) {
          Get.snackbar(
            'Empty Field',
            'Please provide images by adding them.',
          );
          return;
        }

        if (!isLocationPicked.value) {
          Get.snackbar(
            'Empty Field',
            'Please pick your property location.',
          );
          return;
        }

        toggleLoading();
        final List<ImageFile> images = multiImageController.images.toList();
        final formData = {
          'apartment_number': apartmentNumberController.text.trim(),
          'address': propertyAddressController.text.trim(),
          'overview': overviewController.text.trim(),
          'rental_price': double.parse(rentalPriceController.text),
          'floor': int.parse(floorController.text),
          'rooms': int.parse(roomsController.text),
          'max_capacity': int.parse(maxCapacityController.text),
          'liftAvailable': liftAvailable,
          'contact_number': contactController.text.trim(),
          'owner': getUserId(),
          'location': jsonEncode({'coordinates': location.toList()}),
        };

        final url = Uri.parse("${AppStrings.BASE_URL}/apartment");
        var request = http.MultipartRequest('POST', url);
        Map<String, String> headers = {'Content-Type': 'multipart/form-data'};

        request.headers.addAll(headers);

        formData.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        // ignore: avoid_function_literals_in_foreach_calls
        images.forEach((image) async {
          request.files.add(await http.MultipartFile.fromPath(
            'files',
            image.path!,
            contentType: MediaType('image', image.extension),
          ));
        });

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 201) {
          var decoded = jsonDecode(response.body)['apartment'];
          Apartment apartment = Apartment.fromJson(decoded);
          _myAddedApartments.value.add(apartment);

          Property property = Property(
              propertyId: apartment.id!,
              type: 'apartment',
              ownerId: getUserId()!);

          var url = Uri.parse("${AppStrings.BASE_URL}/property");
          final propertyResp = await http.post(
            url,
            body: property.toJson(),
          );

          var data = jsonDecode(propertyResp.body);
          _myProperties.value.add(Property.fromJson(data['property']));
          clearFields();
          Get.back();
          Get.snackbar(
            'Success',
            'Apartment created successfully',
          );
        } else {
          Get.snackbar(
            'Error',
            jsonDecode(response.body)['message'],
          );
        }
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to create apartment',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Edit Property
  Future<void> editRoom(String id) async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        toggleLoading();

        var url = Uri.parse("${AppStrings.BASE_URL}/room/$id");
        await http.put(
          url,
          body: {
            'room_number': roomNumberController.text.trim(),
            'address': propertyAddressController.text.trim(),
            'overview': overviewController.text.trim(),
            'rental_price': rentalPriceController.text.trim(),
            'max_capacity': maxCapacityController.text.trim(),
            'wifiAvailable': wifiAvailable.toString(),
            'contact_number': contactController.text.trim(),
          },
        );
        clearLists();
        await loadData();
        Get.back();
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to edit room.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editOFfice(String id) async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        toggleLoading();

        var url = Uri.parse("${AppStrings.BASE_URL}/office/$id");
        await http.put(
          url,
          body: {
            'office_address': officeNumberController.text.trim(),
            'address': propertyAddressController.text.trim(),
            'overview': overviewController.text.trim(),
            'rental_price': rentalPriceController.text.trim(),
            'cabinsAvailable': cabinsController.text.trim(),
            'max_capacity': maxCapacityController.text.trim(),
            'wifiAvailable': wifiAvailable.toString(),
            'acAvailable': acAvailable.toString(),
            'contact_number': contactController.text.trim(),
          },
        );
        clearLists();
        await loadData();
        Get.back();
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to edit office.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editApartment(String id) async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        toggleLoading();

        var url = Uri.parse("${AppStrings.BASE_URL}/apartment/$id");
        await http.put(
          url,
          body: {
            'apartment_number': apartmentNumberController.text.trim(),
            'address': propertyAddressController.text.trim(),
            'overview': overviewController.text.trim(),
            'rental_price': rentalPriceController.text.trim(),
            'floor': floorController.text.trim(),
            'rooms': roomsController.text.trim(),
            'max_capacity': maxCapacityController.text.trim(),
            'liftAvailable': liftAvailable.toString(),
            'contact_number': contactController.text.trim(),
          },
        );
        clearLists();
        await loadData();
        Get.back();
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to edit apartment.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // CHIPS LOGICS HERE
  List<String> filters = ['All', 'Room', 'Office', 'Apartment'];
  var selectedFilter = 'All'.obs;

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }
}
