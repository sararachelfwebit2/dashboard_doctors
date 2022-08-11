import 'package:dashboard_doctors/models/product.dart';
import 'package:dashboard_doctors/widgets/webImage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';


class ProductContainer extends StatefulWidget {
  const ProductContainer({
    Key? key,
    required this.isForPick,
    required this.product,
    required this.isTappable,
    this.choosenAnswers,
    this.getAnswer,
    this.question,
    this.answer,
  }) : super(key: key);

  final Product product;
  final bool isForPick;
  final bool isTappable;

  // releated for piciking products in the questionnaire
  final Map<String, dynamic>? choosenAnswers;
  final Function? getAnswer;
  final String? question;
  final String? answer;

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final productModel = Provider.of<Products>(context, listen: false);

    // check if product exists
    final Product? isExist = productModel.myProducts
        .firstWhereOrNull((element) => element.id == widget.product.id);



    return Container(
      height: size.height * 0.16,
      width: size.width * 0.2,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, offset: Offset(0, 1), blurRadius: 10),
        ],
      ),
      child: TextButton(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
        ),
        onPressed: () {
          if (widget.isTappable) {
            if (widget.isForPick) {
              widget.getAnswer!(widget.answer, widget.question);
            }
          }
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 50,

                  child: WebImage(imageUrl:widget.product.imageUrl
                      .startsWith('https')
                      ? widget.product.imageUrl
                      : 'https://www.thc.mba${widget.product.imageUrl}'),
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: NetworkImage(widget.product.imageUrl
                  //             .startsWith('https')
                  //         ? widget.product.imageUrl
                  //         : 'https://www.thc.mba${widget.product.imageUrl}'),
                  //   ),
                  // ),
                ),

                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.product.productName} ',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Assistant'),
                      ),
                      TextSpan(
                        text: widget.product.productDefinition,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'Assistant'),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.product.productCategory} ',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Assistant'),
                      ),
                      TextSpan(
                        text: widget.product.productKind,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'Assistant'),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.product.productCompany,
                  style: TextStyle(
                      color: Colors.blue[900]!,
                      fontSize: 14,
                      fontFamily: 'Assistant'),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          'assets/icons/${widget.product.productType != 'שמנים' ? 'weed' : 'oil'}.png'),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.isTappable) {
                      if (!widget.isForPick) {
                        setState(() {
                          if (isExist == null) {
                            productModel.addProduct(widget.product);
                          } else {
                            productModel.removeProduct(widget.product);
                          }
                        });
                      } else {
                        widget.getAnswer!(widget.answer, widget.question);
                      }
                    }
                  },
                  child: widget.isForPick
                      ? Icon(
                          widget.choosenAnswers!.containsKey(widget.question) &&
                                      widget.choosenAnswers![widget.question] ==
                                          widget.answer ||
                                  !widget.isTappable
                              ? Icons.circle
                              : Icons.circle_outlined,
                          size: 20,
                          color: Colors.lightBlue[900]!,
                        )
                      : Icon(
                          isExist == null
                              ? Icons.favorite_border
                              : Icons.favorite,
                          size: 20,
                          color: Colors.lightBlue[900]!,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
