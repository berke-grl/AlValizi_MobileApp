import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_app/models/post.dart';
import 'package:graduation_app/resources/location_services.dart';
import 'package:graduation_app/resources/storage_method.dart';
import 'package:graduation_app/screens/map_screen.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    String uid,
    String username,
    String profileImage,
    Uint8List file,
  ) async {
    String res = "Some error occured!";
    try {
      Position positionDetails = await LocationServices.getCurrentLocation();
      var placeAddress = await LocationServices.getPlaceAddress(
          positionDetails.latitude, positionDetails.longitude);
      String postURL = await StorageMethods()
          .uploadImageToStorage("postPictures", file, true);
      String randomTimeBased = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postID: randomTimeBased,
        datePublished: DateTime.now(),
        postURL: postURL,
        profileImage: profileImage,
        likes: [],
        address: placeAddress['results'][0]['address_components'][3]
            ['long_name'],
        coordinates: {
          "latitude": placeAddress['results'][0]['geometry']['location']['lat'],
          "longitude": placeAddress['results'][0]['geometry']['location']['lng']
        },
      );
      MapScreenState.myMarkers.add(
        Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          markerId: const MarkerId("exapmle"),
          position: LatLng(positionDetails.latitude, positionDetails.longitude),
          infoWindow: const InfoWindow(title: "Post", snippet: "exapmple"),
        ),
      );
      await _firestore
          .collection("posts")
          .doc(randomTimeBased)
          .set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postID, String userID, List likes) async {
    try {
      if (likes.contains(userID)) {
        await _firestore.collection("posts").doc(postID).update({
          "likes": FieldValue.arrayRemove([userID])
        });
      } else {
        await _firestore.collection("posts").doc(postID).update({
          "likes": FieldValue.arrayUnion([userID])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> postComment(String name, String text, String postID,
      String userID, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentID = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postID)
            .collection("comments")
            .doc(commentID)
            .set({
          "profileImage": profilePic,
          "name": name,
          "commentID": commentID,
          "uid": userID,
          "text": text,
          "postID": postID,
          "datePublished": DateTime.now(),
          "likes": []
        });
      } else {
        print("text is empty");
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> likeComment(
      String postID, String commentID, String userID, List likes) async {
    try {
      if (likes.contains(userID)) {
        await _firestore
            .collection("posts")
            .doc(postID)
            .collection("comments")
            .doc(commentID)
            .update({
          "likes": FieldValue.arrayRemove([userID])
        });
      } else {
        await _firestore
            .collection("posts")
            .doc(postID)
            .collection("comments")
            .doc(commentID)
            .update({
          "likes": FieldValue.arrayUnion([userID])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> deletePost(String postID) async {
    try {
      await _firestore.collection("posts").doc(postID).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser(String userID, String followID) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection("users").doc(userID).get();
      List following = (snap.data()! as dynamic)["following"];
      if (following.contains(followID)) {
        await _firestore.collection("users").doc(followID).update({
          "followers": FieldValue.arrayRemove([userID])
        });
        await _firestore.collection("users").doc(userID).update({
          "following": FieldValue.arrayRemove([followID])
        });
      } else {
        await _firestore.collection("users").doc(followID).update({
          "followers": FieldValue.arrayUnion([userID])
        });
        await _firestore.collection("users").doc(userID).update({
          "following": FieldValue.arrayUnion([followID])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  ////
  Future<String> findUsername(String userID) async {
    final userName = await _firestore.collection("users").doc(userID).get();
    return userName['username'];
  }
}
