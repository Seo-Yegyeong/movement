import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Create_challenge extends StatefulWidget {
  const Create_challenge({Key? key}) : super(key: key);

  @override
  State<Create_challenge> createState() => _Create_challengeState();
}

class _Create_challengeState extends State<Create_challenge> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            myForm('factor')
          ],
        ),
      ),
    );
  }
  
  Widget myForm(String factor,){
    return Row(
      children: [
        Text(
            factor
        ),
        TextFormField(
          initialValue: "hello",
        )
      ],
    );
  }
}
