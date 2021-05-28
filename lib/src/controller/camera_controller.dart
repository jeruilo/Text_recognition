import 'package:get/get.dart';
import 'package:camera/camera.dart';

import 'package:text_recognition/src/models/camera.dart';



class CamController extends GetxController {

  // Los hacemos observables
  var existeCamera = false.obs; 
  var camera = new Camera().obs;

  void cargarCamaras( Camera pCamera ) {
    this.existeCamera.value = true; 
    this.camera.value = pCamera;
  }

  void cambiarListaCamaras( List<CameraDescription> camera ) {
     this.camera.update((val) {
       val.cameras = camera;
     });
  }
}
