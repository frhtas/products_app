import 'package:dropdown_button2/dropdown_button2.dart';
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

  List<String> items = ["Default", "Rating", "Price"];
  String? selectedValue = "Default";

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
          print(products);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  sortProductsBy(String value) {
    if (value == items[1]) {
      products.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (value == items[2]) {
      products.sort((a, b) => b.price.compareTo(a.price));
    } else {
      getProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return products.isNotEmpty
        ? Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sort by',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 40),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: selectedValue == item
                                          ? Theme.of(context).primaryColor
                                          : Colors.black87,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                            sortProductsBy(selectedValue!);
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          height: 40,
                          width: 90,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 200,
                  ),
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductCard(product: products[index]);
                  },
                ),
              ),
            ],
          )
        : const MyProgressIndicator();
  }
}
