import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movement/util/size.dart';
import 'package:movement/util/storage_service.dart';

import 'home.dart';

class ChallDetail extends StatelessWidget {
  const ChallDetail({Key? key, required this.doc}) : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            // Navigator.pop(context);
            Get.to(HomePage());
          },
        ),
        title: Center(
          child: Text(
            "DETAIL",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: 35,
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: _bodyCard(context),
    );
  }

  Widget _bodyCard(BuildContext context) {
    final Storage storage = Storage();

    return ListView(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getScreenWidth(context) * 0.05,
                vertical: getScreenHeight(context) * 0.03),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: const Color(0xffDFF6FF),
                child: Column(
                  children: [
                    SizedBox(
                      height: getScreenHeight(context) * 0.35,
                      width: getScreenWidth(context) * 0.9,
                      child: FutureBuilder(
                        future: storage.downloadURL("challenge", doc['image']),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done &&
                              snapshot.hasData) {
                            return Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          return Image.network(
                            "https://dt40dm21pj8em.cloudfront.net/uploads/froala/file/5336/%ED%99%98%EA%B2%BD%20%EA%B3%B5%EA%B8%B0%EC%97%85%201.jpg",
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            doc['name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: getScreenHeight(context) * 0.01,
                          ),
                          Text(
                            doc['description'],
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                doc['love'].toString()
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getScreenHeight(context) * 0.05,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              User? user = FirebaseAuth.instance.currentUser;
                              FirebaseFirestore.instance.collection('user').doc(user?.uid).update(
                                  {'myChallenge' : FieldValue.arrayUnion(<dynamic>[doc['docID']])});
                              print("Here~~~~!");
                              print("User.uid" + user!.uid);
                              print("doc[docID]" + doc['docID']);
                            },
                            child: Text("?????? ????????????", style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((color) => Colors.white),
                              minimumSize: MaterialStateProperty.resolveWith((minimumSize) => Size(getScreenWidth(context)*0.45, getScreenHeight(context)*0.08))
                            ),
                          ),
                          SizedBox(
                            height: getScreenHeight(context) * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
