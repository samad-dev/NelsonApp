import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String vid;
  final String pid;
  final String title;
  final String variation_name;
  final String category_name;
  final String size;
  final String color;
  final int quantity;
  final double price;
  final String remarks;

  CartItem({
    required this.id,
    required this.vid,
    required this.pid,
    required this.title,
    required this.quantity,
    required this.remarks,
    required this.price,
    required this.size,
    required this.color,
    required this.variation_name,
    required this.category_name,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      vid: json['vid'],
      pid: json['pid'],
      title: json['title'],
      quantity: json['quantity'],
      price: json['price'],
      remarks: json['remarks'],
      size: json['size'],
      color: json['color'],
      variation_name: json['variation_name'],
      category_name: json['category_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["vid"] = this.vid;
    data["title"] = this.title;
    data["quantity"] = this.quantity;
    data["price"] = this.price;
    data["color"] = this.color;
    data["size"] = this.size;
    data["variation_name"] = this.variation_name;
    data["category_name"] = this.category_name;
    data["remarks"] = this.remarks;
    return data;
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {

    return items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total = total + cartItem.price * cartItem.quantity;
    });
    return total;
  }

   addItem(String id, String vid, String pid, double price, String title,
      String size, String color, String variationName, String categoryName, String remarks) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (existing) => CartItem(
                id: existing.id,
                vid: existing.vid,
                pid: existing.pid,
                price: existing.price,
                quantity: existing.quantity + 1,
                title: existing.title,
                size: existing.size,
                color: existing.color,
                variation_name: existing.variation_name,
                category_name: existing.category_name, remarks: existing.remarks,
            ));

      print("$title is added to cart multiple");
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              vid: vid,
              pid: pid,
              quantity: 1,
              title: title,
              size: size,
              color: color, variation_name: variationName, category_name: categoryName, remarks: remarks));
      print("$title is added to cart");
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  set items(Map<String, CartItem> value) {
    _items = value;
  }
}
