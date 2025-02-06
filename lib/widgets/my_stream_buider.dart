import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopswift/widgets/my_blank_product_tile.dart';
import 'package:shopswift/widgets/my_product_tile.dart';

// ignore: must_be_immutable
class MyStreamBuilder extends StatefulWidget {
  const MyStreamBuilder({super.key, required this.productUID});

  final String productUID;

  @override
  State<MyStreamBuilder> createState() => _MyStreamBuilderState();
}

class _MyStreamBuilderState extends State<MyStreamBuilder> {
  var collection = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: collection.doc(widget.productUID).snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return Text('Error = ${snapshot.error}');
        }
        print(snapshot.connectionState);
        if(snapshot.connectionState == ConnectionState.active && snapshot.connectionState != ConnectionState.none) {
          if (snapshot.hasData) {
            var output = snapshot.data!.data();
            var name = output!['name'];
            var price = output['price'];
            var picture = output['picture'];

            return MyProductTile(
              productName: name,
              productPrice: price,
              productPicture: picture,
              productUID: widget.productUID,
            );
          }
        } else {
          return const MyBlankProductTile();

        }
        return const MyBlankProductTile();

      },
    );
  }
}
