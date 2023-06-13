import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postID;
  final datePublished;
  final String postURL;
  final String profileImage;
  final likes;
  final String address;
  final Map<String, double> coordinates;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postID,
    required this.datePublished,
    required this.postURL,
    required this.profileImage,
    required this.likes,
    this.address = "",
    this.coordinates = const {},
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postID": postID,
        "datePublished": datePublished,
        "postURL": postURL,
        "profileImage": profileImage,
        "likes": likes,
        "address": address,
        "coordinates": coordinates
      };

  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(
      description: snap["description"],
      uid: snap["uid"],
      username: snap["username"],
      postID: snap["postID"],
      datePublished: snap["datePublished"],
      postURL: snap["postURL"],
      profileImage: snap["profileImage"],
      likes: ["likes"],
    );
  }
}
