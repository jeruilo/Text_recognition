import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:text_recognition/src/controller/camera_controller.dart';

import 'package:text_recognition/src/models/camera.dart';

import 'package:text_recognition/src/pages/camera_page.dart';
import 'package:text_recognition/src/pages/detail_page.dart';
import 'package:text_recognition/src/pages/text_detector_view.dart';


List<CameraDescription> cameras = [];
// Ponemos el camCtrl en el context
final camCtrl = Get.put( CamController() );

Future<void> main() async{
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e);
  }
  // Añadimos la lista de cámaras al CamCtrl
  camCtrl.cargarCamaras(Camera(cameras: cameras));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text Recognizer',
      initialRoute: 'text_detector',
      // routes: {
      //   'camera': (_) => CameraPage(),
      // },
      getPages: [
        GetPage(name: 'camera', page: () => CameraPage() ),
        GetPage(name: 'detail', page: () => DetailPage() ),
        GetPage(name: 'text_detector', page: () => TextDetectorView())
      ],
    );
  }
}