import 'package:flutter/material.dart';

class Product1 {
  final int id;
  final String title, description;
  final String images;
  final String colors;
  final String category_id;
  final String sizes;
  final double rating, price;
  final bool isFavourite, isPopular;

  Product1({
    required this.id,
    required this.images,
    required this.category_id,
    required this.colors,
    required this.sizes,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });

  factory Product1.fromMap(Map<String, dynamic> json) => Product1(
    id: json['id'],
    images: json['images'],
    category_id: json['category_id'],
    colors: json['colors'],
    title: json['title'],
    price: double.parse(json['price']),
    sizes: (json['sizes']),
    description: json['description'],
    isFavourite: true,
    isPopular: true,

  );


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'images':images,
      'category_id':category_id,
      'colors':colors,
      'rating':rating,
      'isFavourite':isFavourite,
      'isPopular':isPopular,
      'title':title,
      'price':price,
      'sizes':sizes,
      'description':description,

    };
  }
}

// Our demo Products



const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
