import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:products_app/widgets/empty_state_widget.dart';

import '../models/cart.dart';
import '../util/shared_prefs.dart';
import '../widgets/add_remove_widget.dart';

class LastCheckoutScreen extends StatefulWidget {
  const LastCheckoutScreen({super.key});

  @override
  State<LastCheckoutScreen> createState() => _LastCheckoutScreenState();
}

class _LastCheckoutScreenState extends State<LastCheckoutScreen> {
  Map<int, Cart> checkoutItems = {};

  @override
  void initState() {
    super.initState();
    getCheckoutItems();
  }

  getCheckoutItems() {
    try {
      setState(() {
        checkoutItems = SharedPrefs.getCheckoutItems();
        print("checkoutItems: $checkoutItems");
      });
    } catch (e) {
      print(e);
    }
  }

  int getTotalPrice() {
    int totalPrice = 0;
    checkoutItems.forEach((key, value) {
      totalPrice += value.price * value.quantity;
    });
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Last Checkout"),
      ),
      body: checkoutItems.isNotEmpty
          ? Center(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: checkoutItems.length,
                      itemBuilder: (context, index) {
                        Cart cart = checkoutItems.values.elementAt(index);

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              context.push("/product-detail/${cart.id}");
                            },
                            minVerticalPadding: 16,
                            leading: Hero(
                              tag: cart.img,
                              child: Image.network(
                                cart.img,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              cart.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$${cart.price}",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  AddRemoveWidget(
                                    quantity: cart.quantity,
                                    onAdd: () {},
                                    onRemove: () {},
                                    buttonSize: 28,
                                    textSize: 24,
                                    iconSize: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Price:",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "\$${getTotalPrice()}",
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          : const EmptyStateWidget(
              iconData: Icons.shopping_cart_rounded,
              text: "No last checkout!",
            ),
    );
  }
}
