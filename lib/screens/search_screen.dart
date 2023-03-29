import 'package:flutter/material.dart';
import 'package:products_app/models/product.dart';
import 'package:products_app/util/services.dart';
import 'package:products_app/widgets/empty_state_widget.dart';
import 'package:products_app/widgets/my_progress_indicator.dart';

import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchText = "";
  List<Product> products = [];
  bool isLoading = false;

  searchProducts(String query) {
    setState(() {
      isLoading = true;
    });
    try {
      Services.searchProducts(query).then((value) {
        setState(() {
          products = value;
          isLoading = false;
          print(products);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                searchText = value;

                if (searchText.length > 2) {
                  searchProducts(searchText);
                } else {
                  products = [];
                }
              });
            },
            decoration: const InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.black54),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: isLoading == false
          ? products.isNotEmpty
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
              : const EmptyStateWidget(
                  iconData: Icons.search_rounded,
                  text: "No products found!",
                )
          : const MyProgressIndicator(),
    );
  }
}
