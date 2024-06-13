import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Utils/widgets/menu_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  late List<bool> favoriteStatuses = [];
  late List<DocumentSnapshot> images = [];

  @override
  void initState() {
    super.initState();
    fetchImagesAndFavorites();
  }

  Future<void> fetchImagesAndFavorites() async {
    final snapshot = await FirebaseFirestore.instance.collection('images').get();
    final fetchedImages = snapshot.docs;
    final fetchedFavorites =
    await Future.wait<bool>(fetchedImages.map((image) => checkFavoriteStatus(image['url'])));

    setState(() {
      images = fetchedImages;
      favoriteStatuses = fetchedFavorites;
    });
  }

  Future<bool> checkFavoriteStatus(String imageUrl) async {
    final favoriteRef = FirebaseFirestore.instance.collection('favorites');
    final snapshot = await favoriteRef.where('url', isEqualTo: imageUrl).get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: images.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];

          return Stack(
            children: [
              Image.network(
                image['url'],
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Positioned(
                top: height * 0.1,
                left: width * 0.06,
                child: Container(
                  height: height * 0.055,
                  width: width * 0.11,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                  child: const MenuIcon(),
                ),
              ),
              Positioned(
                right: width * 0.005,
                bottom: height * 0.1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite_outlined,
                        color: favoriteStatuses[index] ? Colors.red : Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        toggleFavorite(image['url'], index); // Pass index to toggleFavorite
                      },
                    ),
                    SizedBox(height: height * 0.03),
                    Column(
                      children: [
                        const Icon(Icons.comment, color: Colors.white, size: 30),
                        Text(
                          '23',
                          style: textTheme.labelSmall!.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    Column(
                      children: [
                        const Icon(Icons.share, color: Colors.white, size: 30),
                        Text(
                          '16',
                          style: textTheme.labelSmall!.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: width * 0.025,
                bottom: height * 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@Whatnia',
                      style: textTheme.labelSmall!.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      'Dont Know how to finish this tiktok',
                      style: textTheme.labelSmall!.copyWith(color: Colors.white),
                    ),
                    Text(
                      '#hashtag #second #third #fourth #fifth',
                      style: textTheme.labelSmall!.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void toggleFavorite(String imageUrl, int index) async {
    final favoriteRef = FirebaseFirestore.instance.collection('favorites');
    final snapshot = await favoriteRef.where('url', isEqualTo: imageUrl).get();
    if (snapshot.docs.isNotEmpty) {
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      setState(() {
        favoriteStatuses[index] = false; // Update favorite status
      });
    } else {
      await favoriteRef.add({'url': imageUrl});
      setState(() {
        favoriteStatuses[index] = true; // Update favorite status
      });
    }
  }
}
