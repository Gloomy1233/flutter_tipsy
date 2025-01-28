import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ultra_map_place_picker/ultra_map_place_picker.dart';

import '../../../../utils/constants.dart';
import '../../../../viewmodels/create_event_view_model.dart';

class EventStep2Screen extends StatefulWidget {
  const EventStep2Screen({super.key});

  @override
  State<EventStep2Screen> createState() => EventStep2ScreenState();
}

class EventStep2ScreenState extends State<EventStep2Screen> {
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
    final partyProvider = Provider.of<CreateEventViewModel>(context);
    return FutureBuilder<bool>(
      future: _requestLocationPermission(), // your permission logic
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Still checking permission
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == true) {
          // Permission granted, show map
          return Container(
            decoration: BoxDecoration(
                border: Border.all(color: primaryDark, width: 1.w)),
            width: 90.w,
            height: 50.h, // Reduced height to leave space for other elements
            child: UltraMapPlacePicker(
                outsideOfPickAreaText:
                    "Find the address of the event on the map",
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
                },
                selectedPlaceWidgetBuilder: (BuildContext context,
                    PickResultModel? selectedPlace,
                    SearchingState state,
                    bool isSearchBarFocused) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final GeoFirePoint location = GeoFirePoint(GeoPoint(
                        selectedPlace!.geometry!.location.lat,
                        selectedPlace!.geometry!.location.lng));

                    context.read<CreateEventViewModel>().location =
                        location.data;

                    context.read<CreateEventViewModel>().address =
                        selectedPlace!.formattedAddress.toString();
                  });

                  return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: 100.w,
                      height: 20.h,
                      color: primaryDark,
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              selectedPlace?.formattedAddress ??
                                  'No place selected',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = gradient.createShader(
                                    Rect.fromLTWH(
                                      0.0,
                                      0.0,
                                      MediaQuery.of(context).size.width,
                                      MediaQuery.of(context).size.height,
                                    ),
                                  ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            direction: Axis.vertical,
                            children: [
                              Text(
                                "Visible Address",
                                style: TextStyle(
                                  color: primaryPink,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Switch(
                                    value: isAddressVisible,
                                    onChanged: (value) {
                                      setState(() {
                                        isAddressVisible = value;
                                        partyProvider.isAddressVisible = value;
                                      });
                                    },
                                    activeColor: primaryOrange,
                                  ),
                                  Icon(Icons.help_outline,
                                      color: primaryPink, size: 14.sp),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                showPickedPlace: true),
          );
        } else {
          // Permission denied
          return Center(child: Text("Location permission not granted"));
        }
      },
    );
  }

  Future<bool> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else {
      // Request permission
      var result = await Permission.location.request();
      return result.isGranted;
    }
  }
}
