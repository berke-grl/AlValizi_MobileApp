import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/resources/firestore_method.dart';
import 'package:graduation_app/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap["postID"])
            .collection("comments")
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) => CommentCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 16),
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                        hintText: "Comment ...", border: InputBorder.none),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FireStoreMethod().postComment(
                      user.username,
                      _commentController.text,
                      widget.snap["postID"],
                      user.uid,
                      user.photoURL);
                  setState(() {
                    _commentController.text = "";
                    FocusScope.of(context).unfocus();
                  });
                },
                child: const Icon(
                  Icons.send,
                  color: Colors.lightGreen,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
