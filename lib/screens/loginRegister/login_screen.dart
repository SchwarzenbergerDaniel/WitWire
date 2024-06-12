import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:witwire/firebaseParser/user_data.dart';
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
  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isloading = false;
  @override
  void dispose() {
    super.dispose();
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
  }

  Future<String?> getEmail() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: _emailOrUsernameController.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      //Ist eine Nutzername eingabe
      final userDoc = querySnapshot.docs.first;
      return userDoc['email'];
    } else {
      return _emailOrUsernameController.text;
    }
  }

  void login() async {
    setState(() {
      isloading = true;
    });
    String password = _passwordController.text;
    String? email = await getEmail();
    String response = "User doesnt exist";
    if (email != null) {
      response = await AuthMethods.login(email, password);
    }
    setState(() {
      isloading = false;
    });
    if (response != "success" && response != "success") {
      // ignore: use_build_context_synchronously
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
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //bild
                  SvgPicture.asset('assets/logo.svg', height: 128),
                  const SizedBox(height: 64),

                  // email
                  TextInput(
                    hintText: "Benutzername oder E-Mail",
                    inputType: TextInputType.emailAddress,
                    controller: _emailOrUsernameController,
                  ),
                  const SizedBox(height: 16),

                  // password
                  TextInput(
                    hintText: "Passwort",
                    inputType: TextInputType.text,
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),

                  // Login button
                  GestureDetector(
                    onTap: () => login(),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        color: loginRegisterSubmitbuttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      child: !isloading
                          ? const Text(
                              style: TextStyle(
                                color: loginRegisterButtonTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              "Log in",
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Register section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Noch keinen Account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Registriere dich!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
