import 'dart:html';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
class WebImage extends StatelessWidget {
  final String imageUrl;

  const WebImage({super.key, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    // String imageUrl = "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png";
// https://github.com/flutter/flutter/issues/41563
// ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory(
//       imageUrl,
//           (int _) =>
//       ImageElement(src: imageUrl,width: 50,height: 50)
//         // ..src = imageUrl,
//
//     );

// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(imageUrl, (int viewId) {
      return ImageElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..src = imageUrl
        ..style.border = 'none';
    });

    return HtmlElementView(
      viewType: imageUrl,

    );
  }
}