import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movement/home.dart';
import 'package:movement/util/size.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  //참고 링크
  //https://web.archive.org/web/20220116095507/https://firebase.flutter.dev/docs/auth/usage/
  // CollectionReference database = FirebaseFirestore.instance.collection('user');
  // late QuerySnapshot querySnapshot;

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
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFA1E3FF),
            Color(0xFF032837),
          ],
        )),
        child: Column(
          children: [
            SizedBox(
              height: getScreenHeight(context) * 0.15,
            ),
            Text(
              "Movement",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 40),
            ),
            ElevatedButton(
              onPressed: () async {
                final UserCredential userCredential = await signInWithGoogle();

                User? user = userCredential.user;

                // if (user != null) {
                //   int i;
                //   querySnapshot = await database.get();
                //
                //   for (i = 0; i < querySnapshot.docs.length; i++) {
                //     var a = querySnapshot.docs[i];
                //
                //     if (a.get('uid') == user.uid) {
                //       break;
                //     }
                //   }
                //
                //   if (i == (querySnapshot.docs.length)) {
                //     database.doc(user.uid).set({
                //       'email': user.email.toString(),
                //       'name': user.displayName.toString(),
                //       'uid': user.uid,
                //     });
                //   }
                if (user != null)
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ChallengePage(),
                    ),
                  );
              },
              child: Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Image.asset('assets/image/google_logo.png')),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'GOOGLE',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFED9595),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
