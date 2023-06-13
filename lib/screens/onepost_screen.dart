import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/resources/location_services.dart';

import 'package:graduation_app/widgets/post_card.dart';

class OnePostScreen extends StatefulWidget {
  OnePostScreen({super.key, required this.postID});
  final String postID;

  @override
  State<OnePostScreen> createState() => _OnePostScreenState();
}

class _OnePostScreenState extends State<OnePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Icon(Icons.cases_sharp),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(widget.postID)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                }
                return Column(
                  children: [
                    PostCard(
                      snap: snapshot.data!.data()!,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(snapshot.data!['address']),
                          Image(
                            image: NetworkImage(
                              LocationServices.getPlaceLocationImage(
                                  snapshot.data!['coordinates']['latitude'],
                                  snapshot.data!['coordinates']['longitude']),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
