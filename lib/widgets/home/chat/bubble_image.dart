import 'package:flutter/material.dart';

class BubbleImage extends StatelessWidget {
  const BubbleImage({Key? key, this.imageUrl, required this.isLeema})
      : super(key: key);

  final bool isLeema;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        image: isLeema
            ? null
            : DecorationImage(
                image: imageUrl != null && imageUrl != ''
                    ? NetworkImage(imageUrl!)
                    : const AssetImage('assets/icons/user.png')
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
      ),
      child: isLeema
          ? ImageIcon(
              const AssetImage('assets/icons/logo.png'),
              color: Colors.lightBlue[900]!,
            )
          : Container(),
    );
  }
}
