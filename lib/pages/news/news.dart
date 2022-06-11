import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movement/pages/home/home.dart';

import '../../model/news_model.dart';
import '../account/account.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _selectedIndex = 0;
  Future<List<News>> _getNews() async {
    //https://newsapi.org/v2/top-headlines?country=us&apiKey=2cadfe6240bb436196b896560f428017
    var data = await http.get(
        Uri.http('newsapi.org', 'v2/top-headlines', {'country' : 'kr', 'apiKey' : '2cadfe6240bb436196b896560f428017'})
    );
    var jsonData = json.decode(data.body);

    List<News> news_list = [];

    for (var news in jsonData["articles"]) {
      News newNews = News(news["publishedAt"], news["urlToImage"],
          news["title"], news["url"], news["description"]);
      news_list.add(newNews);
      print(news_list.length);
    }

    return news_list;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1)
      Get.to(HomePage());
    else if (index == 2) {
      Get.to(AccountPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset(
          "assets/image/news.svg",
          color: Colors.white,
        ),
        title: Text("NATURE NEWS", style: GoogleFonts.imprima(fontSize: 25)),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder(
              future: _getNews(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data[index].urlToImage),
                        ),
                        title: Text(snapshot.data[index].publishedAt),
                        subtitle:
                        Text(snapshot.data[index].description),
                      );
                    },
                  );
                }
              }),
          // ListView(
          //   children: [
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           "세계 환경 뉴스",
          //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //         ),
          //         Positioned(
          //           left: 0,
          //           top: 0,
          //           right: 0,
          //           bottom: 0,
          //           child: FutureBuilder(
          //               future: _getNews(),
          //               builder: (BuildContext context, AsyncSnapshot snapshot) {
          //                 if (snapshot.data == null) {
          //                   return const Center(
          //                     child: CircularProgressIndicator(),
          //                   );
          //                 } else {
          //                   return ListView.builder(
          //                     itemCount: 10,
          //                     //snapshot.data.length,
          //                     itemBuilder: (BuildContext context, int index) {
          //                       return ListTile(
          //                         leading: CircleAvatar(
          //                           backgroundImage: NetworkImage(
          //                               snapshot.data[index].urlToImage),
          //                         ),
          //                         title: Text(snapshot.data[index].publishedAt),
          //                         subtitle:
          //                             Text(snapshot.data[index].description),
          //                       );
          //                     },
          //                   );
          //                 }
          //               }),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
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
