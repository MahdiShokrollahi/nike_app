import 'package:flutter/material.dart';

class CustomView extends StatelessWidget {
  const CustomView(
      {super.key,
      required this.image,
      required this.message,
      this.callTOAction});
  final Widget image;
  final String message;
  final Widget? callTOAction;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        image,
        Padding(
          padding: const EdgeInsets.fromLTRB(48, 24, 48, 16),
          child: Text(
            message,
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(height: 1.3),
            textAlign: TextAlign.center,
          ),
        ),
        if (callTOAction != null) callTOAction!
      ],
    );
  }
}
