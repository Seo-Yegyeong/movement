import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controller/profile_controller.dart';
import 'pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Movement for Nature',
      theme: ThemeData(
          primaryColor: Color(0xFF0F3174),
          bottomAppBarColor: Color(0xFFFCDF46),
          appBarTheme: AppBarTheme(
            color: Color(0xFF0F3174),
          ),
          hoverColor: Color(0xFFF0F0F0),
          splashColor: Color(0xFFA1E3FF),
          //textTheme: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.headline5, fontSize: 20, fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),
          //https://pub.dev/packages/google_fonts
          textTheme: GoogleFonts.imprimaTextTheme(
            Theme.of(context).textTheme,
          )
      ),
      //home: const ChallengePage(),
      initialBinding: BindingsBuilder(
          (){
            Get.lazyPut<ProfileController>(() => ProfileController());
          }
      ),
      initialRoute: '/home',
      routes: {
        //'/': (BuildContext context) => const initialScreen(),
        '/home': (BuildContext context) => const Authentication(),

      },
    );
  }
  //   return MaterialApp(
  //     title: 'Movement for Nature',
  //     theme: ThemeData(
  //       primaryColor: Color(0xFF0F3174),
  //       bottomAppBarColor: Color(0xFFFCDF46),
  //       appBarTheme: AppBarTheme(
  //         color: Color(0xFF0F3174),
  //       ),
  //       hoverColor: Color(0xFFF0F0F0),
  //       splashColor: Color(0xFFA1E3FF),
  //       //textTheme: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.headline5, fontSize: 20, fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),
  //       //https://pub.dev/packages/google_fonts
  //       textTheme: GoogleFonts.imprimaTextTheme(
  //         Theme.of(context).textTheme,
  //       )
  //     ),
  //     //home: const ChallengePage(),
  //     initialRoute: '/home',
  //     routes: {
  //       //'/': (BuildContext context) => const initialScreen(),
  //       '/home': (BuildContext context) => const Authentication(),
  //
  //     },
  //   );
  // }
}

// class initialScreen extends StatelessWidget {
//   const initialScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     if(user == null)
//       //Navigator.defaultRouteName;
//       return LoginPage();
//     return ChallengePage();
//   }
// }
