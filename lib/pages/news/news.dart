import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movement/pages/home/home.dart';

import '../account/account.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(index == 1)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    else if(index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AccountPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset("assets/image/news.svg", color: Colors.white,),
        title: Text("NATURE NEWS", style: GoogleFonts.imprima(fontSize: 25)),
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
                  Text("세계 환경 뉴스",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  // Container(
                  //   height: getScreenHeight(context)*0.28,
                  //   child: StreamBuilder(
                  //     stream: FirebaseFirestore.instance.collection('/challenge').snapshots(),
                  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
                  //       if (snapshot.connectionState == ConnectionState.waiting)
                  //         return Center(child: CircularProgressIndicator());
                  //
                  //       return Row(
                  //         children: [
                  //           Expanded(
                  //             child: ListView.builder(
                  //               shrinkWrap: true,
                  //               scrollDirection: Axis.horizontal,
                  //               itemCount: snapshot.data!.docs.length,
                  //               itemBuilder: (BuildContext context, int index) {
                  //                 return ChallengeCard(doc: snapshot.data!.docs[index], );
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("더 많은 소식 듣기>",
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
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
