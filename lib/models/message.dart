import 'package:flutter/material.dart';

class Message
{
  final String? userId;
  final String imageUrl;
  final String text;
  final DateTime createdAt;
  final  bool isDoctor;


  Message({
  required this.userId,
  required this.text,
  required this.createdAt,
    required this.imageUrl,
    required this.isDoctor,

  });


  Map<String, dynamic> toJson() =>
      {
        'userId': userId,
        'text': text,
        'imageUrl': imageUrl,
        'createdAt': createdAt,
        'isDoctor': isDoctor,
      };
}
