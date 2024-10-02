import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_journey_app/constants/font_manager.dart';
import 'package:new_journey_app/constants/themes/app_colors.dart';
import 'package:new_journey_app/controllers/property_controller.dart';

import '../models/autocomplete_predictor.dart';
import '../models/place_autocomplete_response.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/location_tile.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({Key? key, required this.propertyController})
      : super(key: key);
  final PropertyController propertyController;

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  List<AutocompletePrediction> places = [];
  final placeController = TextEditingController();

  Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        'maps/api/place/autocomplete/json',
        {"input": query, "key": 'AIzaSyDlOluV38QbJo2ASGYp3fvs41HlzT7RXO4'});
    String? response = await fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          places = result.predictions!;
        });
      }
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    Uri uri = Uri.https("maps.googleapis.com", 'maps/api/place/details/json', {
      "place_id": placeId,
      "key": 'AIzaSyDlOluV38QbJo2ASGYp3fvs41HlzT7RXO4',
    });

    String? response = await fetchUrl(uri);

    Map<String, dynamic> data = json.decode(response!);
    double? latitude = data['result']['geometry']['location']['lat'];
    double? longitude = data['result']['geometry']['location']['lng'];

    if (latitude != null && longitude != null) {
      widget.propertyController.isLocationPicked.value = true;
      widget.propertyController.location.value = [latitude, longitude];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor:
            isDarkMode ? DarkModeColors.backgroundColor : AppColors.background,
        iconTheme: IconThemeData(
            color:
                isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary),
        elevation: 0,
        title: Txt(
          text: "Pick Location",
          textAlign: TextAlign.start,
          fontWeight: FontWeight.normal,
          fontSize: FontSize.textFontSize,
          color: isDarkMode ? DarkModeColors.whiteColor : AppColors.secondary,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomTextFormField(
              controller: placeController,
              labelText: "Search your location",
              autofocus: false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              prefixIconData: Icons.location_on,
              onChanged: (value) {
                placeAutocomplete(value!);
              },
            ),
          ),
          Divider(
            height: 4,
            thickness: 4,
            color: isDarkMode
                ? DarkModeColors.whiteColor.withOpacity(0.4)
                : AppColors.divider,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) => LocationListTile(
                press: () {
                  if (placeController.text.isNotEmpty) {
                    setState(() {
                      placeController.text = places[index].description!;
                      getPlaceDetails(places[index].placeId!);
                      places.clear();
                    });

                    Get.back();
                  } else {
                    Get.snackbar(
                      'Location Error!',
                      'Please search or pick a location.',
                    );
                  }
                },
                location: places[index].description!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
