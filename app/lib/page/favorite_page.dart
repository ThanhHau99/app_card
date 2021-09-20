import 'package:app/save/share_prefernces.dart';
import 'package:app/value/app_assets.dart';
import 'package:app/value/app_colors.dart';
import 'package:app/value/app_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  SharedPreferences prefs;
  List<String> listFavorites = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<String>> loadData() async {
    prefs = await SharedPreferences.getInstance();
    listFavorites = prefs.getStringList(ShareKey.favorite);

    return listFavorites.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.secondColor,
        appBar: AppBar(
          backgroundColor: AppColor.secondColor,
          elevation: 0, // Đường line dưới appbar
          title: Text(
            'Favorite word',
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
        body: FutureBuilder(
            future: loadData(),
            builder: (context, snapshot) {
              print(listFavorites.toString());
              return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: listFavorites.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? AppColor.primaryColor
                            : AppColor.secondColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          listFavorites[index],
                          style: TextStyle(
                              fontSize: 25,
                              color: index % 2 == 0
                                  ? Colors.white
                                  : AppColor.textColor,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black38,
                                  offset: Offset(3, 4),
                                  blurRadius: 7,
                                )
                              ]),
                        ),
                        trailing: InkWell(
                          onTap: () async {
                            print("remove $index");
                            setState(() {
                              listFavorites.remove(listFavorites[index]);
                            });
                            prefs = await SharedPreferences.getInstance();
                            await prefs.setStringList(
                                ShareKey.favorite, listFavorites);
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  });
            }));
  }
}
