import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movement/util/size.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({Key? key}) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    ChallengePage(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset("assets/image/challenge.svg", color: Colors.white,),
        title: Text("CHALLENGE", style: GoogleFonts.imprima(fontSize: 25)),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("도전 중인 챌린지",
                  style: TextStyle(
                    fontSize: 20
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      height: getScreenHeight(context)*0.3,
                      color: Colors.yellow,
                      child: Center(child: Text("ListView place")),
                      // ListView.builder(
                      //   itemBuilder: (BuildContext context, int index) {  },
                      //   scrollDirection: Axis.horizontal,
                      // ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("다른 챌린지 참여하기 > "),
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
                        fontSize: 20
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: getScreenHeight(context)*0.3,
                      color: Colors.yellow,
                      child: Center(child: Text("ListView place")),
                      // ListView.builder(
                      //   itemBuilder: (BuildContext context, int index) {  },
                      //   scrollDirection: Axis.horizontal,
                      // ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("새 그룹 만들기 + "),
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
              color: (_selectedIndex == 0)? Colors.amber[800] : Colors.black12,
            ),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/challenge.svg",
              color: (_selectedIndex == 1)? Colors.amber[800] : Colors.black12,
            ),
            label: 'Challenge',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/account.svg",
              color: (_selectedIndex == 2)? Colors.amber[800] : Colors.black12,
            ),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
