import 'package:dashboard_doctors/animations/fade_transition.dart';
import 'package:dashboard_doctors/models/product.dart';
import 'package:dashboard_doctors/widgets/home/products/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../products/product_container.dart';

class PickProduct extends StatefulWidget {
  const PickProduct({
    Key? key,
    required this.chosenAnswers,
    required this.getAnswer,
    required this.question,
    required this.isTappable,
    required this.refresh,
  }) : super(key: key);

  final Map<String, dynamic> chosenAnswers;
  final Function getAnswer;
  final Function refresh;
  final String question;
  final bool isTappable;

  @override
  State<PickProduct> createState() => _PickProductState();
}

class _PickProductState extends State<PickProduct> {
  bool _chooseProducts = false;

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<Products>(context, listen: false);

    final List<Product> myProducts = widget.isTappable
        ? productModel.myProducts
        : productModel.products.where((element) {
            final rightAnswer = widget.chosenAnswers['מה המוצר הנצרך?'] ??
                widget
                    .chosenAnswers['What product are you currenty consuming?'];

            return element.id == rightAnswer;
          }).toList();

    if (myProducts.isEmpty) {
      setState(() {
        _chooseProducts = true;
      });
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _chooseProducts
            ? [
                Container(
                  height: 50,
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(FadeTransiton(const ProductsScreen(), 300))
                          .then((value) {
                        setState(() {
                          if (myProducts.isNotEmpty) {
                            _chooseProducts = false;
                          }
                          widget.refresh(() {});
                        });
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 280,
                      child: Text(
                        AppLocalizations.of(context)!.chooseProducts,
                        style: TextStyle(
                          color: Colors.grey[800]!,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ]
            : myProducts
                .map((Product product) => ProductContainer(
                      product: product,
                      isForPick: true,
                      isTappable: widget.isTappable,
                      choosenAnswers: widget.chosenAnswers,
                      answer: product.id,
                      getAnswer: widget.getAnswer,
                      question: widget.question,
                    ))
                .toList(),
      ),
    );
  }
}
