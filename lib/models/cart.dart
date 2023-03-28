import 'dart:convert';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  int id;
  String title;
  int price;
  int quantity;
  String img;

  Cart({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.img,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        quantity: json["quantity"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "quantity": quantity,
        "img": img,
      };
}
