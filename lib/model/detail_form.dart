import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movement/util/size.dart';
import 'package:movement/util/storage_service.dart';

import '../pages/account/account.dart';


class DetailFormPage extends StatelessWidget {
  const DetailFormPage({Key? key,}) : super(key: key);

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
            Get.to(AccountPage());
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
    return Container();
  }
}
