import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class Services {
  static const String baseUrl = "https://dummyjson.com/";

  static Future<List<String>> getCategories() async {
    final response = await http.get(Uri.parse("${baseUrl}products/categories"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception("Failed to load categories!");
    }
  }

  static Future<List<Product>> getProductsByCategory(String category) async {
    http.Response response;
    if (category == "all-products") {
      response = await http.get(Uri.parse("${baseUrl}products"));
    } else {
      response =
          await http.get(Uri.parse("${baseUrl}products/category/$category"));
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data["products"].map<Product>((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products!");
    }
  }

  static Future<Product> getProductById(int productId) async {
    final response = await http.get(Uri.parse("${baseUrl}products/$productId"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception("Failed to load product!");
    }
  }

  static Future<List<Product>> searchProducts(String query) async {
    final response =
        await http.get(Uri.parse("${baseUrl}products/search?q=$query"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data["products"].map<Product>((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products!");
    }
  }
}
