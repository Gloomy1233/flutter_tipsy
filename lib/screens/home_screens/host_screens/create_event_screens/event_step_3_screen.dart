import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:ultra_map_place_picker/ultra_map_place_picker.dart';

import '../../../../utils/constants.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  bool isAddressVisible = false;
  final String apiKey = "AIzaSyAgMuRPnAf9vv8APMnuGDjgohOzaLUoCIE";
  final TextEditingController dateOfBirthController =
      TextEditingController(text: "adsads");

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                SizedBox(
                  width: 90.w,
                  height:
                      60.h, // Reduced height to leave space for other elements
                  child: UltraMapPlacePicker(
                      googleApiKey: apiKey,
                      initialPosition:
                          LocationModel(25.1974767426511, 55.279669543133615),
                      mapTypes: (isHuaweiDevice) => isHuaweiDevice
                          ? [UltraMapType.normal]
                          : UltraMapType.values,
                      myLocationButtonCooldown: 1,
                      resizeToAvoidBottomInset: false,
                      onPlacePicked: (place) {
                        print("Place picked: ${place.formattedAddress}");
                        // Handle the picked place
                      },
                      selectedPlaceWidgetBuilder: (BuildContext context,
                          PickResultModel? selectedPlace,
                          SearchingState state,
                          bool isSearchBarFocused) {
                        return Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedPlace?.formattedAddress ??
                                      'No place selected',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                if (selectedPlace != null)
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle the selection here
                                      print(
                                          "Selected place: ${selectedPlace.formattedAddress}");
                                      // You can also update your state or navigate to another screen here
                                    },
                                    child: Text('Confirm Selection'),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                      showPickedPlace: true),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Want address to be visible",
                            style: TextStyle(
                              color: primaryDark,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.help_outline,
                              color: primaryPink, size: 14.sp),
                          Spacer(),
                          Switch(
                            value: isAddressVisible,
                            onChanged: (value) {
                              setState(() {
                                isAddressVisible = value;
                              });
                            },
                            activeColor: primaryOrange,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 10),
                              blurRadius: 6,
                            ),
                          ],
                          border: Border.all(color: primaryDark, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      "Date",
                                      style: TextStyle(
                                        color: primaryDark,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.date_range_sharp,
                                    color: primaryDark,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 7.w),
                                child: TextFormField(
                                  controller: dateOfBirthController,
                                  readOnly: true,
                                  textAlign: TextAlign.left,
                                  onTap: () async {
                                    // Show date picker (your existing code)
                                  },
                                  style: TextStyle(
                                    color: primaryDark,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right,
                              color: primaryDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
