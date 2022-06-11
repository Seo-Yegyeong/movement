import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movement/pages/home/home.dart';
import 'package:movement/util/size.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CollectionReference database = FirebaseFirestore.instance.collection('user');
  late QuerySnapshot querySnapshot;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.1),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFA1E3FF),
            Color(0xFFA1E3FF),
            Color(0xFFC2E5F3),
            Color(0xFFC2E5F3),
            Color(0xFFD7DEE1),
            Color(0xFFD7DEE1),
            Color(0xFF146C92),
            Color(0xFF032837),
            Color(0xFF032837),
          ],
        )),
        child: Column(
          children: [
            SizedBox(
              height: getScreenHeight(context) * 0.15,
            ),
            SvgPicture.asset(
              "assets/image/global.svg",

            ),
            Text(
              "Movement",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 40),
            ),
            SizedBox(
              height: getScreenHeight(context) * 0.15,
            ),
            ElevatedButton(
              onPressed: () async {
                final UserCredential userCredential = await signInWithGoogle();

                User? user = userCredential.user;

                if (user != null) {
                  int i;
                  querySnapshot = await database.get();

                  for (i = 0; i < querySnapshot.docs.length; i++) {
                    var a = querySnapshot.docs[i];

                    if (a.get('uid') == user.uid) {
                      break;
                    }
                  }

                  if (i == (querySnapshot.docs.length)) {
                    database.doc(user.uid).set({
                      'email': user.email.toString(),
                      'name': user.displayName.toString(),
                      'uid': user.uid,
                    });
                  }
                  if (user != null)
                    Get.to(Authentication());
                }
              },
              child: Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Image.asset('assets/image/google_logo.PNG'),),
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    '구글 로그인',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(getScreenWidth(context)*0.88, getScreenHeight(context)*0.1),
                primary: Color(0xFFffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 10
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if(!snapshot.hasData){
          return LoginPage();
        }
        else {
          return HomePage();
        }
      },
    );
  }
}

