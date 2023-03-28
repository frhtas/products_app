import 'package:flutter/material.dart';
import 'package:products_app/screens/last_checkout_screen.dart';
import 'package:products_app/screens/product_detail_screen.dart';
import 'package:products_app/util/shared_prefs.dart';
import 'package:products_app/widgets/add_remove_widget.dart';
import 'package:products_app/widgets/empty_state_widget.dart';

import '../models/cart.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  Map<int, Cart> cartItems = {};

  @override
  void initState() {
    super.initState();
    getCartItems();
  }

  getCartItems() {
    try {
      setState(() {
        cartItems = SharedPrefs.getCartItems();
        print("cartItems: $cartItems");
      });
    } catch (e) {
      print(e);
    }
  }

  int getTotalPrice() {
    int totalPrice = 0;
    cartItems.forEach((key, value) {
      totalPrice += value.price * value.quantity;
    });
    return totalPrice;
  }

  showMyDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Ürünler Kaldırılacak!'),
        content:
            const Text('Sepetinizdeki ürünler kaldırılacak, emin misiniz?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                cartItems = {};
                SharedPrefs.setCartItems(cartItems);
              });
              Navigator.of(context).pop();
            },
            child: const Text('TAMAM'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LastCheckoutScreen(),
                ),
              );
            },
            tooltip: "Show Last Checkout",
            icon: const Icon(Icons.shopping_cart_checkout_rounded),
          ),
          cartItems.isNotEmpty
              ? IconButton(
                  onPressed: () => showMyDialog(),
                  tooltip: "Remove All",
                  icon: const Icon(Icons.remove_shopping_cart_rounded),
                )
              : Container()
        ],
      ),
      body: cartItems.isNotEmpty
          ? Center(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        Cart cart = cartItems.values.elementAt(index);

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailScreen(productId: cart.id),
                                ),
                              )
                                  .then((value) {
                                getCartItems();
                              });
                            },
                            minVerticalPadding: 16,
                            leading: Image.network(
                              cart.img,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
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
                                    onAdd: () {
                                      setState(() {
                                        cart.quantity++;
                                        cartItems[cart.id] = cart;
                                        SharedPrefs.setCartItems(cartItems);
                                        print(cart.toJson());
                                      });
                                    },
                                    onRemove: () {
                                      setState(() {
                                        if (cart.quantity > 0) {
                                          cart.quantity--;
                                          if (cart.quantity == 0) {
                                            cartItems.remove(cart.id);
                                          } else {
                                            cartItems[cart.id] = cart;
                                          }
                                          SharedPrefs.setCartItems(cartItems);
                                          print(cart.toJson());
                                        }
                                      });
                                    },
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
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
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Map<int, Cart> checkoutItems = cartItems;
                              cartItems = {};
                              SharedPrefs.setCartItems(cartItems);
                              SharedPrefs.setCheckoutItems(checkoutItems);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              )),
                          child: const Text("Checkout"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          : const EmptyStateWidget(
              iconData: Icons.shopping_cart_rounded,
              text: "No items in cart!",
            ),
    );
  }
}
