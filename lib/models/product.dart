import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

class Product {
  final String id;
  final String productName;
  final String productKind;
  final String imageUrl;
  final String productDefinition;
  final String productCategory;
  final String productCompany;
  final String productType;
  final String companyId;
  final String productBarcode;

  Product({
    required this.id,
    required this.productName,
    required this.companyId,
    required this.imageUrl,
    required this.productBarcode,
    required this.productCategory,
    required this.productCompany,
    required this.productDefinition,
    required this.productKind,
    required this.productType,
  });
}

class Products with ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  final List<Product> _myProducts = [];

  List<Product> get myProducts {
    return [..._myProducts];
  }

  Future<void> fetchProducts() async {
    var url = Uri.parse('https://www.thc.mba/services/ProMan.php');
    var response = await http.post(
      url,
      body: {"api_key": "AkxantsczBsW8u5TqTNnDWSBTdrKFBa"},
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    var jsonData = jsonDecode(response.body);

    for (var p in jsonData) {
      Product product = Product(
        id: p['product_id'],
        productName: p['product_name'],
        productKind: p['product_kind'],
        imageUrl: (p['product_image'] as String).startsWith('https')
            ? p['product_image']
            : 'https://www.thc.mba${p['product_image']}',
        productDefinition: p['product_definition'],
        productCategory: p['product_category'],
        productCompany: p['product_company'],
        companyId: p['product_company_id'],
        productType: p['product_type'],
        productBarcode: p['product_barcode'],
      );

      _products.add(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    // final String? userId = globals.chosenPatientId;

    print('product 1  $userId');

    _myProducts.add(product);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Products')
        .doc(product.id)
        .set({
      'productId': product.id,
      'productName': product.productName,
      'productKind': product.productKind,
      'imageUrl': product.imageUrl,
      'productBarcode': product.productBarcode,
      'productDefinition': product.productDefinition,
      'productCategory': product.productCategory,
      'productCompany': product.productCompany,
      'productType': product.productType,
      'companyId': product.companyId,
    });
  }

  Future<void> removeProduct(Product product) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    // final String? userId = globals.chosenPatientId;
    print('priduct 2  $userId');


    _myProducts.removeWhere((element) => element.id == product.id);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Products')
        .doc(product.id)
        .delete();
  }

  Future<void> fetchMyProducts() async {
    // final String userId = FirebaseAuth.instance.currentUser!.uid;
    final String? userId = globals.chosenPatientId;

    print('product  3 $userId');

    final data = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Products')
        .get();

    final List<QueryDocumentSnapshot> dataList = data.docs;

    for (var product in dataList) {
      final Product newProduct = Product(
        id: product.id,
        productName: product['productName'],
        companyId: product['companyId'],
        imageUrl: product['imageUrl'],
        productBarcode: product['productBarcode'],
        productCategory: product['productCategory'],
        productCompany: product['productCompany'],
        productDefinition: product['productDefinition'],
        productKind: product['productKind'],
        productType: product['productType'],
      );

      _myProducts.add(newProduct);
    }
  }
}