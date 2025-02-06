import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProduct {
  final String name;
  final double price;
  final String description;
  final String imagePath;

  FirebaseProduct({
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });

  factory FirebaseProduct.fromJson(Map<String, dynamic> json) {
    return FirebaseProduct(
      name: json['name'],
      price: json['price'],
      description: json['description'],
      imagePath: json['imagePath'],
    );
  }

  static fromDocumentSnapshot(QueryDocumentSnapshot<Object?> doc) {}
}