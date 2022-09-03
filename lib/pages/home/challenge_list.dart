import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movement/pages/home/challengeCard.dart';
import 'package:movement/util/storage_service.dart';

class ChallengeListPage extends StatefulWidget {
  const ChallengeListPage({Key? key}) : super(key: key);

  @override
  State<ChallengeListPage> createState() => _ChallengeListPageState();
}

class _ChallengeListPageState extends State<ChallengeListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_rounded), onPressed: (){
          Get.back();
        },),
        //SvgPicture.asset("assets/image/challenge.svg", color: Colors.white,),
        title: Text("CHALLENGE LIST", style: GoogleFonts.imprima(fontSize: 25)),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('/challenge').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());

                      return Column(
                        children: [
                          ElevatedButton(onPressed: (){

                          },
                              child: Text("챌린지 추가하기")),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    ChallengeCard(doc: snapshot.data!.docs[index], cardType: CardType.WIDE, contentType: ContentType.Challenge,),
                                    SizedBox(height: 10,),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("다른 챌린지 참여하기 > ",
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
