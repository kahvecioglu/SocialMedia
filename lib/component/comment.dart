import 'package:flutter/material.dart';

class comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const comment(
      {super.key, required this.text, required this.time, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // comment
          Text(text),

          SizedBox(
            height: 5,
          ),

          // user, time
          Row(
            children: [
              Text(
                user,
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text("  "),
              Text(time, style: TextStyle(color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
}
