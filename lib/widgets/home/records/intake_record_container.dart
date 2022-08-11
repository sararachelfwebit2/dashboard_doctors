import 'package:dashboard_doctors/models/product.dart';
import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:dashboard_doctors/widgets/home/records/intake_record.dart';
import 'package:dashboard_doctors/widgets/webImage.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// import '../../models/questionnaire.dart';
// import '../../models/product.dart';
// import 'intake_record.dart';

class IntakeRecordContainer extends StatelessWidget {
  const IntakeRecordContainer({
    Key? key,
    required this.record,
  }) : super(key: key);

  final Record record;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final productModel = Provider.of<Products>(context, listen: false);

    Product? product = productModel.myProducts.firstWhereOrNull((element) =>
        element.id ==
        record.answers[AppLocalizations.of(context)!.whatProduct]);

    product ??= productModel.myProducts.firstWhereOrNull(
        (element) => element.id == record.answers['מה המוצר הנצרך?']);

    product ??= productModel.myProducts.firstWhereOrNull((element) =>
        element.id ==
        record.answers['What product are you currenty consuming?']);

    return Container(
      height:150 ,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 15,
            color: Colors.black12,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                  'assets/icons/${record.isGrams ? 'weed' : 'oil'}.png'),
            ),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 15),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  content: IntakeRecord(record: record),
                  title: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft, //  change base on locale
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          splashRadius: 30,
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.lightBlue[900],
                        ),
                      ),
                      Text(
                        formatDate(
                          DateTime.parse(record.date),
                          [dd, ' ', MM, ', ', yyyy, '   ', HH, ':', nn,],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.lightBlue[900]!,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: record.answers[AppLocalizations.of(context)!
                                .howMuchConsuming] ??
                            record.answers['מהי הכמות הנצרכת?'] ??
                            record.answers[
                                'How much are you currenty consuming?'],
                        style: TextStyle(
                          color: Colors.lightBlue[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: 'Assistant',
                        ),
                      ),
                      TextSpan(
                        text: record.isGrams
                            ? ' ${AppLocalizations.of(context)!.grams} '
                            : ' ${AppLocalizations.of(context)!.drops} ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Assistant',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // Text(

                //   textAlign: TextAlign.center,
                //   style: const TextStyle(
                //     color: Colors.grey,
                //     fontSize: 16,
                //   ),
                // ),
                if (product != null)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${product.productName} ',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Assistant'),
                        ),
                        TextSpan(
                          text: product.productDefinition,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'Assistant'),
                        ),
                      ],
                    ),
                  ),
                if (product != null)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${product.productCategory} ',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Assistant'),
                        ),
                        TextSpan(
                          text: product.productKind,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'Assistant'),
                        ),
                      ],
                    ),
                  ),
                if (product != null) const SizedBox(height: 10),
                if (product != null)
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: WebImage(imageUrl: product.imageUrl.startsWith('https')
    ? product.imageUrl
        : 'https://www.thc.mba${product.imageUrl}',),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
