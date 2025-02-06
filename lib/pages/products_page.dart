import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopswift/widgets/button_filled.dart';
import 'package:shopswift/widgets/zoomable_picture.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.productUID});

  final String productUID;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  var collection = FirebaseFirestore.instance.collection('products');
  var cart = FirebaseFirestore.instance.collection('users-cart');
  String? usrEmail = FirebaseAuth.instance.currentUser?.email;
  int? clickedIndex;

  List<DropdownMenuEntry> dropDown = [];

  final PageController _pageController = PageController();
  int currentPage = 0;
  List imageList = [];
  String selectedSize = "";
  String selectedColor = "";
  int quan = 1;
  bool? sizeNull = false;

  Future<void> addToCart(String docName, String selectedSize,
      BuildContext context, var collection, String productUID, num quan) async {
    final currentContext = context;

    showDialog(
      context: currentContext,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        content: const Text(
          'Add this item to cart?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Ubuntu',
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          MaterialButton(
            onPressed: () async {
              final FirebaseFirestore firestore = FirebaseFirestore.instance;
              try {
                DocumentSnapshot<Map<String, dynamic>> anotherDocSnapshot =
                    await collection.doc(productUID).get();
                if (!anotherDocSnapshot.exists) {
                  return;
                }
                Map<String, dynamic> anotherDocData =
                    anotherDocSnapshot.data()!;
                var sizes = anotherDocData['size'];

                if (currentContext.mounted) Navigator.of(currentContext).pop();
                CollectionReference collectionRef =
                    firestore.collection('users-cart');
                DocumentReference docRef = collectionRef.doc(docName);
                DocumentSnapshot<Map<String, dynamic>> docSnapshot =
                    await docRef.get()
                        as DocumentSnapshot<Map<String, dynamic>>;

                // Create a map with common fields
                Map<String, dynamic> cartItem = {
                  'product name': anotherDocData['name'],
                  'price': anotherDocData['price'],
                  'picture': anotherDocData['picture'],
                  'quantity': quan,
                };
                // Conditionally add 'size' field only if selectedSize is not empty

                // Check if sizes are available for this product
                if (sizes != null && sizes.isNotEmpty) {
                  if (selectedSize.isNotEmpty == true) {
                    cartItem['size'] = selectedSize;
                  } else {
                    showSnackBar("You didn't selected a size", '', () {},
                        currentContext);
                    return;
                  }
                }
                if (selectedColor.isNotEmpty == true) {
                  cartItem['color'] = selectedColor;
                } else {
                  showSnackBar(
                      "You didn't selected a color", '', () {}, currentContext);
                  return;
                }

                if (docSnapshot.exists) {
                  // Update Firestore document
                  await docRef.update({
                    'items': FieldValue.arrayUnion([cartItem]),
                  });
                } else {
                  await docRef.set({
                    'items': FieldValue.arrayUnion([cartItem]),
                  });
                }

                showSnackBar('Item Added Successfully', 'Cart',
                    () => navigateToCart, currentContext);
              } catch (e) {
                showSnackBar(
                    'There was a problem by adding this item to your cart',
                    '',
                    () {},
                    currentContext);
              }
            },
            child: const Text('Yes'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(currentContext);
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  void navigateToCart(BuildContext context) {
    Navigator.of(context).pushNamed('/cart_page');
  }

  void showSnackBar(String message, String snackBarActionLabel,
      Function() function, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: snackBarActionLabel.isNotEmpty
            ? SnackBarAction(label: snackBarActionLabel, onPressed: function)
            : null,
        elevation: 10,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
        ),
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.yellow;
      case 'gold':
        return const Color(0xffdaa520);
      case 'silver':
        return const Color(0xffC0C0C0);
      case 'blue':
        return Colors.blue;
      case 'beige':
        return const Color(0xffce7c61);

      default:
        return Colors.transparent;
    }
  }

  TextEditingController controller = TextEditingController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height.roundToDouble() - 80,
          color: Colors.transparent,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          future: collection.doc(widget.productUID).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(
                                backgroundColor: Colors.transparent,
                                color: Colors.transparent,
                              );
                            }
                            if (snapshot.hasError) {
                              return Text('Error = ${snapshot.error}');
                            }
                            if (snapshot.hasData) {
                              var output = snapshot.data!.data();
                              var picture = output!['picture'];
                              var picture2 = output['picture2'];
                              var picture3 = output['picture3'];
                              var picture4 = output['picture4'];
                              var picture5 = output['picture5'];

                              // Ensure picture is not null before adding it to the list
                              imageList = [
                                if (picture != null) picture,
                                if (picture2 != null) picture2,
                                if (picture3 != null) picture3,
                                if (picture4 != null) picture4,
                                if (picture5 != null) picture5,
                              ]
                                  .where((element) => element != null)
                                  .cast<String>()
                                  .toList();

                              return Column(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: PageView.builder(
                                      controller: _pageController,
                                      itemCount: imageList.length,
                                      physics: const BouncingScrollPhysics(),
                                      onPageChanged: (value) {
                                        currentPage = value;
                                      },
                                      pageSnapping: true,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.all(5),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ZoomableImageView(
                                                    imageUrl: imageList,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Image.network(
                                              imageList[index],
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return IconButton(
                                                  onPressed: () {
                                                    // Retry loading picture
                                                    var newSnapshot = collection
                                                        .doc(widget.productUID)
                                                        .get();
                                                    newSnapshot.then((newData) {
                                                      if (newData.exists) {
                                                        var newOutput =
                                                            newData.data()!;
                                                        var newPicture =
                                                            newOutput[
                                                                'picture'];
                                                        imageList[index] =
                                                            newPicture;
                                                      }
                                                    });
                                                    if (error
                                                        .toString()
                                                        .contains('403')) {
                                                      showSnackBar(
                                                          'Internet connection failed.\n(Use VPN or if it\'s on, turn it off)',
                                                          '',
                                                          () {},
                                                          context);
                                                    }
                                                  },
                                                  icon:
                                                      const Icon(Icons.replay),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  SmoothPageIndicator(
                                    controller: _pageController,
                                    onDotClicked: (index) {
                                      _pageController.jumpToPage(index);
                                    },
                                    count: imageList.length,
                                    effect: ScrollingDotsEffect(
                                      activeDotColor: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      dotColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      dotHeight: 10,
                                      dotWidth: 10,
                                    ),
                                  )
                                ],
                              );
                            }
                            return const SizedBox(); // Return an empty SizedBox if none of the conditions are met
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          color: Colors.grey.shade200,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: 5,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FutureBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                                future: collection.doc(widget.productUID).get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error = ${snapshot.error}');
                                  }
                                  if (snapshot.hasData) {
                                    var output = snapshot.data!.data();
                                    var name = output!['name'];
                                    var description = output['description'];
                                    var price = output['price'];
                                    var colors =
                                        output['colors'] as List<dynamic>?;
                                    List<String> words = name.split(' ');
                                    if (words.length >= 5) {
                                      name =
                                          '${words.take(2).join(' ')}\n${words.skip(2).join(' ')}';
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                name,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Ubuntu',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Text(
                                                '\$$price',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Ubuntu',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            description,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Ubuntu',
                                              fontWeight: FontWeight.w300,
                                              fontSize: 17,
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          FutureBuilder<
                                              DocumentSnapshot<
                                                  Map<String, dynamic>>>(
                                            future: collection
                                                .doc(widget.productUID)
                                                .get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                // While data is loading, return a loading indicator or placeholder
                                                return const CircularProgressIndicator(
                                                  color: Colors.transparent,
                                                );
                                              } else if (snapshot.hasError) {
                                                // If there's an error, display an error message
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else if (snapshot.data ==
                                                      null ||
                                                  snapshot.data!.data() ==
                                                      null) {
                                                // If snapshot data is null or empty, return a placeholder widget
                                                return const SizedBox(
                                                    height: 70);
                                              } else {
                                                var output =
                                                    snapshot.data!.data();
                                                var sizes = output!['size'];
                                                if (sizes == null ||
                                                    sizes is! List) {
                                                  sizeNull = true;
                                                  return const SizedBox(
                                                    height: 10,
                                                  );
                                                } else {
                                                  List<DropdownMenuEntry>
                                                      dropDown = [];
                                                  for (int i = 0;
                                                      i < sizes.length;
                                                      i++) {
                                                    dropDown.add(
                                                      DropdownMenuEntry(
                                                        value: i,
                                                        label: sizes[i]
                                                            .toString()
                                                            .toUpperCase(),
                                                      ),
                                                    );
                                                  }
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      sizeNull == false
                                                          ? const Text(
                                                              'Select Size',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Ubuntu',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 15,
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      DropdownMenu(
                                                        hintText: 'Size',
                                                        dropdownMenuEntries:
                                                            dropDown,
                                                        controller: controller,
                                                        onSelected: (value) {
                                                          final newSelectedSize =
                                                              dropDown[value]
                                                                  .label;
                                                          setState(() {
                                                            selectedSize =
                                                                newSelectedSize;
                                                            quan = 1;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          colors != null
                                              ? const Text(
                                                  'Select Color',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Ubuntu',
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 15,
                                                  ),
                                                )
                                              : const SizedBox(
                                                  height: 100,
                                                ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // ignore: prefer_is_empty
                                          colors?.length != 0
                                              ? Row(
                                                  children: List.generate(
                                                    colors?.length ?? 0,
                                                    (index) => Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              clickedIndex =
                                                                  index;
                                                              selectedColor =
                                                                  colors[index];
                                                            });
                                                          },
                                                          child: Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              border:
                                                                  Border.all(
                                                                color: clickedIndex ==
                                                                        index
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .transparent,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  10,
                                                                ),
                                                                child:
                                                                    ColoredBox(
                                                                  color:
                                                                      _getColorFromName(
                                                                    colors![
                                                                        index],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    );
                                  }
                                  return const Text(
                                      'This Product doesn\'t exist anymore');
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ButtonFilled(
                                    buttonWidth: 248,
                                    buttonHeight: 40,
                                    buttonBackgroundColor: Colors.grey.shade400,
                                    buttonBorderRadius: 10,
                                    onTap: () {
                                      addToCart(
                                          usrEmail!,
                                          selectedSize,
                                          context,
                                          collection,
                                          widget.productUID,
                                          quan);
                                    },
                                    child: const Text(
                                      'Add To Cart',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Ubuntu',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        // Change this value to adjust the size of the circle
                                        height: 40,
                                        // Use the same value as width to maintain a perfect circle
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade400,
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              if (quan == 0) {
                                              } else {
                                                setState(() {
                                                  quan--;
                                                });
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.remove,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        quan.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Ubuntu',
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 40,
                                        // Change this value to adjust the size of the circle
                                        height: 40,
                                        // Use the same value as width to maintain a perfect circle
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade400,
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                quan++;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
