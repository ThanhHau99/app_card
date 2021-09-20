import 'package:app/value/app_colors.dart';
import 'package:app/value/app_style.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String lable;
  final VoidCallback onTap;
  const AppButton({Key key, @required this.lable, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(3, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Text(
            lable,
            style: AppStyle.h4.copyWith(
              color: AppColor.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
