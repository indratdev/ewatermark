import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_watermark/image_watermark.dart';
// import 'package:image/image.dart' as ui;

import '../utilities/app_helper.dart';
import '../utilities/app_text_style.dart';

class EWatermarkScreen extends StatefulWidget {
  const EWatermarkScreen({Key? key}) : super(key: key);

  @override
  _EWatermarkScreenState createState() => _EWatermarkScreenState();
}

class _EWatermarkScreenState extends State<EWatermarkScreen> {
  final _picker = ImagePicker();
  CroppedFile? fileImage;
  var cropImageFile;

  var _image;
  var imageBytes;

  _getImageFrom({required ImageSource source}) async {
    final _pickedImage = await _picker.pickImage(source: source);
    if (_pickedImage != null) {
      var image = File(_pickedImage.path.toString());
      final _sizeInKbBefore = image.lengthSync() / 1024;
      print('Before Compress $_sizeInKbBefore kb');
      var _compressedImage = await AppHelper.compress(image: image);
      final _sizeInKbAfter = _compressedImage.lengthSync() / 1024;
      print('After Compress $_sizeInKbAfter kb');
      var _croppedImage = await AppHelper.cropImage(_compressedImage);
      if (_croppedImage == null) {
        return;
      }
      var t = await _croppedImage.readAsBytes();

      setState(() {
        fileImage = _croppedImage;

        _image = _croppedImage;

        imageBytes = Uint8List.fromList(t);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Image Crop & Compress Demo "),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (fileImage != null)
              Container(
                height: 350,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey,
                  image: DecorationImage(
                    image: FileImage(File(fileImage!.path)),
                    // image: Image.file(File(fileImage)),

                    fit: BoxFit.cover,
                  ),
                ),
                // child: Image(image: Image.file(File(fileImage!.path.toString()))),
              )
            else
              Container(
                height: 350,
                width: 350,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey[300],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: 150,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Image will be shown here",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    _openChangeImageBottomSheet();
                  },
                  child: const Text('Upload Image')),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "ISI TEXT WATERMARK",
                    labelText: "ISI TEXT WATERMARK",
                  ),
                ),
              ),
            ),
            (fileImage != null)
                ? ElevatedButton(
                    child: Text("Apply Watermark Over Image"),
                    onPressed: () async {
                      cropImageFile = await image_watermark.addTextWatermark(
                        imageBytes,
                        "watermarkText", //watermark text
                        0, //
                        0,
                        color: Colors.black,
                        //default : Colors.white
                      );
                      setState(() {});
                    },
                  )
                : Container(),
            (cropImageFile != null)
                ? Container(
                    height: 350,
                    width: 300,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.memory(cropImageFile),
                  )
                : Container(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  _openChangeImageBottomSheet() {
    return showCupertinoModalPopup(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(
              'Change Image',
              textAlign: TextAlign.center,
              style: AppTextStyles.regular(fontSize: 19),
            ),
            actions: <Widget>[
              _buildCupertinoActionSheetAction(
                icon: Icons.camera_alt,
                title: 'Take Photo',
                voidCallback: () {
                  Navigator.pop(context);
                  _getImageFrom(source: ImageSource.camera);
                },
              ),
              _buildCupertinoActionSheetAction(
                icon: Icons.image,
                title: 'Gallery',
                voidCallback: () {
                  Navigator.pop(context);
                  _getImageFrom(source: ImageSource.gallery);
                },
              ),
              _buildCupertinoActionSheetAction(
                title: 'Cancel',
                color: Colors.red,
                voidCallback: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _buildCupertinoActionSheetAction({
    IconData? icon,
    required String title,
    required VoidCallback voidCallback,
    Color? color,
  }) {
    return CupertinoActionSheetAction(
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: color ?? const Color(0xFF2564AF),
            ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.regular(
                fontSize: 17,
                color: color ?? const Color(0xFF2564AF),
              ),
            ),
          ),
          if (icon != null)
            const SizedBox(
              width: 25,
            ),
        ],
      ),
      onPressed: voidCallback,
    );
  }
}
