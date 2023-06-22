import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_app/common/utils/theme_color.dart';

class BackgroundDismissible extends StatelessWidget {
  const BackgroundDismissible({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.red.withOpacity(0.8)),
      alignment: Alignment.centerRight,
      child: Icon(
        CupertinoIcons.trash,
        color: LightThemeColors.primaryTextColor,
        size: 40,
      ),
    );
  }
}
