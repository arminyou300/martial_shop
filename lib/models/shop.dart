import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopswift/models/product.dart';
import 'package:flutter/cupertino.dart';

class Shop extends ChangeNotifier{
  // Available Products
  var collection = FirebaseFirestore.instance.collection('products');

  Future<List<Product>> fetchProducts() async {
    var snapshot = await collection.get();
    return snapshot.docs.map((doc) {
      var data = doc.data();
      return Product(
        data['name'],
        data['price'],
        data['description'],
        data['imagePath'],
      );
    }).toList();
  }


  final List<Product> boxing = [
    Product('Boxing sweat suit', 100.0, "Boxing sweat suit is good for boxers who wants to sweat fast and ...",'assets/images/sweat-suit.png'),
    Product('Venum Boxing Gloves', 90.0, "Black boxing gloves with bright Venum logo on it ...",'assets/images/gloves.png'),
    Product('Nike Hyper-ko 2', 100.0, "Nike hyper-ko 2 is the most comfortable shoes for boxing ..." ,'assets/images/shoes.png'),
  ];
  final List<Product> mma = [
    Product('UFC MMA Gloves', 120.0, "description", 'assets/images/ufc.png'),
    Product('UFC Mitts', 80.0, "description", 'assets/images/ufc-mitts.png'),
    Product('UFC Hand Wraps', 10.0, "description", 'assets/images/ufc-hand-wraps.png'),
  ];
  final List<Product> bags = [
    Product('Everlast Heavy Bag', 80.0, "Heavy bag", 'assets/images/bag3.png'),
    Product('Punching Dummy', 403.0, "Standing punching dummy", 'assets/images/bag2.png'),
    Product('Standing Bag', 10.0, "description", 'assets/images/bag1.png'),
    Product('Grappling Dummy', 200.0, "Grappling dummy good for BJJ , judo and wrestling", 'assets/images/bag4.png'),
  ];
  final List<Product> other = [
    Product('Timex UFC Watch', 50.0, "Stylish UFC watch that makes you a real man ...",'assets/images/watch.png'),
  ];
  // User Cart
  final List<Product> _cart = [];

  // Get Product List
  List<Product> get boxingP => boxing;
  List<Product> get mmaP => mma;
  List<Product> get bagsP => bags;
  List<Product> get otherP => other;
  // Get User Cart
  List<Product> get cart => _cart;

  // Add Item To Cart
  void addToCart(Product item){
    _cart.add(item);
    notifyListeners();
  }
  // Remove Item To Cart
  void removeFromCart(Product item){
    _cart.remove(item);
    notifyListeners();
  }
  void removeAllFromCart(){
    _cart.clear();
    notifyListeners();
  }

}