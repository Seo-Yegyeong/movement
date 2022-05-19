import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({Key? key}) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset("assets/image/challenge.svg"),
        title: Text("CHALLENGE", style: GoogleFonts.imprima(fontSize: 25)),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                children: [
                  Text("도전 중인 챌린지",
                  style: TextStyle(
                    fontSize: 20
                  ),
                  ),
                  // ListView.builder(
                  //   itemBuilder: (BuildContext context, int index) {  },
                  //   scrollDirection: Axis.horizontal,
                  // ),
                  Container(
                    height: 300,
                    color: Colors.yellow,
                    child: Center(child: Text("ListView place")),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("다른 챌린지 참여하기 > "),
                    ],
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
