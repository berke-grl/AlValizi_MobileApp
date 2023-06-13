import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:graduation_app/providers/user_provider.dart';
import 'package:graduation_app/resources/firestore_method.dart';
import 'package:graduation_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:graduation_app/models/user.dart' as model;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  void sharePost(String uid, String username, String profileImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FireStoreMethod().uploadPost(
          _captionController.text, uid, username, profileImage, _file!);
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showSnackBar("Posted", context, Colors.green);
        clearImageData();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context, Colors.red);
      }
    } catch (err) {
      showSnackBar(err.toString(), context, Colors.red);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  void clearImageData() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed: clearImageData,
        ),
        title: const Text("Share Post"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoading
                ? const AlertDialog(
                    scrollable: true,
                    title: Text("Image is uploading ... "),
                    content: SizedBox(
                      height: 100,
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user.photoURL),
                      ),
                      const SizedBox(width: 200, child: Divider(thickness: 2)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              Uint8List? file =
                                  await pickImage(ImageSource.camera);
                              setState(() {
                                _file = file;
                              });
                            },
                            icon: const Icon(Icons.camera_alt_rounded),
                          ),
                          IconButton(
                            onPressed: () async {
                              Uint8List? file =
                                  await pickImage(ImageSource.gallery);
                              setState(() {
                                _file = file;
                              });
                            },
                            icon: const Icon(Icons.photo),
                          ),
                        ],
                      ),
                      _file == null
                          ? const SizedBox(height: 50)
                          : Column(
                              children: [
                                SizedBox(
                                  height: 320,
                                  width: 300,
                                  child: AspectRatio(
                                    aspectRatio: 487 / 451,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: MemoryImage(_file!),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: double.infinity),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    controller: _captionController,
                                    decoration: const InputDecoration(
                                      hintText: "Write caption ...",
                                      border: InputBorder.none,
                                      focusedBorder: UnderlineInputBorder(),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => sharePost(
                                      user.uid, user.username, user.photoURL),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    elevation: 10,
                                  ),
                                  child: const Text("SHARE"),
                                ),
                              ],
                            ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
