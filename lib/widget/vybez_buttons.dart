import 'package:flutter/material.dart';

class VybezButtons extends StatelessWidget {
  const VybezButtons({
    this.backgroundColor = Colors.red,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    required this.text,
    required this.onPressed,
    this.height,
    this.icon,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final String text;
  final VoidCallback? onPressed;
  final double? height;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(iconTheme: IconThemeData(color: iconColor)),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon ?? SizedBox.shrink(),
              SizedBox(width: 13),
              Text(
                text,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
