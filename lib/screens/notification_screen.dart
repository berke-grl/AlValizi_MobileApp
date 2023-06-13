import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/resources/firestore_method.dart';

// Sayfa daha bitmedi
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String userID = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> changedPosts = [];
  List<String> userNames = [];
  bool isLoading = true;

  void getLastUpdates() {
    final docRef = FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: userID)
        .snapshots()
        .listen((event) async {
      for (var change in event.docChanges) {
        Map<String, dynamic> changedPost = {
          "postURL": change.doc.data()!['postURL'],
          "likedBy": change.doc.data()!['likes'],
        };
        if (changedPost["likedBy"].length != 0) {
          changedPosts.add(changedPost);
          for (var username in changedPost["likedBy"]) {
            String name = await FireStoreMethod().findUsername(username);
            setState(() {
              userNames.add(name);
            });
          }
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getLastUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .where("uid", isEqualTo: userID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
          return changedPosts.isEmpty
              ? const Center(
                  child: Text("No notification ..."),
                )
              : isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    )
                  : ListView.builder(
                      itemCount: changedPosts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                changedPosts[index]['postURL'].toString()),
                          ),
                          title:
                              Text(userNames.isEmpty ? "" : userNames[index]),
                        );
                      },
                    );
        },
      ),
    );
  }
}
