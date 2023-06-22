import 'package:flutter/material.dart';

class ProfileListTitle extends StatelessWidget {
  const ProfileListTitle(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});
  final String title;
  final Icon icon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: Colors.black,
      // iconColor: Colors.black,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      leading: icon,
      onTap: onTap,
    );
  }
}
