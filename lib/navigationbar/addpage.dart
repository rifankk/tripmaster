import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripmaster/model/activitiesmodel.dart';
import 'package:tripmaster/model/addplace_model.dart';
import 'package:tripmaster/model/mealsmodel.dart';
import 'package:tripmaster/model/nearby_model.dart';
import 'package:tripmaster/pages/add_nearby.dart';
import 'package:tripmaster/service/cloudinary_service.dart';
import 'package:uuid/uuid.dart';
import '../Activities/activitiespage.dart';
import '../Hotel/hotelpage.dart';
import '../Meals/meals.dart';
import '../model/hotelmodel.dart';
import '../model/mainplacemodel.dart';

class Addpage extends StatefulWidget {
  const Addpage({super.key});

  @override
  State<Addpage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<Addpage> {
  final TextEditingController placeCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController baseCtrl = TextEditingController();
  List<Hotelmodel> selectedHotels = [];
  List<Activitiesmodel> selectedActivities = [];
  List<mealsmodel> selectedmeals = [];
  List<Nearbymodel> selectedTemple = [];

  MainPlace? selectedValue;
  final List<String> options = ['Option A', 'Option B', 'Option C', 'Option D'];

  List<String> imageList = [];

  XFile? selimage;
  XFile? selimage2;
  final ImagePicker _picker = ImagePicker();

  Stream<List<MainPlace>> getMainPlaces() {
    return FirebaseFirestore.instance.collection('MainPlace').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return MainPlace.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "AddPlace",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.indigo,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ---------- Place Name ----------
            const Text("Place Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: placeCtrl,
              decoration: InputDecoration(
                hintText: "Enter place name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 20),

            StreamBuilder<List<MainPlace>>(
              stream: getMainPlaces(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No places found");
                }

                final places = snapshot.data!;

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Select Main Place",
                    border: OutlineInputBorder(),
                  ),

                  value: selectedValue?.id, // <---- STRING ID

                  items: places.map((place) {
                    return DropdownMenuItem(
                      value: place.id, // <---- Use ID
                      child: Text(place.title),
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
                );
              },
            ),

            SizedBox(height: 20),

            // ---------- Description ----------
            const Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: descCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter description",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            SizedBox(height: 20),

            const Text("BasePrice", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              controller: baseCtrl,

              decoration: InputDecoration(
                hintText: "Enter BasePrice",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Add 2 Pictures",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                _imageBox(() async {
                  final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() {
                      selimage = XFile(picked.path);
                    });
                  }
                }, selimage),
                _imageBox(() async {
                  final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() {
                      selimage2 = XFile(picked.path);
                    });
                  }
                }, selimage2),
              ],
            ),

            const SizedBox(height: 20),

            // ---------- Add Hotel ----------
            _adminButton(
              "Add Hotel",
              Icons.hotel,
              const Color.fromARGB(255, 220, 222, 221),
              () async {
                List<Hotelmodel>? result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Hotelpage()),
                );

                if (result != null) {
                  selectedHotels = result;
                  setState(() {});
                }
              },
            ),

            selectedHotels.isEmpty
                ? Text("No hotels selected")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: selectedHotels.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.hotel),
                        title: Text(selectedHotels[index].hotel!),
                      );
                    },
                  ),

            const SizedBox(height: 15),

            // ---------- Add Activities ----------
            _adminButton(
              "Add Activities",
              Icons.sports_soccer,
              const Color.fromARGB(255, 219, 216, 212),
              () async {
                List<Activitiesmodel>? result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Activitiespage()),
                );

                if (result != null) {
                  selectedActivities = result;
                  setState(() {});
                }
              },
            ),

            selectedActivities.isEmpty
                ? Text("No activities selected")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: selectedActivities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.sports_esports_outlined),
                        title: Text(selectedActivities[index].title),
                      );
                    },
                  ),

            const SizedBox(height: 15),

            // ---------- Add Meals ----------
            _adminButton(
              "Add Meals",
              Icons.restaurant,
              const Color.fromARGB(255, 215, 211, 211),
              () async {
                List<mealsmodel>? result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Meals()),
                );

                if (result != null) {
                  selectedmeals = result;
                  setState(() {});
                }
              },
            ),

            selectedmeals.isEmpty
                ? Text("No meal selected")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: selectedmeals.length,
                    itemBuilder: (context, Index) {
                      return ListTile(
                        leading: Icon(Icons.fastfood),
                        title: Text(selectedmeals[Index].title),
                      );
                    },
                  ),

            const SizedBox(height: 20),

            _adminButton(
              "Add Nearby",
              Icons.next_plan_rounded,
              const Color.fromARGB(255, 219, 216, 212),
              () async {
                List<Nearbymodel>? result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNearby()),
                );

                if (result != null) {
                  selectedTemple = result;
                  setState(() {});
                }
              },
            ),

            selectedTemple.isEmpty
                ? Text("No nearby selected")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: selectedTemple.length,
                    itemBuilder: (context, Index) {
                      return ListTile(
                        leading: Icon(Icons.temple_buddhist_outlined),
                        title: Text(selectedTemple[Index].title ?? 'N\A'),
                      );
                    },
                  ),

            SizedBox(height: 30),
            // ---------- Submit Button ----------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (placeCtrl.text.isNotEmpty &&
                      descCtrl.text.isNotEmpty &&
                      baseCtrl.text.isNotEmpty &&
                      selectedActivities.isNotEmpty &&
                      selectedHotels.isNotEmpty &&
                      selectedmeals.isNotEmpty &&
                      selectedTemple.isNotEmpty &&
                      selectedValue != null &&
                      selimage != null &&
                      selimage2 != null) {
                    var image1url = await CloudneryUploader().uploadFile(selimage!);
                    var image2url = await CloudneryUploader().uploadFile(selimage2!);
                    PlaceModel body = PlaceModel();
                    body.placename = placeCtrl.text;
                    body.imageUrl = image1url;
                    body.image2Url = image2url;
                    body.description = descCtrl.text;
                    body.BasePrice = baseCtrl.text;
                    body.hotels = selectedHotels;
                    body.activity = selectedActivities;
                    body.meals = selectedmeals;
                    body.nearby = selectedTemple;
                    body.maonplace = selectedValue;
                    body.status = 1;

                    var uuid = Uuid();

                    await FirebaseFirestore.instance
                        .collection('Places')
                        .doc(uuid.v4())
                        .set(body.toMap())
                        .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Success your details"),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          placeCtrl.clear();
                          descCtrl.clear();
                          baseCtrl.clear();
                          selectedActivities = [];
                          selectedHotels = [];
                          selectedmeals = [];
                          selectedTemple = [];
                          selectedValue = null;
                          selimage = null;
                          selimage2 = null;
                          setState(() {});
                        });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please fill fields!"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(255, 111, 119, 168),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems(List<String> items) {
    return items.map((String item) {
      return DropdownMenuItem<String>(value: item, child: Text(item));
    }).toList();
  }

  // --------------------------- Image Box Widget ----------------------------
  Widget _imageBox(Function()? onTap, XFile? file) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 110,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade400),
            color: Colors.grey.shade200,
          ),
          child: file == null
              ? Icon(Icons.add_a_photo, size: 40, color: Colors.black54)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
        ),
      ),
    );
  }

  // --------------------------- Admin Buttons ----------------------------
  Widget _adminButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 24, color: Colors.black),
        label: Text(title, style: const TextStyle(fontSize: 18, color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
