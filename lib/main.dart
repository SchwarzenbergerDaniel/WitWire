import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:witwire/firebaseParser/user_data.dart';
import 'package:witwire/firebase_options.dart';
import 'package:witwire/logik/queryhelper.dart';
import 'package:witwire/logik/user_auth.dart';
import 'package:witwire/providers/newdayprovider.dart';
import 'package:witwire/screens/create/create_screen.dart';
import 'package:witwire/screens/home/home_screen.dart';
import 'package:witwire/screens/loginRegister/login_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  QueryHelper.initQueryHelper();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    NewDayProvider a = NewDayProvider();
    a.start(context);
    FirebaseAuth.instance.authStateChanges();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => a),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'WitWire',
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            print("TEST");
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.connectionState != ConnectionState.active) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = snapshot.data;
            if (user == null) {
              print("USER IS NULl");

              return const LoginScreen();
            }
            print("ZSER IS NOT NULL");
            return FutureBuilder(
              future: UserData.initLoggedInUser(),
              builder: (context2, valid) {
                if (valid.connectionState != ConnectionState.waiting) {
                  return FutureBuilder<bool>(
                    future: AuthMethods.uploadedToday(
                        UserData.currentLoggedInUser!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.waiting) {
                        bool? uploadToday = snapshot.data;
                        if (uploadToday == true) {
                          return const HomeScreen();
                        } else {
                          return CreateScreen(userNeedsToUpload: true);
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
