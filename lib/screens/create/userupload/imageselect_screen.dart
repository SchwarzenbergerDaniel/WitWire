import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:witwire/main.dart';
import 'package:witwire/screens/create/userupload/userupload_screen.dart';

class UploadImageSelectScreen extends StatefulWidget {
  const UploadImageSelectScreen({super.key});

  @override
  State<UploadImageSelectScreen> createState() =>
      UploadImageSelectScreenState();
}

//TODO: Nachdem das Bild ausgewählt worden ist zu UserUploadScreen
class UploadImageSelectScreenState extends State<UploadImageSelectScreen> {
  Uint8List? _selectedImage;

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.5;
    if (imageWidth > 175) {
      imageWidth = 175;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/appbar-image.png',
            fit: BoxFit.fill, width: imageWidth),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Bild:
          Center(
            child: _selectedImage == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _selectImageFromGallery,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.4, // 40% of screen width
                          height: MediaQuery.of(context).size.width *
                              0.4, // Maintain aspect ratio
                          child: Image.asset(
                            "assets/select-image.png",
                            fit: BoxFit
                                .cover, // Ensures the image fits within the box
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Space between the images
                      InkWell(
                        onTap: _selectImageFromCamera,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.4, // 40% of screen width
                          height: MediaQuery.of(context).size.width *
                              0.4, // Maintain aspect ratio
                          child: Image.asset(
                            "assets/camera-image.jpg",
                            fit: BoxFit
                                .cover, // Ensures the image fits within the box
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image.memory(
                      _selectedImage!,
                    ),
                  ),
          ),

          const SizedBox(height: 20),
          //Button zum hochladen
          _selectedImage != null
              ? ElevatedButton(
                  onPressed: _goToUpload,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text(
                    "Post",
                  ),
                )
              : const SizedBox(height: 0, width: 0),

          _selectedImage != null
              ? Column(
                  children: [
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _removeImage,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text(
                        "Entferne Bild",
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  void _goToUpload() {
    if (_selectedImage != null) {
      navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
        builder: (context) => UserUploadScreen(image: _selectedImage!),
      ));
    }
  }

  void _selectImageFromGallery() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;
    Uint8List? a = await img?.readAsBytes();
    setState(() {
      _selectedImage = a!;
    });
  }

  void _selectImageFromCamera() async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    if (img == null) return;
    Uint8List? a = await img?.readAsBytes();
    setState(() {
      _selectedImage = a!;
    });
  }

  void _removeImage() async {
    setState(() {
      _selectedImage = null;
    });
  }
}
