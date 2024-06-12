import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:witwire/logik/queryhelper.dart';
import 'package:witwire/main.dart';
import 'package:witwire/screens/create/userupload/userupload_screen.dart';
import 'package:witwire/utils/colors.dart';

class UploadImageSelectScreen extends StatefulWidget {
  UploadImageSelectScreen({Key? key}) {
    QueryHelper.initQueryHelper();
  }

  @override
  State<UploadImageSelectScreen> createState() =>
      UploadImageSelectScreenState();
}

class UploadImageSelectScreenState extends State<UploadImageSelectScreen> {
  Uint8List? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadGalleryImage();
  }

  void _loadGalleryImage() async {
    final galleryImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (galleryImage != null) {
      final bytes = await galleryImage.readAsBytes();
      _selectedImage = bytes;
      _imageSelected();
    }
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.5;
    if (imageWidth > 175) {
      imageWidth = 175;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        centerTitle: true,
        title: Image.asset('assets/appbar-image.png',
            fit: BoxFit.fill, width: imageWidth),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _loadGalleryImage(),
          child: const Text("Wähle Bild"),
        ),
      ),
    );
  }

  void _imageSelected() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserUploadScreen(image: _selectedImage!),
      ),
    );
  }
}
