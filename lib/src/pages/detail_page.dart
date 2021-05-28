import 'dart:io';
// import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:google_ml_kit/google_ml_kit.dart';


class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  final String imagePath = Get.arguments;
  // Size _imageSize; 
  String recognizedText = 'Loading ...';

  TextDetector textDetector = GoogleMlKit.vision.textDetector();

  void _initializeVision() async {
    // Initialize the text recognizer
    final File imageFile = File(imagePath);
    final InputImage _image = InputImage.fromFilePath(imagePath);

    // if ( imageFile != null ) {
    //   await _getImageSize(imageFile);
    // }

    final  _recognisedText = await textDetector.processImage(_image);
    // if (_image.inputImageData?.size != null &&
    //     _image.inputImageData?.imageRotation != null) {
    //   final painter = TextDetectorPainter(
    //       recognisedText,
    //       _image.inputImageData!.size,
    //       _image.inputImageData!.imageRotation);
    //   customPaint = CustomPaint(painter: painter);
    // } else {
    //   customPaint = null;
    // }
    // isBusy = false;
    // Obtener el texto resultado ! 
    // String text = '';
    // for ( TextBlock block in visionText.blocks ) {
    //   for ( TextLine line in block.textLines ) {
    //     text += line.lineText + '\n';
    //   }
    // }
    print(_recognisedText.text);
    if ( this.mounted ) {
      setState(() {
        recognizedText = _recognisedText.text; 
      });
    }
  }

  // Future<void> _getImageSize( File imageFile ) async {

  //   final Completer<Size> completer = Completer<Size>();
  //   // Fetching image from path 
  //   final Image image = Image.file(imageFile);
  //   // Retrieving its size
  //   image.image.resolve(const ImageConfiguration() ).addListener(
  //     ImageStreamListener((ImageInfo info, bool _) {
  //       completer.complete(Size(
  //         info.image.width.toDouble(),
  //         info.image.height.toDouble()
  //       ));
  //     })
  //   );

  //   final Size imageSize = await completer.future; 
  //   setState(() {
  //     _imageSize = imageSize; 
  //   });

  // }

  @override
  void initState() { 
    _initializeVision();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                  elevation: 8,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Identified emails",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          height: 60,
                          child: SingleChildScrollView(
                            child: Text(
                              recognizedText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
       
    );
  }
}