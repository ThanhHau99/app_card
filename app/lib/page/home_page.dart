import 'dart:math';

import 'package:app/models/english_today.dart';
import 'package:app/page/all_words_page.dart';
import 'package:app/page/control_page.dart';
import 'package:app/page/favorite_page.dart';
import 'package:app/save/share_prefernces.dart';
import 'package:app/value/app_assets.dart';
import 'package:app/value/app_button.dart';
import 'package:app/value/app_colors.dart';
import 'package:app/value/app_fonts.dart';
import 'package:app/value/app_style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final List<String> listFavorite;
  const HomePage({Key key, this.listFavorite}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences prefs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  PageController _pageController;
  List<EnglishToday> words = [];
  List<String> listFavorite = [];

  List<int> fixedListRandom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];

    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    prefs = await SharedPreferences.getInstance();
    int len = prefs.getInt(ShareKey.counter) ?? 5;
    List<String> newList = [];
    List<int> rans = fixedListRandom(len: len, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });

    setState(() {
      words = newList
          .map((e) => EnglishToday(
              noun: e,
              quote:
                  '"Think of on the beauty still left around you and be happy"'))
          .toList();
    });
  }

  loadFavoriteWord() async {
    prefs = await SharedPreferences.getInstance();
    listFavorite = prefs.getStringList(ShareKey.favorite);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEnglishToday();
    loadFavoriteWord();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // dùng để chia tỷ lệ
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.secondColor,
      appBar: AppBar(
        backgroundColor: AppColor.secondColor,
        elevation: 0, // Đường line dưới appbar
        title: Text(
          'English today',
          style: AppStyle.h3.copyWith(color: AppColor.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Image.asset(AppAssets.menu),
        ),
      ),
      drawer: Drawer(
        child: _buildDrawer(),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            _titleLine(size),
            _buildCard(size),
            _indicator(size),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          print("Exchange");
          setState(() {
            getEnglishToday();
          });
        },
        child: Image.asset(AppAssets.exchange),
      ),
    );
  }

  Widget _buildDrawer() {
    return Container(
      padding: EdgeInsets.all(20),
      color: AppColor.lighBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "Your mind",
              style: AppStyle.h3.copyWith(color: AppColor.textColor),
            ),
          ),
          AppButton(
            lable: "Favorites",
            onTap: () {
              print("favorites");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritePage(),
                ),
              );
            },
          ),
          AppButton(
            lable: "Your control",
            onTap: () {
              print("Your control");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ControlPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _titleLine(Size size) {
    return Container(
      height: size.height * 1 / 10,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        "It is amazing how complete is the delusion that beauty is goodness.",
        style: AppStyle.h5.copyWith(color: AppColor.textColor, fontSize: 18),
      ),
    );
  }

  Widget _buildCard(Size size) {
    return Container(
      height: size.height * 2 / 3,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: words.length > 5 ? 6 : words.length,
        itemBuilder: (context, index) {
          String firstLetter = words[index].noun.substring(0, 1).toUpperCase();

          String leftLetter = words[index].noun.substring(1);

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: AppColor.primaryColor,
              elevation: 4,
              child: InkWell(
                onDoubleTap: () {
                  print("onDoubleTap");
                  setState(() {
                    words[index].isFavorite = !words[index].isFavorite;
                  });
                  addFavoriteWord(words[index].isFavorite, words[index].noun);
                },
                splashColor: Colors.black38,
                borderRadius: BorderRadius.all(Radius.circular(24)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                  ),
                  child: index >= 5
                      ? _buildShowMore()
                      : _buildDataInCard(firstLetter, leftLetter, index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDataInCard(String firstLetter, String leftLetter, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFavorite(index),
        RichText(
          maxLines: 1,
          // overflow hiệu ứng khi chữ bị tràn
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: firstLetter,
            style: TextStyle(
              fontSize: 100,
              fontFamily: FontFamily.sen,
              fontWeight: FontWeight.bold,
              // shadows đổ bóng cho chữ
              shadows: [
                BoxShadow(
                  color: Colors.black38,
                  // offset hướng đổ bóng
                  offset: Offset(3, 6),
                  // blurRadius làm mờ
                  blurRadius: 6,
                ),
              ],
            ),
            children: [
              TextSpan(
                text: leftLetter,
                style: TextStyle(
                  fontSize: 65,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          //AutoSizeText Dùng để thu kích cở chữ khi vượt quá
          child: AutoSizeText(
            '"Think of on the beauty still left around you and be happy"',
            //minFontSize: 10,
            maxFontSize: 25,
            style: AppStyle.h4.copyWith(
              color: AppColor.textColor,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavorite(int index) {
    return LikeButton(
      onTap: (bool isLiked) async {
        setState(() {
          words[index].isFavorite = !words[index].isFavorite;
        });
        return words[index].isFavorite;
      },
      isLiked: words[index].isFavorite,
      size: 50,
      mainAxisAlignment: MainAxisAlignment.end,
      circleColor:
          CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Color(0xff33b5e5),
        dotSecondaryColor: Color(0xff0099cc),
      ),
      likeBuilder: (bool isLiked) {
        return ImageIcon(
          AssetImage(AppAssets.heart),
          color: isLiked ? Colors.red : Colors.white,
          size: 50,
        );
      },
    );
  }

  Widget _buildShowMore() {
    return InkWell(
      onTap: () {
        print("show more");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AllWordsPage(
              words: this.words,
            ),
          ),
        );
      },
      child: Center(
        child: Text(
          "Show more...",
          style: AppStyle.h3.copyWith(shadows: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(3, 6),
              blurRadius: 6,
            )
          ]),
        ),
      ),
    );
  }

  Widget _indicator(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: size.height * 1 / 13,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          alignment: Alignment.center,
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return buildIndicator(index == _currentIndex, size);
              }),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
      width: isActive ? size.width * 1 / 5 : 35,
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive ? AppColor.lighBlue : AppColor.lightGrey,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(3, 6),
              blurRadius: 6,
            ),
          ]),
    );
  }

  void addFavoriteWord(bool isFavorite, String noun) async {
    prefs = await SharedPreferences.getInstance();

    if (isFavorite == true) {
      listFavorite.add(noun);
      print(true);

      await prefs.setStringList(ShareKey.favorite, listFavorite);
    } else if (isFavorite == false) {
      listFavorite.remove(noun);
      print(false);
      await prefs.setStringList(ShareKey.favorite, listFavorite);
    }
  }
}
