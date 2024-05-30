import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:witwire/firebaseParser/userData.dart';
import 'package:witwire/logik/user_auth.dart';
import 'package:witwire/screens/create/create_screen.dart';
import 'package:witwire/screens/home/home_screen.dart';
import 'package:witwire/screens/loginRegister/registrieren_screen.dart';
import 'package:witwire/utils/colors.dart';
import 'package:witwire/widgets/inputfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isloading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void login() async {
    setState(() {
      isloading = true;
    });
    String mail = _emailController.text;
    String password = _passwordController.text;
    String response = await AuthMethods.login(mail, password);
    setState(() {
      isloading = false;
    });
    if (response != "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response),
        ),
      );
    } else {
      //Hat funktioniert.
      Widget startPoint;
      UserData.initLoggedInUser().then((valid) {
        AuthMethods.uploadedToday(UserData.currentLoggedInUser!)
            .then((bool uploadToday) {
          if (uploadToday) {
            startPoint = const HomeScreen();
          } else {
            startPoint = CreateScreen(
              userNeedsToUpload: true,
            );
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => startPoint),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: loginRegisterBackgroundColor,
      body: SafeArea(
        //       child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //bild
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset('assets/logo.svg', height: 128),

              const SizedBox(height: 64),
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

              //Login button
              GestureDetector(
                onTap: () => login(),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      color: loginRegisterSubmitbuttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)))),
                  child: !isloading
                      ? const Text(
                          style: TextStyle(color: loginRegisterButtonTextColor),
                          "Log in")
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              Flexible(
                flex: 2,
                child: Container(),
              ),

              //Registrieren

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Noch keinen Account?",
                        style: TextStyle(color: Colors.grey)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Registriere dich!",
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
      // ),
    );
  }
}
