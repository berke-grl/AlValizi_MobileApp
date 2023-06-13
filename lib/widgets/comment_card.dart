import 'package:flutter/material.dart';
import 'package:graduation_app/resources/firestore_method.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  CommentCard({super.key, required this.snap});
  final Map<String, dynamic> snap;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap["profileImage"]),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${widget.snap["name"]} ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          children: [
                            TextSpan(
                              text: widget.snap["text"],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap["datePublished"].toDate()),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w200),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                IconButton(
                  icon: Icon(
                    widget.snap["likes"].contains(widget.snap["uid"])
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    FireStoreMethod().likeComment(
                        widget.snap["postID"],
                        widget.snap["commentID"],
                        widget.snap["uid"],
                        widget.snap["likes"]);
                  },
                ),
                Text("${widget.snap["likes"].length} likes")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
