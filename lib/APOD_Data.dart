// ignore_for_file: file_names

import "package:flutter/material.dart";

class APOD_Data {
  final String copyright, date, explanation, hdurl, title;

  const APOD_Data({
    required this.copyright,
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.title,
  });

  factory APOD_Data.fromJson(Map<String, dynamic> json) {
    return APOD_Data(
      copyright: json['copyright'],
      date: json['date'],
      explanation: json['explanation'],
      hdurl: json["hdurl"],
      title: json["title"],
    );
  }
}
