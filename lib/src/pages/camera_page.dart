import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


import 'package:text_recognition/src/controller/camera_controller.dart';
import 'package:text_recognition/src/models/camera.dart';


class CameraPage extends StatefulWidget {
  
  // Inicializamos una instancia de Camera
  final Camera camera;
  const CameraPage({Key key, this.camera}) : super(key: key);


  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  CameraController _controller; 


  @override
  void initState() { 
    super.initState();
    
    // Buscamos LA instancia de camCtrl
    final camCtrl = Get.find<CamController>();
    // Asignamos el valor actual en camCtrl de cámara 
    final _camera = camCtrl.camera.value;

    _controller = CameraController(_camera.cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if( !mounted ) {
        return;
      }
      setState(() { });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('ML Vision'),
      ),

      body: _controller.value.isInitialized
          ? Stack(
              children: [
                CameraPreview(_controller),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.camera),
                      label: Text('Take a picture'),
                      onPressed: () async{
                        await _takePicture().then((String path) {
                          if ( path != null ) {
                            Get.toNamed(
                              'detail',
                              arguments: path);
                          }
                        });
                      }),
                  ))
              ])
          : Container( 
              color: Colors.black,
              child: Center(child: CircularProgressIndicator()),
          )
    );
  }



  Future<String> _takePicture( ) async{
    // Checking whether the controller is initialized
    if( !_controller.value.isInitialized ) {
      print('Controller not initialized');
      return null; 
    }

    // Formatting date and time
    String dateTime = DateFormat.yMMMd()
      .addPattern('-')
      .add_Hms()
      .format(DateTime.now())
      .toString();


    String formattedDateTime = dateTime.replaceAll(' ', '');
    print('Formatted dateTime: $formattedDateTime');

    // Retrieving the path for saving an image
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

    // Checking whether the picture is being taken
    // to prevent execution of the function again
    // if previous execution has not ended
    if (_controller.value.isTakingPicture) {
      print("Processing is in progress...");
      return null;
    }

    try {
      // Captures the image and saves it to the
      // provided path
      await _controller.takePicture();
    }  on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }
    print(imagePath);
    return imagePath;


  }
}