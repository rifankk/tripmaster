import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripmaster/model/nearby_model.dart';

class AddNearby extends StatefulWidget {
  const AddNearby({super.key});

  @override
  State<AddNearby> createState() => _AddNearbyState();
}

class _AddNearbyState extends State<AddNearby> {
  List<Nearbymodel> nearby = [];
  String? selectedTemple;

  final List<String> places = ['Temple', ' Church', 'Masjid', 'Toilet', 'Pumbs'];

  TextEditingController latitudeCtrl = TextEditingController();
  TextEditingController longitudeCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Nearby'),
        centerTitle: true,
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Temples",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: selectedTemple,
                hint: const Text("Choose one"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                items: places.map((place) {
                  return DropdownMenuItem<String>(value: place, child: Text(place));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTemple = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              if (selectedTemple != null)
                Text(
                  "Selected: $selectedTemple",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Latitude",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: latitudeCtrl,
                          decoration: InputDecoration(
                            hintText: "Latitude",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Longitude",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: longitudeCtrl,
                          decoration: InputDecoration(
                            hintText: "Longitude",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (selectedTemple == null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Please Select a temple")));
                    } else if (latitudeCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Please Select latitude")));
                    } else if (longitudeCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Please Select longitude")));
                    } else {
                      nearby.add(
                        Nearbymodel(
                          title: selectedTemple,
                          lat: double.tryParse(latitudeCtrl.text) ?? 0.0,
                          log: double.tryParse(longitudeCtrl.text) ?? 0.0,
                        ),
                      );
                      selectedTemple = null;
                      latitudeCtrl.clear();
                      longitudeCtrl.clear();

                      setState(() {});
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 220,
                    // ignore: sort_child_properties_last
                    child: Center(
                      child: Text(
                        "Add",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: nearby.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(nearby[index].title ?? 'N/A'));
                },
              ),
              Center(
                child: GestureDetector(
                  onTap: () async{
                    if (nearby.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Please select at least one nearby")));
                      return;
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Nearby Saved Successfully!")));

                    Navigator.pop(context, nearby);
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    // ignore: sort_child_properties_last
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
