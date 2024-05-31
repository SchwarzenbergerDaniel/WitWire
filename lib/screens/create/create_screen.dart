import 'package:flutter/material.dart';
import 'package:witwire/screens/create/show_next_upload_screen.dart';
import 'package:witwire/screens/create/userupload/imageselect_screen.dart';

// ignore: must_be_immutable
class CreateScreen extends StatefulWidget {
  late bool userNeedsToUpload;

  CreateScreen({super.key, required this.userNeedsToUpload});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  _CreateScreenState();

  @override
  Widget build(BuildContext context) {
    if (widget.userNeedsToUpload) {
      return const UploadImageSelectScreen();
    }
    return const ShowNextUploadScreen();
  }
}
