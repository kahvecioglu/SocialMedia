// datayı stringe çevirecez

import 'package:cloud_firestore/cloud_firestore.dart';

String formatdate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  String year = dateTime.year.toString();

  String month = dateTime.month.toString();

  String day = dateTime.day.toString();

  String formatedTime = "$day/$month/$year";

  return formatedTime;
}
