import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation_app/resources/storage_method.dart';
import 'package:graduation_app/models/user.dart' as model;

class AuthMethods {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  //Sign-Up User
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some erroroccured !";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //Register User
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim());

        String profilePicURL = await StorageMethods()
            .uploadImageToStorage("profilePictures", file, false);

        //Add user to our database
        model.User user = model.User(
            email: email,
            uid: credential.user!.uid,
            photoURL: profilePicURL,
            username: username,
            bio: bio,
            followers: [],
            following: []);
        //yukarıda aldığımız bilgilerle userın içeriklerini set ettik
        await _firestore
            .collection("users")
            .doc(credential.user!.uid)
            .set(user.toJson());
        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res = "Email is badly formatted";
      } else if (err.code == "weak-password") {
        res = "Your password must be at least 6 characters";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Login User
  Future<String> logInUser(
      {required String email, required String password}) async {
    String res = "An error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
