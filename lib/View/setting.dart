import 'dart:io';
import 'package:flutter/material.dart';
import 'package:internship_task/Controller/Services/imageServices.dart';
import 'package:provider/provider.dart';
import '../Controller/Provider/Imageprovider.dart';
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final provider=Provider.of<ImageClassProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Page',style: TextStyle(color: Colors.white,fontSize: 16),),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<ImageClassProvider>(
              builder: (context,productProvider,child){
                return Builder(builder: (context){
                  if(productProvider.image==null)
                  {
                    return InkWell(
                      onTap: (){
                        productProvider.fetchImagesFromGallery(context: context);
                      },
                      child: Container(
                        height: height*0.6,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add,size: height*0.07,color: Colors.grey,),
                              const Text('Upload Image',style: TextStyle(fontSize: 20,color: Colors.grey))
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  else
                  {
                    File images=Provider.of<ImageClassProvider>(context,listen: false).image!;
                    return Container(
                      height: height*0.6,
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        //color: Colors.amber,
                          image: DecorationImage(
                            image: FileImage(File(images.path)),fit: BoxFit.cover,
                          )
                      ),
                    );
                  }
                });
              },
            ),
            SizedBox(height: height*0.05,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                minimumSize: Size(width, height * 0.08),
              ),
              onPressed: ()async{
                provider.setImageSaving();
                if(provider.image!=null){
                  String imageName = 'image';
                  await ImageServices.uploadImageToFirebaseStorage(image: provider.image!, context: context, imageName: imageName);
                  if(provider.imageUrL!=null){
                    await ImageServices.addImage(context: context, imageURL: provider.imageUrL);
                  }
                }
                provider.setImageSaving();
            },
              child: provider.imageSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Save',
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
