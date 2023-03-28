import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPreferences;

  static initialize() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    } else {
      return _sharedPreferences;
    }
  }

  static setCartItems(Map<int, Cart> cartItems) {
    List<String> sharedCartList =
        cartItems.values.map((e) => cartToJson(e)).toList();
    _sharedPreferences!.setStringList("cartItems", sharedCartList);
  }

  static Map<int, Cart> getCartItems() {
    List<String> sharedCartList =
        _sharedPreferences!.getStringList("cartItems") ?? [];

    Map<int, Cart> cartItems = {};
    for (String str in sharedCartList) {
      Cart cart = cartFromJson(str);
      cartItems[cart.id] = cart;
    }
    return cartItems;
  }

  static setCheckoutItems(Map<int, Cart> cartItems) {
    List<String> sharedCartList =
        cartItems.values.map((e) => cartToJson(e)).toList();
    _sharedPreferences!.setStringList("checkoutItems", sharedCartList);
  }

  static Map<int, Cart> getCheckoutItems() {
    List<String> sharedCartList =
        _sharedPreferences!.getStringList("checkoutItems") ?? [];

    Map<int, Cart> cartItems = {};
    for (String str in sharedCartList) {
      Cart cart = cartFromJson(str);
      cartItems[cart.id] = cart;
    }
    return cartItems;
  }
}
