import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hashmicro_test/common/widget/custom_button_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoTaggingController extends GetxController {
  GoogleMapController? mapController;
  LatLng? center;
  Position? currentPosition;

  TextEditingController namaJalanController = TextEditingController(text: '');

  List<Marker> listMark = [
    Marker(
      markerId: const MarkerId('Map point 1'),
      position: const LatLng(-6.313526, 106.689193),
      infoWindow: const InfoWindow(title: 'Kampus Bina Bakti'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
    Marker(
      markerId: const MarkerId('Map point 2'),
      position: const LatLng(-6.313573, 106.689123),
      infoWindow: const InfoWindow(title: 'Damping mart'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: const MarkerId('Map point 3'),
      position: const LatLng(-6.312511, 106.690799),
      infoWindow: const InfoWindow(title: 'Kedai Tembakau'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ),
  ];

  Set<Marker> setMarker = {};

  final mapLoading = false.obs;

  final sliderVal = 0.0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserLocation();
    setMarker.addAll(listMark);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    if (mapController != null) {
      mapController!.dispose();
    }
    namaJalanController.dispose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getUserLocation() async {
    print('Masuk sini ga');
    mapLoading.value = true;
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }
    currentPosition = await Geolocator.getCurrentPosition();
    center = LatLng(currentPosition!.latitude, currentPosition!.longitude);
    print('Check location position : $currentPosition');
    mapLoading.value = false;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p =
        0.017453292519943295; //conversion factor from radians to decimal degrees, exactly math.pi/180
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var radiusOfEarth = 6371;
    return 1000 * radiusOfEarth * 2 * asin(sqrt(a));
  }

  void changeSlideValue(double value) {
    print("value terganti ya : $value");
    sliderVal.value = value;
  }

  void setNewMarker() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      // isDismissible: true,
      backgroundColor: Colors.white,
      constraints: BoxConstraints(
        maxWidth: Get.width,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),

      builder: (context) {
        // return CommentScreen(news: news);
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16),
          child: DraggableScrollableSheet(
            maxChildSize: .50,
            minChildSize: .50,
            initialChildSize: .50,
            snap: false,
            expand: false,
            controller: DraggableScrollableController(),
            builder: (context, scrollController) {
              return SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Input Nama Jalan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: namaJalanController,
                    ),
                    CustomButtonWidget(
                      title: 'Save',
                      onPressed: () {
                        listMark.add(
                          Marker(
                            markerId:
                                MarkerId('Map point ${listMark.length + 1}'),
                            position: LatLng(currentPosition!.latitude,
                                currentPosition!.longitude),
                            infoWindow:
                                InfoWindow(title: namaJalanController.text),
                            // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                          ),
                        );
                        namaJalanController.clear();
                        update();
                        setMarker.clear();
                        setMarker.addAll(listMark);
                        Get.back();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void checkinPoint() async {
    for (var mark in listMark) {
      final distance = calculateDistance(
        currentPosition!.latitude,
        currentPosition!.longitude,
        mark.position.latitude,
        mark.position.longitude,
      );
      if (distance < sliderVal.value) {
        print('MUASOKKK MAS BROO !! ${mark.infoWindow.title}');
        await showDialog(
          context: Get.context!,
          builder: (context) {
            return  AlertDialog(
              content: Text('Wow, Anda berhasil check - in di tempat ${mark.infoWindow.title} .'),
            );
          },
        );
        return;
      } else {
        await showDialog(
          context: Get.context!,
          builder: (context) {
            return  const AlertDialog(
              content: Text('Maaf, Anda tidak berhasil check - in karena terlalu jauh. Coba perpanjang jarak'),
            );
          },
        );
        return;
      }
    }
  }
}
