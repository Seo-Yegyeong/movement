import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movement/util/size.dart';
import 'package:movement/util/storage_service.dart';

import 'challenge_detail.dart';

enum CardType { NARROW, WIDE }
enum ContentType { Challenge, Group}

class ChallengeCard extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final CardType cardType;
  final ContentType contentType;

  const ChallengeCard({Key? key, required this.doc, required this.cardType, required this.contentType})
      : super(key: key);

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  get doc => widget.doc;
  get cardType => widget.cardType;
  get contentType => widget.contentType;

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();


    if(cardType == CardType.NARROW) {
      return Padding(
      padding: EdgeInsets.only(right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 140,
                height: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ElevatedButton(
                    onPressed: () {
                      print(doc.id);
                      Get.to(ChallDetail(doc: doc));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFF8F8F8),
                      elevation: 10.0,
                      animationDuration: Duration(seconds: 5),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                          child: FutureBuilder(
                            future: (contentType == ContentType.Challenge)? storage.downloadURL("challenge", doc['image'])
                            : storage.downloadURL("group", doc['image']),
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
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          doc['name'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: getScreenWidth(context)*0.82,
                height: getScreenHeight(context)*0.22,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(ChallDetail(doc: doc));
                    },
                    style: ElevatedButton.styleFrom(
                      //shape: CircleBorder(side: BorderSide.none),
                      primary: Color(0xFFe1e1e1),
                      elevation: 5.0,
                      //animationDuration: Duration(seconds: 5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: getScreenWidth(context)*0.3,
                          height: getScreenWidth(context)*0.3,
                          child: FutureBuilder(
                            future: storage.downloadURL("challenge", doc['image']),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done &&
                                  snapshot.hasData) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    snapshot.data!,
                                    fit: BoxFit.fill,
                                  ),
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }
                              
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  "https://dt40dm21pj8em.cloudfront.net/uploads/froala/file/5336/%ED%99%98%EA%B2%BD%20%EA%B3%B5%EA%B8%B0%EC%97%85%201.jpg",
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            doc['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
          SizedBox(height: 10,),
        ],
      );
    }
  }
}
