import 'package:app/save/share_prefernces.dart';
import 'package:app/value/app_assets.dart';
import 'package:app/value/app_colors.dart';
import 'package:app/value/app_fonts.dart';
import 'package:app/value/app_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key key}) : super(key: key);

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  // SharedPreferences lưu dữ liệu xuống máy
  SharedPreferences prefs;
  double _sliderValue = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDefaultValue();
  }

  initDefaultValue() async {
    prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(ShareKey.counter) ?? 5;
    setState(() {
      _sliderValue = value.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondColor,
      appBar: AppBar(
        backgroundColor: AppColor.secondColor,
        elevation: 0, // Đường line dưới appbar
        title: Text(
          'Your control',
          style: AppStyle.h3.copyWith(color: AppColor.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () async {
            await prefs.setInt(ShareKey.counter, _sliderValue.toInt());
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Spacer(),
            Text(
              "How much a number word at once",
              style: TextStyle(fontSize: 20, color: AppColor.lightGrey),
            ),
            Spacer(),
            Text(
              "${_sliderValue.toInt()}",
              style: TextStyle(
                fontSize: 150,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: _sliderValue,
              min: 5,
              max: 100,
              divisions: 95,
              activeColor: AppColor.primaryColor,
              inactiveColor: AppColor.primaryColor,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32),
              alignment: Alignment.centerLeft,
              child: Text(
                "slide to set",
                style: TextStyle(
                  fontSize: 20,
                  color: AppColor.textColor,
                ),
              ),
            ),
            Spacer(),
            Spacer(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
