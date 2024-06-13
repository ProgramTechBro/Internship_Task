import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:internship_task/Controller/Services/imageServices.dart';
ImageServices services=ImageServices();
class ImageClassProvider extends ChangeNotifier{
  File? image;
  String imageUrL='';
  String updateImageUrL='';
  bool imageSaving=false;
  fetchImagesFromGallery({required BuildContext context}) async {
    image = await services.pickImage(context);
    notifyListeners();
  }
  updateImagesURL({required String imagesURLs}) async {
    imageUrL =imagesURLs;
    notifyListeners();
  }
  emptyImages() {
    image = null;
    imageUrL='';
    notifyListeners();
  }
  setImageSaving()
  {
    imageSaving=!imageSaving;
    notifyListeners();
  }

}