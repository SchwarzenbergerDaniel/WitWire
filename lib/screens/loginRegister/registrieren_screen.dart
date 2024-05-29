// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/inputfield.dart';
import 'package:witwire/logik/user_auth.dart';
import 'package:witwire/screens/loginRegister/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _beschreibungController = TextEditingController();
  final _usernameController = TextEditingController();
  Uint8List? _image;

  bool loading = false;
  String errorMessage = "";
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _beschreibungController.dispose();
  }

  selectImage(ImageSource src) async {
    final ImagePicker pick = ImagePicker();
    XFile? file = await pick.pickImage(source: src);
    if (file != null) {
      return await file.readAsBytes();
    }
  }

  void chooseImageFromGallery() async {
    Uint8List img = await selectImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void register() async {
    String response;
    if (_image != null) {
      setState(() {
        loading = true;
      });
      response = await AuthMethods.createNewUser(
          email: _emailController.text,
          password: _passwordController.text,
          username: _usernameController.text,
          beschreibung: _beschreibungController.text,
          file: _image!);
    } else {
      response = "Wähle ein Bild!";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response),
    ));

    setState(() {
      loading = false;
    });

    if (response == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: loginRegisterBackgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //bild
              SizedBox(height: 32),
              SvgPicture.asset('assets/logo.svg', height: 128),

              const SizedBox(height: 32),

              //Profilbild.
              Stack(children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSibZzICT3UJ_BuQBQZehq1tmBwrWZ6v7-rSQ&s'),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () {
                      chooseImageFromGallery();
                    },
                    icon: const Icon(Icons.add_a_photo),
                  ),
                ),
              ]),
              const SizedBox(height: 32),

              //username
              TextInput(
                hintText: "Benutzername",
                inputType: TextInputType.text,
                controller: _usernameController,
              ),
              const SizedBox(height: 16),

              //email
              TextInput(
                hintText: "E-Mail",
                inputType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(height: 16),

              //passwort
              TextInput(
                hintText: "Passwort",
                inputType: TextInputType.text,
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 16),

              //Bio
              TextInput(
                hintText: "Deine persönliche Beschreibung",
                inputType: TextInputType.text,
                controller: _beschreibungController,
              ),
              const SizedBox(height: 16),
              //Login button
              GestureDetector(
                onTap: () {
                  register();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                      color: loginRegisterSubmitbuttonColor,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: !loading
                      ? const Text(
                          'Registriere',
                          style: TextStyle(color: loginRegisterButtonTextColor),
                        )
                      : const CircularProgressIndicator(
                          color: brightColor,
                        ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(height: 32),

              //Registrieren
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Du hast bereits einen Account? ",
                        style: TextStyle(color: Colors.grey)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Container(
                      child: const Text(
                        "Meld dich hier an!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
