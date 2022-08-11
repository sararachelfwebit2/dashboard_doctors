import 'dart:ui';

import 'package:flutter/material.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

// // ScrollBehavior can be set for a specific widget.
// final ScrollController controller = ScrollController();
// ScrollConfiguration(
// behavior: MyCustomScrollBehavior(),
// child: ListView.builder(
// controller: controller,
// itemBuilder: (BuildContext context, int index) {
// return Text('Item $index');
// }
// ),
// );
