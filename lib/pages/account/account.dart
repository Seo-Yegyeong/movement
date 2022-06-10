import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movement/pages/news/news.dart';
import 'package:movement/util/storage_service.dart';
import '../home/home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User? user = FirebaseAuth.instance.currentUser;
  //final whoAmI = FirebaseFirestore.instance.collection('user').where("uid", isEqualTo: user?.uid);

  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const NewsPage(),
        ),
      );
    else if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }


  Widget _profileImage() {
    final Storage storage = Storage();
    return Container(width: 120, height: 120, decoration: BoxDecoration(
    ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child:
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('/user').where("name", isEqualTo: user?.displayName).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              print("Here~~~~~~!!");
              print(snapshot.data!.docs[0]['uid']);
              return FutureBuilder(
                    future: storage.downloadURL("user", snapshot.data?.docs.first['uid'] + ".jpg"),
                    builder: (BuildContext context,
                        AsyncSnapshot<String> snap) {
                      if (snap.connectionState ==
                          ConnectionState.done &&
                          snap.hasData) {
                        return Container(
                          width: 300,
                          height: 250,
                          child: Image.network(
                            snap.data!,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      if (snap.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Image.network('https://i.stack.imgur.com/l60Hf.png', fit: BoxFit.cover);
                    },
                  );
            },
          ),
        ),
    );
  }

  Widget _myProfile() {
    return Container(
      height: 150,
      child: Column(
        children: [
          _profileImage(),
          //_profileInfo(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? name = user?.displayName;
    // final user_doc = FirebaseFirestore.instance.collection('/user').where("name", isEqualTo: user?.displayName);

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("MOVEMENT", style: GoogleFonts.imprima(fontSize: 25))),
        actions: [
          Icon(
            Icons.email,
            size: 40,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Text(
              "MOVEMENT!",
              style: optionStyle,
            )),
            ListTile(
              leading: Icon(Icons.thumb_up_alt_rounded),
              title: Text("~~~"),
            )
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              _myProfile(),
              Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText("안녕하세요! " + "$name" + "님,", textStyle: TextStyle(fontSize: 20)),
                    WavyAnimatedText("오늘도 지구를 지켜주셔서 감사합니다!", textStyle: TextStyle(fontSize: 20)),
                  ],
                  isRepeatingAnimation: true,
                ),
              ),
              Divider(thickness: 1,),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/news.svg",
              color: (_selectedIndex == 0) ? Color(0xFF0F3174) : Colors.black12,
            ),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/challenge.svg",
              color: (_selectedIndex == 1) ? Color(0xFF0F3174) : Colors.black12,
            ),
            label: 'Challenge',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/account.svg",
              color: (_selectedIndex == 2) ? Color(0xFF0F3174) : Colors.black12,
            ),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF0F3174),
        onTap: _onItemTapped,
        backgroundColor: Color(0xFFffffff),
      ),
    );
  }
}
