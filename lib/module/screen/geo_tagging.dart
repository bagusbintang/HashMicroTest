import 'package:flutter/material.dart';
import 'package:flutter_hashmicro_test/common/widget/custom_button_widget.dart';
import 'package:flutter_hashmicro_test/module/controller/geo_tagging_controller.dart';
import 'package:get/get.dart';

class GeoTagging extends StatelessWidget {
  const GeoTagging({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeoTaggingController>(
      init: GeoTaggingController(),
      builder: (GeoTaggingController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'GeoTagging',
            ),
          ),
          body: _body(controller),
        );
      },
    );
  }

  Widget _body(GeoTaggingController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('Check in Location'),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: Get.width,
            child: Obx(
              () => Slider(
                value: controller.sliderVal.value,
                max: 50,
                divisions: 5,
                label: controller.sliderVal.value.round().toString(),
                onChanged: (double value) {
                  controller.changeSlideValue(value);
                },
              ),
            ),
          ),
          Obx(
            () {
              if (controller.mapLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  Wrap(
                    spacing: 2,
                    runSpacing: 2,
                    // ignore: prefer_const_constructors
                    children: controller.listMark
                        .map(
                          (marker) => Text(
                              'Jarak dari lokasi ke point ${marker.infoWindow.title}: ${controller.calculateDistance(
                                    controller.currentPosition!.latitude,
                                    controller.currentPosition!.longitude,
                                    marker.position.latitude,
                                    marker.position.longitude,
                                  ).round()} Meters \n'),
                        )
                        .toList(),
                  ),
                  // AspectRatio(
                  //     aspectRatio: 9 / 16,
                  //     child:
                  //         // GoogleMap(
                  //         //   onMapCreated: controller.onMapCreated,
                  //         //   initialCameraPosition: CameraPosition(
                  //         //     target: controller.center!,
                  //         //     zoom: 15.0,
                  //         //   ),
                  //         //   markers:controller.setMarker,
                  //         // ),
                  //         Container(
                  //       color: Colors.grey,
                  //     )),
                ],
              );
            },
          ),
          CustomButtonWidget(
            title: 'Set Location',
            onPressed: () {
              controller.setNewMarker();
            },
          ),
          CustomButtonWidget(
            title: 'Check - In',
            onPressed: () {
              controller.checkinPoint();
            },
          ),
        ],
      ),
    );
  }
}


