import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../Utils/widgets/snackbar.dart';
import '../Provider/Imageprovider.dart';
FirebaseStorage storage=FirebaseStorage.instance;
FirebaseFirestore firestore=FirebaseFirestore.instance;
class ImageServices {
  Future<File?> pickImage(BuildContext context) async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      return File(pickedImage.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          icon: Icons.warning,
          iconColor: Colors.yellow,
          text: 'No Image Selected',
        ),
      );
      return null;
    }
  }
  static Future<void> uploadImageToFirebaseStorage({
    required File image,
    required BuildContext context,
    required String imageName,
  }) async {
    // Generate a unique ID for the image name using uuid
    String uniqueId = const Uuid().v4();
    String imageExtension = image.path.split('.').last;
    String fullImageName = '$imageName$uniqueId.$imageExtension';

    Reference ref = storage.ref().child('Stores_Images').child(fullImageName);
    await ref.putFile(File(image.path));
    String imageURL = await ref.getDownloadURL();
    Provider.of<ImageClassProvider>(context, listen: false)
        .updateImagesURL(imagesURLs: imageURL);
  }
  static Future<void> addImage({
    required BuildContext context,
    required String imageURL,
  }) async {
    try {
      await firestore.collection('images').add({
        'url': imageURL,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          icon: Icons.check_circle,
          iconColor: Colors.green,
          text: 'Image Uploaded',
        ),
      );
      Provider.of<ImageClassProvider>(context,listen: false).emptyImages();
    } catch (e) {
      log(e.toString());
    }
  }
}
