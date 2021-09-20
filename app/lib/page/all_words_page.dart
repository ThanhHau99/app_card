import 'package:app/models/english_today.dart';
import 'package:app/save/share_prefernces.dart';
import 'package:app/value/app_assets.dart';
import 'package:app/value/app_colors.dart';
import 'package:app/value/app_style.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllWordsPage extends StatefulWidget {
  final List<EnglishToday> words;
  const AllWordsPage({Key key, this.words}) : super(key: key);

  @override
  _AllWordsPageState createState() => _AllWordsPageState();
}

class _AllWordsPageState extends State<AllWordsPage> {
  SharedPreferences prefs;
  List<String> listFavorite = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFavoriteWord();
  }

  loadFavoriteWord() async {
    prefs = await SharedPreferences.getInstance();
    listFavorite = prefs.getStringList(ShareKey.favorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.secondColor,
        appBar: AppBar(
          backgroundColor: AppColor.secondColor,
          elevation: 0, // Đường line dưới appbar
          title: Text(
            'English today',
            style:
                AppStyle.h3.copyWith(color: AppColor.textColor, fontSize: 36),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(AppAssets.leftArrow),
          ),
        ),
        body: ListView.builder(
            itemCount: widget.words.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: index % 2 == 0
                      ? AppColor.primaryColor
                      : AppColor.secondColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: ListTile(
                  onTap: () async {
                    setState(() {
                      widget.words[index].isFavorite =
                          !widget.words[index].isFavorite;
                    });
                    addFavoriteWord(widget.words[index].isFavorite,
                        widget.words[index].noun);
                  },
                  title: Text(
                    widget.words[index].noun.substring(0, 1).toUpperCase() +
                        widget.words[index].noun.substring(1),
                    style: TextStyle(
                        fontSize: 25,
                        color:
                            index % 2 == 0 ? Colors.white : AppColor.textColor),
                  ),
                  leading: Icon(
                    Icons.favorite,
                    color: widget.words[index].isFavorite
                        ? Colors.red
                        : Colors.grey,
                  ),
                  subtitle: Text(
                    widget.words[index].quote,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              );
            }));
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
