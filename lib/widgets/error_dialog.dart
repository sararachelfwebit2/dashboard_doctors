import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key? key,
    required this.title,
    required this.text,
    this.isContinue,
  }) : super(key: key);

  final String title;
  final String text;
  final bool? isContinue;

  @override
  Widget build(BuildContext context) {
    return
    // Platform.isIOS
    //     ? CupertinoAlertDialog(
    //     title: Text(title),
    //     content: SingleChildScrollView(child: Text(text)),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: Text(isContinue != null
    //             ? AppLocalizations.of(context)!.continueButton
    //             : AppLocalizations.of(context)!.close),
    //       ),
    //     ])
    //     :
    AlertDialog(
        title: Text(title),
        insetPadding: const EdgeInsets.symmetric(horizontal: 300),
        content: SingleChildScrollView(child: Text(text)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(isContinue != null
                ? AppLocalizations.of(context)!.continueButton
                : AppLocalizations.of(context)!.close),
          ),
        ]);
  }
}