import 'package:shopswift/models/product.dart';
import 'package:shopswift/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopswift/pages/products_page.dart';

class MyProductTile extends StatefulWidget {
  // final Product product;
  final String productUID;
  final String productName;
  final num productPrice;
  final String productPicture;

  MyProductTile({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productPicture,
    required this.productUID,
  });

  @override
  State<MyProductTile> createState() => _MyProductTileState();
}

class _MyProductTileState extends State<MyProductTile> {
  void navigateToCart() {
    Navigator.pushNamed(context, '/cart_page');
  }

  // Add To Cart
  // void addToCart(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       alignment: Alignment.center,
  //       content: const Text(
  //         'Add this item to cart?',
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           color: Colors.black,
  //           fontFamily: 'Ubuntu',
  //         ),
  //       ),
  //       actionsAlignment: MainAxisAlignment.spaceBetween,
  //       actions: [
  //         MaterialButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             context.read<Shop>().addToCart(widget.product);
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 action: SnackBarAction(
  //                   label: 'Cart',
  //                   onPressed: () => navigateToCart(),
  //                 ),
  //                 duration: const Duration(seconds: 5),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 elevation: 10,
  //                 backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  //                 behavior: SnackBarBehavior.floating,
  //                 content: const Text(
  //                   'Item successfully added to cart',
  //                 ),
  //               ),
  //             );
  //           },
  //           child: const Text('Yes'),
  //         ),
  //         MaterialButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: const Text('No'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductsPage(productUID: widget.productUID),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(25),
          width: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Image.network(
                        widget.productPicture,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return SizedBox(
                            height: 25,
                            width: 25,
                            child: Center(
                              child: CircularProgressIndicator(

                                color: Colors.black,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.productName,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Ubuntu',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '\$${widget.productPrice}',
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Ubuntu',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
