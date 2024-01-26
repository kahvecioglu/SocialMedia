import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;

  MyListTile(
      {super.key, required this.icon, required this.text, required this.onTap});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        onTap: onTap,
        title: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
