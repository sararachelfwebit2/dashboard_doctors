import 'package:dashboard_doctors/models/product.dart';
import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:dashboard_doctors/screens/login/login_page.dart';
import 'package:dashboard_doctors/services/garmin_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';


import 'screens/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAvrigJzeQ8fIERQ-6ZlGcwdgl2SHzn-i4",
        authDomain: "leema-4989e.firebaseapp.com",
        projectId: "leema-4989e",
        storageBucket: "leema-4989e.appspot.com",
        messagingSenderId: "690727390692",
        appId: "1:690727390692:web:4c2c1182057c4a22c70bf1",
        measurementId: "G-170HXX1D7R"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return MultiProvider(
        providers: [
    //     ChangeNotifierProvider<UserStats>(
    //     create: (context) => UserStats(),
    // ),
    // ChangeNotifierProvider<UserServices>(
    // create: (context) => UserServices(),
    // ),
    ChangeNotifierProvider<Products>(
    create: (context) => Products(),
    ),
    // ChangeNotifierProvider<Stories>(
    // create: (context) => Stories(),
    // ),
    ChangeNotifierProvider<Questionnaires>(
    create: (context) => Questionnaires(),
    ),
    // ChangeNotifierProvider<UserServices>(
    // create: (context) => UserServices(),
    // ),
    // ChangeNotifierProvider<ImageServices>(
    // create: (context) => ImageServices(),
    // ),
    // ChangeNotifierProvider<AuthVerfication>(
    // create: (context) => AuthVerfication(),
    // ),
    ChangeNotifierProvider(
    create: (context) => GarminServices(),
    ),
    ],
      child:
      MaterialApp(
      title: 'dashboard doctors',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('he'),
      ],
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFF4E7AC7,
          Map.from(
            {
              50: const Color.fromARGB(100, 78, 122, 199),
              100: const Color.fromARGB(100, 78, 122, 199),
              200: const Color.fromARGB(100, 78, 122, 199),
              300: const Color.fromARGB(100, 78, 122, 199),
              400: const Color.fromARGB(100, 78, 122, 199),
              500: const Color.fromARGB(100, 78, 122, 199),
              600: const Color.fromARGB(100, 78, 122, 199),
              700: const Color.fromARGB(100, 78, 122, 199),
              800: const Color.fromARGB(100, 78, 122, 199),
              900: const Color.fromARGB(100, 78, 122, 199),
            },
          ),
        ),
      ),
      home:  Scaffold( body: HomePage()),
    ));
  }
}

