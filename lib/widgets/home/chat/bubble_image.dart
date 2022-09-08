import 'package:dashboard_doctors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BubbleImage extends StatelessWidget {
  const BubbleImage({Key? key, this.imageUrl, required this.isLeema})
      : super(key: key);

  final bool isLeema;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.66.h,
      width: 38.66.w,
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
              color: HexaColor('#4E7AC7'),
            )
          : /*imageUrl != null && imageUrl != ''? CircleAvatar(
          backgroundImage: NetworkImage(imageUrl!), radius: 15.0,
      ):const ImageIcon(
        AssetImage('assets/icons/user.png'),
        color: Colors.white,

      ),*/
     Container(),
    );
  }
}
