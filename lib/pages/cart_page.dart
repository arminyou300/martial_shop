import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:shopswift/widgets/button_filled.dart';
import 'package:flutter/material.dart';
import 'package:shopswift/widgets/my_bottom_appbar.dart';
import 'package:uni_links/uni_links.dart';
import 'package:zarinpal/src/call_backs.dart';
import 'package:zarinpal/zarinpal.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late StreamSubscription sub;
  String receivedLink = '';
  final PaymentRequest paymentRequest = PaymentRequest();
  int quan = 1;

  void showSnackBar(
      String message, String snackBarActionLabel, void Function() function) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(label: snackBarActionLabel, onPressed: function),
        elevation: 10,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Remove All Button Pressed
    void removeAll(BuildContext context) {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle the case where the user is not signed in
        return;
      }

      // Get a reference to the user's cart document
      final cartDocRef =
          FirebaseFirestore.instance.collection('users-cart').doc(user.email);

      // Update the cart document to remove all items
      cartDocRef.update({'items': FieldValue.delete()}).then((_) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 10,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            behavior: SnackBarBehavior.floating,
            content: const Text(
              'All items successfully removed from cart',
            ),
          ),
        );
      }).catchError((error) {
        // Handle errors
      });
    }

    User? user = FirebaseAuth.instance.currentUser;
    var collection =
        FirebaseFirestore.instance.collection('users-cart').doc(user?.email);

    // Future<void> cartIsEmpty()async{
    //   if(collection.length = 0){}
    // }
    // Single Remove Button Pressed
    void removeItemFromCart(BuildContext context, int index) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          alignment: Alignment.center,
          content: const Text(
            'Remove this item from your cart?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Ubuntu',
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            // Remove
            MaterialButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);

                // Get the current user
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  // Handle the case where the user is not signed in
                  return;
                }

                // Remove the item from the cart by index
                FirebaseFirestore.instance
                    .collection('users-cart')
                    .doc(user.email)
                    .get()
                    .then((doc) {
                  if (doc.exists) {
                    List<dynamic> items = doc.data()?['items'] ?? [];
                    if (index >= 0 && index < items.length) {
                      items.removeAt(index);
                      doc.reference.update({'items': items}).then((_) {
                        // Show a success message
                      }).catchError((error) {
                        // Handle errors
                      });
                    }
                  }
                  showSnackBar(
                    'Item successfully removed from cart',
                    '',
                    () {},
                  );
                }).catchError((error) {
                  // Handle errors accessing the cart document
                  showSnackBar('Error accessing to cart', 'retry', () {
                    removeItemFromCart(context, index);
                  });
                });
              },
              child: const Text('Yes'),
            ),
            // Don't Remove
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
          ],
        ),
      );
    }

    void removeItem(BuildContext context, int index) {
      // Close the dialog
      Navigator.pop(context);

      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle the case where the user is not signed in
        return;
      }

      // Remove the item from the cart by index
      FirebaseFirestore.instance
          .collection('users-cart')
          .doc(user.email)
          .get()
          .then((doc) {
        if (doc.exists) {
          List<dynamic> items = doc.data()?['items'] ?? [];
          if (index >= 0 && index < items.length) {
            items.removeAt(index);
            doc.reference.update({'items': items}).then((_) {
              // Show a success message
            }).catchError((error) {
              // Handle errors
            });
          }
        }
        showSnackBar(
          'Item successfully removed from cart',
          '',
          () {},
        );
      }).catchError((error) {
        // Handle errors accessing the cart document
        showSnackBar('Error accessing to cart', 'retry', () {
          removeItemFromCart(context, index);
        });
      });
    }

    int selectedIndex = 0;

    void _onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });

      // Navigation logic here
      switch (index) {
        case 0:
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            ModalRoute.withName('/'),
          );
          break;
        case 1:
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/profile_page',
            ModalRoute.withName('/'),
          );
          break;
        case 2:
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/category_page',
            ModalRoute.withName('/'),
          );
          break;
        case 3:
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/cart_page',
            ModalRoute.withName('/'),
          );
          break;
      }
    }

    bool snackBarShown = false;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: collection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show a loading indicator while waiting for data
              }
              var data = snapshot.data!.data();
              var items = data?['items'];
              if (items != null) {
                return MaterialButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: const Text(
                          "Remove all the items in cart?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Ubuntu',
                          ),
                        ),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        alignment: Alignment.center,
                        actions: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                              removeAll(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 10,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  behavior: SnackBarBehavior.floating,
                                  content: const Text(
                                    'All items successfully removed from cart',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Yes'),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.remove_done,
                    color: Colors.black,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: Icon(Icons.remove_done,
                      color: Colors.grey.withOpacity(0.9)),
                );
              }
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cart Page'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: collection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error = ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: Text(
                      'There are no items here...',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 25,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  );
                }
                var data = snapshot.data!.data();
                if (data == null ||
                    !data.containsKey('items') ||
                    data['items'] == null ||
                    (data['items'] as List).isEmpty) {
                  return Center(
                    child: Text(
                      'There are no items here...', // Message to display
                      style: TextStyle(
                        fontFamily: 'Ubuntu', // Font family
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary, // Text color
                        fontSize: 25, // Font size
                        fontWeight: FontWeight.w100, // Font weight
                      ),
                    ),
                  );
                }

                var items = data['items'] as List<dynamic>;
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    var item = items[index];
                    var name = item['product name'];
                    var price = item['price'];
                    var size = item['size'];
                    var picture = item['picture'];
                    var quantity = item['quantity'];

                    return Container(
                      height: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              picture,
                              height: 90,
                              width: 90,
                              errorBuilder: (context, error, stackTrace) {
                                if (!snackBarShown) {
                                  snackBarShown = true;
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    showSnackBar(
                                      "Couldn't connect to the database.\nUse a VPN",
                                      '',
                                      () {},
                                    );
                                  });
                                }
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 74,
                                    width: 74,
                                    child: Icon(
                                      Icons.replay,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontFamily: 'Ubuntu',
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    size == null ? '' : size.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () =>
                                    removeItemFromCart(context, index),
                                icon: const Icon(
                                  Icons.remove_shopping_cart,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 20);
                  },
                  itemCount: items.length,
                );
              },
            ),
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: collection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error = ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              // Initialize sum
              num allSum = 0;

              // Check if the snapshot contains data and if the document exists
              if (snapshot.hasData && snapshot.data!.exists) {
                // Access the document data
                final data = snapshot.data!.data();

                // Assuming 'items' is the field containing the array of items
                final List<dynamic>? items = data?['items'];

                // Calculate the total sum of prices
                if (items != null) {
                  allSum = items.fold(0, (previousValue, item) {
                    // Assuming each item has a 'price' field
                    final price = item['price'] ?? 0;
                    var qty = item['quantity'];
                    return (previousValue + price) * qty;
                  });
                }
              }

              // Build the UI with the total sum
              return allSum == 0
                  ? const Text('')
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Text(
                            'Total = \$${allSum.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ButtonFilled(
                            buttonWidth: MediaQuery.of(context).size.width - 40,
                            buttonHeight: 80,
                            buttonBackgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            buttonBorderRadius: 15,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: const Text(
                                    "You will now redirect to payment gateway",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Ubuntu',
                                    ),
                                  ),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  alignment: Alignment.center,
                                  actions: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        sub = linkStream.listen((String? link) {
                                          //https://kaajdev.ir/?Authority=000000000000000000000000000001371747&Status=OK
                                          receivedLink = link!;
                                          if (receivedLink
                                              .toLowerCase()
                                              .contains('status')) {
                                            String status =
                                                receivedLink.split('=').last;
                                            String authority = receivedLink
                                                .split('?')[1]
                                                .split('&')[0]
                                                .split('=')[1];
                                            ZarinPal().verificationPayment(
                                              status,
                                              authority,
                                              paymentRequest,
                                              (isPaymentSuccess, refID,
                                                  paymentRequest, data) {
                                                {
                                                  if (isPaymentSuccess) {
                                                    print('Success');
                                                  } else {
                                                    print('Error');
                                                  }
                                                }
                                              },
                                            );
                                          }
                                        }, onError: (error) {
                                          print(error);
                                        });
                                      },
                                      child: const Text('OK'),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Ubuntu',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          )
        ],
      ),
    );
  }
}
