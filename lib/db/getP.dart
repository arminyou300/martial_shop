import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopswift/db/products.dart';

Future<List<FirebaseProduct>> fetchProductsFromFirestore() async {
  QuerySnapshot querySnapshot =
  await FirebaseFirestore.instance.collection('products').get();

  return querySnapshot.docs.map((doc) =>
      FirebaseProduct.fromDocumentSnapshot(doc)).toList() as List<
      FirebaseProduct>;
}
