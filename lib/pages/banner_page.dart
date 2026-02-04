// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripmaster/model/addplace_model.dart';
import 'package:tripmaster/service/cloudinary_service.dart';
import 'package:uuid/uuid.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  final TextEditingController bannerCtrl = TextEditingController();

  PlaceModel? selectedValue;
  final List<String> options = ['option A', 'option B', 'option C', 'option D'];

  XFile? image;
  final ImagePicker_picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? picked = await ImagePicker_picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        image = XFile(picked.path);
      });
    }
  }

  Stream<List<PlaceModel>> getMainPlaces() {
    return FirebaseFirestore.instance.collection('Places').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PlaceModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(" Banner Name", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
        
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: TextFormField(
                controller: bannerCtrl,
                decoration: InputDecoration(
                  hintText: "Enter Banner Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
        
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("Enter Your Places", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        
            SizedBox(height: 18),
            StreamBuilder<List<PlaceModel>>(
              stream: getMainPlaces(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(" No places found");
                }
        
                final places = snapshot.data!;
        
                return Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: DropdownButtonFormField<String>(
                    
                    decoration: InputDecoration(
                      
                      labelText: "Select Places",
                      border: OutlineInputBorder(),
                    ),
                    
                    
        initialValue:selectedValue?.id ,
                    items: places.map((place) {
                      return DropdownMenuItem(
                        value: place.id, // <---- Use ID
                        child: Text("${place.placename}"),
                      );
                    }).toList(),
        
                    onChanged: (value) {
                      for (var i = 0; i < places.length; i++) {
                        if (places[i].id == value) {
                          setState(() {
                            selectedValue = places[i]; // save place ID
                          });
                        }
                      }
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(" Add Picture", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        
            SizedBox(height: 15),
            Row(children: [_imageBox()]),
        
            SizedBox(height: 35),
        
            Center(
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () async {
                    
                    var uuid = Uuid();
                    var id = uuid.v4();
                    String? imageurl;
                      
                    if (image != null) {
                      imageurl = await CloudneryUploader().uploadFile(image!);
                    }
                    try {
                      await FirebaseFirestore.instance.collection('bannerslide').doc(id).set({
                        "id": id,
                        "place": selectedValue?.toMap(),
                        "image": imageurl,
                        "bannername":bannerCtrl.text
                      });
                      
                      Navigator.pop(context);
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    backgroundColor: const Color.fromARGB(255, 45, 53, 107),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text("Add", style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageBox() {
    return Expanded(
      child: GestureDetector(
        onTap: () => pickImage(ImageSource.gallery),
        child: Padding(
          padding: const EdgeInsets.only(left: 15,right: 10),
          child: Container(
            height: 170,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.grey.shade200,
            ),
            child: image == null
                ? Icon(Icons.add_a_photo, size: 40, color: Colors.black54)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      File(image!.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
