import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MySlider extends StatefulWidget {
  const MySlider({Key? key}) : super(key: key);

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _getStream();
  }

  Stream<QuerySnapshot> _getStream() {
    return FirebaseFirestore.instance.collection('banners').snapshots();
  }

  void _refreshData() {
    setState(() {
      _stream = _getStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(
            color: Colors.transparent,
          );
        }
        return SizedBox(
          height: 220,
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider.builder(
            itemCount: snapshot.data!.docs.length,
            options: CarouselOptions(
              height: 220.0,
              enableInfiniteScroll: true,
              autoPlay: true,
            ),
            itemBuilder: (context, index, realIndex) {
              final document = snapshot.data!.docs[index];
              String? imageUrl = (document.data() as Map<String, dynamic>)['picture'] as String?;
              if (imageUrl == null) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(25),
                    child: const Icon(Icons.error),
                  ),
                );
              } else {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(25),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
