import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:products_app/models/cart.dart';
import 'package:products_app/util/services.dart';
import 'package:products_app/util/shared_prefs.dart';
import 'package:products_app/widgets/add_remove_widget.dart';
import 'package:products_app/widgets/my_progress_indicator.dart';

import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? product;
  Cart? cart;
  Map<int, Cart> cartItems = {};

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  getProduct() {
    try {
      Services.getProductById(widget.productId).then((value) {
        setState(() {
          product = value;
          print(product!.toJson());

          cartItems = SharedPrefs.getCartItems();
          print("cartItems: $cartItems");

          if (cartItems.containsKey(product!.id)) {
            cart = cartItems[product!.id];
          } else {
            cart = Cart(
              id: product!.id,
              title: product!.title,
              price: product!.price,
              quantity: 0,
              img: product!.thumbnail,
            );
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return product != null
        ? Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                mini: true,
                child: const Icon(Icons.arrow_back),
              ),
            ),
            body: Column(
              children: [
                Image.network(
                  product!.images[0],
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                ),
                const SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: product!.rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ignoreGestures: true,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star_rounded,
                    color: Colors.orangeAccent,
                  ),
                  unratedColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  product!.title,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Brand: ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          product!.brand,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description: ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          product!.description,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  height: 80,
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "\$${product!.price}",
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AddRemoveWidget(
                        quantity: cart!.quantity,
                        onAdd: () {
                          setState(() {
                            cart!.quantity++;
                            cartItems[cart!.id] = cart!;
                            SharedPrefs.setCartItems(cartItems);
                            print(cart!.toJson());
                          });
                        },
                        onRemove: () {
                          setState(() {
                            if (cart!.quantity > 0) {
                              cart!.quantity--;
                              if (cart!.quantity == 0) {
                                cartItems.remove(cart!.id);
                              } else {
                                cartItems[cart!.id] = cart!;
                              }
                              SharedPrefs.setCartItems(cartItems);
                              print(cart!.toJson());
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: Colors.white,
            child: const MyProgressIndicator(),
          );
  }
}
