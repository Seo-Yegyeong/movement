import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movement/pages/calendar.dart';
import 'package:movement/pages/news/news.dart';
import 'package:movement/util/color_extensions.dart';
import 'package:movement/util/storage_service.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../util/size.dart';
import '../home/home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class AccountPage extends StatefulWidget {
  final List<Color> availableColors = const [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);
  bool _visibility = false;

  int touchedIndex = -1;

  bool isPlaying = false;

  User? user = FirebaseAuth.instance.currentUser;
  //final whoAmI = FirebaseFirestore.instance.collection('user').where("uid", isEqualTo: user?.uid);

  int _selectedIndex = 2;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0)
      Get.to(NewsPage());
    else if (index == 1) {
      Get.to(HomePage());
    }
  }

  void _show() {
    setState(() {
      _visibility = true;
    });
  }
  void _hide() {
    setState(() {
      _visibility = false;
    });
  }

  Widget _profileImage() {
    final Storage storage = Storage();
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('/user')
              .where("name", isEqualTo: user?.displayName)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            print("Here~~~~~~!!");
            print(snapshot.data!.docs[0]['uid']);
            return FutureBuilder(
              future: storage.downloadURL(
                  "user", snapshot.data?.docs.first['uid'] + ".jpg"),
              builder: (BuildContext context, AsyncSnapshot<String> snap) {
                if (snap.connectionState == ConnectionState.done &&
                    snap.hasData) {
                  return Container(
                    width: 300,
                    height: 250,
                    child: Image.network(
                      snap.data!,
                      fit: BoxFit.cover,
                    ),
                  );
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return Image.network('https://i.stack.imgur.com/l60Hf.png',
                    fit: BoxFit.cover);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _myProfile() {
    return Container(
      height: 170,
      child: Column(
        children: [
          _profileImage(),
          //_profileInfo(),
        ],
      ),
    );
  }

  Widget _myCalendar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TableCalendar(
          focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2022, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31)),
    );
  }

  Widget _myChart(){
    String name = user!.displayName.toString();
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: const Color(0xffDFF6FF),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "$name" + "님",
                    style: TextStyle(
                        color: Color(0xff0f4a3c),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    '덕분에 지구가 더 행복해졌습니다!',
                    style: TextStyle(
                        color: Color(0xff379982),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        isPlaying ? randomData() : mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: const Color(0xff0f4a3c),
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                      if (isPlaying) {
                        refreshState();
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.white,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow.darken(), width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, 5, isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, 5, isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, 9, isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
      case 6:
        return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
      default:
        return throw Error();
    }
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY - 1).toString(),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                Random().nextInt(widget.availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                Random().nextInt(widget.availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                Random().nextInt(widget.availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                Random().nextInt(widget.availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                Random().nextInt(widget.availableColors.length)]);
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                Random().nextInt(widget.availableColors.length)]);
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                Random().nextInt(widget.availableColors.length)]);
          default:
            return throw Error();
        }
      }),
      gridData: FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }

  @override
  Widget build(BuildContext context) {
    String? name = user?.displayName;
    // final user_doc = FirebaseFirestore.instance.collection('/user').where("name", isEqualTo: user?.displayName);

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("MOVEMENT", style: GoogleFonts.imprima(fontSize: 25))),
        actions: [
          Icon(
            Icons.email,
            size: 40,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Center(
                  child: Text(
              "MOVEMENT!",
              style: optionStyle,
            ),
                ),
              decoration: BoxDecoration(
                color: Color(0xffDFF6FF)
              ),
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Center(
                child: Text("응원카드 보내기", style: TextStyle(
                  fontSize: 20
                ),),
              ),
            ),
            Divider(thickness: 1,),
            ListTile(
              leading: Icon(Icons.list),
              title: Center(
                child: Text("나의 게시글", style: TextStyle(
                  fontSize: 20
                ),),
              ),
            ),
            Divider(thickness: 1,),
            ListTile(
              leading: Icon(Icons.settings),
              title: Center(
                child: Text("설정하기", style: TextStyle(
                  fontSize: 20
                ),),
              ),
            ),
            Divider(thickness: 1,),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _myProfile(),
                Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText("안녕하세요! " + "$name" + "님,",
                          textStyle: TextStyle(fontSize: 20)),
                      WavyAnimatedText("오늘도 지구를 지켜주셔서 감사합니다!",
                          textStyle: TextStyle(fontSize: 20)),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 1,
                ),
                _myChart(),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: (){
                    if(_visibility == true)
                      _hide();
                    else
                      _show();
                  },
                  child: Text("달력 보기", style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((color) => Colors.white),
                      minimumSize: MaterialStateProperty.resolveWith((minimumSize) => Size(getScreenWidth(context)*0.45, getScreenHeight(context)*0.08))
                  ),
                ),
                Visibility(
                  child: _myCalendar(),
                  visible: _visibility,
                ),
              ],
            ),
          ),
        ],
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
