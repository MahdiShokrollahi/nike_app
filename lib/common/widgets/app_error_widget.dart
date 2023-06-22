import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget(
      {super.key, required this.exception, required this.onTap});
  final String exception;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(exception),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(onPressed: onTap, child: const Text('تلاش دوبازه'))
      ],
    );
  }
}
