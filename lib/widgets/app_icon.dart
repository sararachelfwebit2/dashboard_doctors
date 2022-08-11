import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app icon',
      child: Container(
        height: 120,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/lemma-logo.png'),
          ),
        ),
      ),
    );
  }
}