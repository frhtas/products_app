import 'package:flutter/material.dart';
import 'package:products_app/util/services.dart';
import 'package:products_app/widgets/my_progress_indicator.dart';
import 'package:products_app/widgets/product_card.dart';

import '../models/product.dart';

class ProductList extends StatefulWidget {
  final String category;
  const ProductList({
    super.key,
    required this.category,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  getProducts() {
    try {
      Services.getProductsByCategory(widget.category).then((value) {
        setState(() {
          products = value;
          // products.sort((a, b) => b.rating.compareTo(a.rating));
          print(products);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return products.isNotEmpty
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 200,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductCard(product: products[index]);
            },
          )
        : const MyProgressIndicator();
  }
}
