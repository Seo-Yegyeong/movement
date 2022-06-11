import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movement/pages/home/challengeCard.dart';
import 'package:movement/pages/home/challenge_list.dart';
import 'package:movement/pages/news/news.dart';
import 'package:movement/util/size.dart';
import '../account/account.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  //final storage = FirebaseStorage.instance;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(index == 0) {
      Get.to(NewsPage());
    } else if(index == 2) {
      Get.to(AccountPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference firestore = FirebaseFirestore.instance.collection('user').doc(user?.uid);
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('challenge').snapshots();

    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset("assets/image/challenge.svg", color: Colors.white,),
        title: Text("CHALLENGE", style: GoogleFonts.imprima(fontSize: 25)),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("도전 중인 챌린지",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(
                    height: getScreenHeight(context)*0.28,
                    child:
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('/challenge').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        // for(var item in firestore.get().)}
                        // for(var item in snapshot.data!.docs){
                        //   if(item[''])
                        // }
                        // 이 챌린지가 내 myChallenge 어레이 값에 있는가? 확인해보기!
                        // 있으면 아래 거 리턴, 없으면 패쓰!

                        // FirebaseFirestore.instance.collection('user').doc(user!.uid).get().then((DocumentSnapshot documentSnapshot){
                        //   documentSnapshot['myChallenge'].forEach((item){
                        //     // for(var temp in snapshot.data!.docs){
                        //     //print("check : " + temp['docID']);
                        //     return (snapshot.data!.docs[index]['docID'].toString().compareTo(item.toString())==0)?
                        //         Row(
                        //           children: [
                        //             ChallengeCard(doc: snapshot.data!.docs[index], type: CardType.NARROW,),
                        //             SizedBox(width: 1,),
                        //           ],
                        //         ) :
                        //         Text("hi");
                        //     //}
                        //   });
                        //   //print("여기야 여기~~!");
                        // print(item);
                        // print(snapshot.data!.docs[index]['docID']);
                        // print("======same======");
                        // if(snapshot.data!.docs[0]['docID'] == item)
                        // });

                        return Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //RxBool same = false.obs;
                                  return Row(
                                        children: [
                                          ChallengeCard(doc: snapshot.data!.docs[index], cardType: CardType.NARROW, contentType: ContentType.Challenge,),
                                          SizedBox(width: 1,),
                                        ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.to(()=> ChallengeListPage());
                        },
                        child: Text("다른 챌린지 보기 > ",
                        style: TextStyle(
                          fontSize: 16
                        ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("함께 도전하기",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                    height: getScreenHeight(context)*0.28,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('/group').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator());

                        return Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ChallengeCard(doc: snapshot.data!.docs[index], cardType: CardType.NARROW, contentType: ContentType.Group,);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("새 그룹 만들기 + ",
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/news.svg",
              color: (_selectedIndex == 0)? Color(0xFF0F3174) : Colors.black12,
            ),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/challenge.svg",
              color: (_selectedIndex == 1)? Color(0xFF0F3174) : Colors.black12,
            ),
            label: 'Challenge',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/account.svg",
              color: (_selectedIndex == 2)? Color(0xFF0F3174) : Colors.black12,
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
