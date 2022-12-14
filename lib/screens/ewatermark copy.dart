import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as ui;

import '../utilities/constants.dart';

class EWatermark extends StatefulWidget {
  EWatermark({Key? key}) : super(key: key);

  @override
  State<EWatermark> createState() => _EWatermarkState();
}

class _EWatermarkState extends State<EWatermark> {
  TextEditingController textController = TextEditingController();
  File? _originalImage;
  File? _watermarkImage;
  File? _watermarkedImage;
  File? imageFile;
  final picker = ImagePicker();

  Future getOriginalImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _originalImage = File(pickedFile.path);
      }
    });
  }

  Future getWatermarkImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _watermarkImage = File(pickedFile.path);
      }
    });
  }

  // Future<File> drawTextOnImage() async {
  //   // var image = await ImagePicker.pickImage(source: ImageSource.camera);

  //   var decodeImg = img.decodeImage(image.readAsBytesSync());

  //   img.drawString(decodeImg, img.arial_48, 0, 0, DateTime.now().toString());

  //   var encodeImage = img.encodeJpg(decodeImg, quality: 100);

  //   var finalImage = File(image.path)..writeAsBytesSync(encodeImage);

  //   return finalImage;
  // }

  // /// Get from gallery
  // _getFromGallery() async {
  //   XFile? pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile.path);
  //     });
  //   }
  // }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              //<--------------- select original image ---------------->
              _originalImage == null
                  ? ElevatedButton(
                      child: Text("Select Original Image"),
                      onPressed: getOriginalImage,
                    )
                  : Image.file(_originalImage!),

              //<--------------- select watermark image ---------------->
              // _watermarkImage == null
              //     ? ElevatedButton(
              //         child: Text("Select Watermark Image"),
              //         onPressed: getWatermarkImage,
              //       )
              //     : Image.file(_watermarkImage!),

              SizedBox(
                height: 50,
              ),
              //<--------------- apply watermark over image ---------------->
              // (_originalImage != null) && (_watermarkImage != null)
              (_originalImage != null)
                  ? ElevatedButton(
                      child: Text("Apply Watermark Over Image"),
                      onPressed: () async {
                        ui.Image? originalImage =
                            ui.decodeImage(_originalImage!.readAsBytesSync());
                        // ui.Image? watermarkImage =
                        //     ui.decodeImage(_watermarkImage!.readAsBytesSync());

                        // add watermark over originalImage
                        // initialize width and height of watermark image
                        ui.Image image = ui.Image(160, 50);
                        // ui.drawImage(image, watermarkImage!);

                        // give position to watermark over image
                        // originalImage.width - 160 - 25 (width of originalImage - width of watermarkImage - extra margin you want to give)
                        // originalImage.height - 50 - 25 (height of originalImage - height of watermarkImage - extra margin you want to give)
                        ui.copyInto(originalImage!, image,
                            dstX: originalImage.width - 160 - 25,
                            dstY: originalImage.height - 50 - 25);

                        // for adding text over image
                        // Draw some text using 24pt arial font
                        // 100 is position from x-axis, 120 is position from y-axis
                        ui.drawString(originalImage, ui.arial_24, 100, 120,
                            'TEST REMAKSSSSssssssss');

                        // img.drawString(decodeImg, img.arial_48, 0, 0,
                        //     DateTime.now().toString());

                        // var encodeImage =
                        //     img.encodeJpg(decodeImg, quality: 100);

                        // var finalImage = File(image.path)
                        //   ..writeAsBytesSync(encodeImage);

                        // return finalImage;

                        // Store the watermarked image to a File
                        List<int> wmImage = ui.encodePng(originalImage);
                        setState(() {
                          _watermarkedImage =
                              File.fromRawPath(Uint8List.fromList(wmImage));
                        });
                      },
                    )
                  : Container(),

              //<--------------- display watermarked image ---------------->
              _watermarkedImage != null
                  ? Image.file(_watermarkedImage!)
                  : Container(),
            ],
          ),
        ),
      ),

      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: <Widget>[
      //     Container(
      //       width: double.infinity,
      //       color: Colors.amber,
      //       child: imageFile == null
      //           ? Container(
      //               alignment: Alignment.center,
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: <Widget>[
      //                   ElevatedButton(
      //                     // color: Colors.greenAccent,
      //                     onPressed: () {
      //                       _getFromGallery();
      //                     },
      //                     child: Text("PICK FROM GALLERY"),
      //                   ),
      //                   Container(
      //                     height: 40.0,
      //                   ),
      //                   ElevatedButton(
      //                     // color: Colors.lightGreenAccent,
      //                     onPressed: () {
      //                       _getFromCamera();
      //                     },
      //                     child: Text("PICK FROM CAMERA"),
      //                   )
      //                 ],
      //               ),
      //             )
      //           : Container(
      //               child: Image.file(
      //                 imageFile!,
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //     ),
      //   ],
      // ),
    );
  }
}
