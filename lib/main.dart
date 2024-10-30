import 'package:flutter/material.dart';
import 'package:flutter_hashmicro_test/module/screen/geo_tagging.dart';
import 'package:get/get.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Geo Tagging',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      home: const  GeoTagging(),
    );
  }
}
