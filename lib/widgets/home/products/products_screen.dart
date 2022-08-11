import 'dart:io';
import 'dart:ui';

import 'package:dashboard_doctors/models/product.dart';
import 'package:dashboard_doctors/widgets/error_dialog.dart';
import 'package:dashboard_doctors/widgets/home/products/product_container.dart';
import 'package:dashboard_doctors/widgets/home/searchWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String query = '';
  List<Product> products = [];
  bool _showMyProducts = false;

  void searchProduct(String query) {
    final productsModel = Provider.of<Products>(context, listen: false);
    products = productsModel.products;

    final filterdProducts = products.where((product) {
      final titleLower = product.productName.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      products = filterdProducts;
    });
  }

  @override
  void initState() {
    super.initState();
    final productsModel = Provider.of<Products>(context, listen: false);
    products = productsModel.products;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    Locale myLocale = window.locale;

    final productsModel = Provider.of<Products>(context, listen: false);

    const TextStyle textStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20);

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(context),
          iconSize: 25,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            iconSize: 25,
            onPressed: () {
              setState(() {
                _showMyProducts = !_showMyProducts;
                if (_showMyProducts) {
                  products = productsModel.myProducts;
                } else {
                  products = productsModel.products;
                }
              });
            },
            icon:
                Icon(_showMyProducts ? Icons.favorite : Icons.favorite_border),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                // if (Platform.isIOS) {
                //   showCupertinoDialog(
                //     context: context,
                //     builder: (ctx) => ErrorDialog(
                //       text: myLocale.languageCode == 'he'
                //           ? 'מסך המוצרים מאפשר לכם לבחור את המוצרים בהם אתם משתמשים כך שתוכלו לתעד את השפעתם עליכם בהמשך. ניתן לחפש על פי שם המוצר, היצרן וכן על פי קטגוריית המוצר. לעיתים שם המוצר מופיע בעברית או באנגלית (בהתאם למידע הנמסר מהיצרן) - אם לא מצאתם את המוצר שאתם מחפשים, אנא נסו בעברית/אנגלית בהתאם או פנו אלינו למייל service@leema.ai כך שנוכל לעדכן במידת הצורך!. רוצים לראות את המוצרים שלכם? לחצו על לחצן הלב המופיע בראש המסך ותקבלו את כל המוצרים שסימנתם!'
                //           : 'The products screen allows you to select the products you use so that you can document their effect on you later. You can search by product name, manufacturer as well as by product category. Sometimes the product name appears in Hebrew or English (depending on the information provided by the manufacturer) - If you did not find the product you are looking for, please try in Hebrew / English accordingly or contact us at service@leema.ai so we can update if necessary! Want to see your products? Click on the heart button that appears at the top of the screen and you will receive all the products you have marked!',
                //       title: AppLocalizations.of(context)!.products,
                //     ),
                //   );
                // } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => ErrorDialog(
                      text: myLocale.languageCode == 'he'
                          ? 'מסך המוצרים מאפשר לכם לבחור את המוצרים בהם אתם משתמשים כך שתוכלו לתעד את השפעתם עליכם בהמשך. ניתן לחפש על פי שם המוצר, היצרן וכן על פי קטגוריית המוצר. לעיתים שם המוצר מופיע בעברית או באנגלית (בהתאם למידע הנמסר מהיצרן) - אם לא מצאתם את המוצר שאתם מחפשים, אנא נסו בעברית/אנגלית בהתאם או פנו אלינו למייל service@leema.ai כך שנוכל לעדכן במידת הצורך!. רוצים לראות את המוצרים שלכם? לחצו על לחצן הלב המופיע בראש המסך ותקבלו את כל המוצרים שסימנתם!'
                          : 'The products screen allows you to select the products you use so that you can document their effect on you later. You can search by product name, manufacturer as well as by product category. Sometimes the product name appears in Hebrew or English (depending on the information provided by the manufacturer) - If you did not find the product you are looking for, please try in Hebrew / English accordingly or contact us at service@leema.ai so we can update if necessary! Want to see your products? Click on the heart button that appears at the top of the screen and you will receive all the products you have marked!',
                      title: AppLocalizations.of(context)!.products,
                    ),
                  );
               // }
              },
              color: Colors.white,
              icon:
                  const ImageIcon(AssetImage('assets/icons/question-mark.png')),
            ),
          ),
        ],
        backgroundColor: Colors.lightBlue[900],
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.products,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.products, style: textStyle),
            const SizedBox(height: 10),
            SearchWidget(
              text: AppLocalizations.of(context)!.searchProduct,
              onChanged: searchProduct,
              hintText: AppLocalizations.of(context)!.searchProduct,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: size.height * 0.7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 0,
                   // childAspectRatio:size.width /
                   //    size.height / 4,
                      mainAxisExtent:size.width/4-50
                  ),
                  itemBuilder: (ctx, i) => ProductContainer(
                    product: products[i],
                    isForPick: false,
                    isTappable: true,
                  ),
                  itemCount: products.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
