import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final double price;
  final String description;
  final String imagePath;

  Product(
    this.name,
    this.price,
    this.description,
    this.imagePath,
  );

  toJson() {
    return {
      "Name": name,
      "Price": price,
      "Description": description,
      "Image Path": imagePath
    };
  }
}
