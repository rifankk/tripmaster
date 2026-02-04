import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripmaster/model/mealsmodel.dart';

import '../pages/addmeals.dart';

class Meals extends StatefulWidget {
  const Meals({super.key});

  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  // Store selected meal IDs
  List<mealsmodel> selectedMeals = [];
  List<String> selectedMealsids = [];

  IconData _getFoodIcon(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('breakfast') || lowerTitle.contains('coffee')) {
      return Icons.free_breakfast;
    } else if (lowerTitle.contains('lunch') || lowerTitle.contains('rice')) {
      return Icons.lunch_dining;
    } else if (lowerTitle.contains('dinner') || lowerTitle.contains('meal')) {
      return Icons.dinner_dining;
    } else if (lowerTitle.contains('pizza')) {
      return Icons.local_pizza;
    } else if (lowerTitle.contains('burger')) {
      return Icons.lunch_dining;
    } else if (lowerTitle.contains('cake') || lowerTitle.contains('dessert')) {
      return Icons.cake;
    } else if (lowerTitle.contains('drink') || lowerTitle.contains('juice')) {
      return Icons.local_drink;
    } else {
      return Icons.restaurant;
    }
  }

  List<Color> _getGradientColors(int index) {
    final gradients = [
      [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
      [Color(0xFF4ECDC4), Color(0xFF44A08D)],
      [Color(0xFFFFBE0B), Color(0xFFFB5607)],
      [Color(0xFF9B59B6), Color(0xFF8E44AD)],
      [Color(0xFF3498DB), Color(0xFF2980B9)],
    ];
    return gradients[index % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Meals').snapshots(),
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No meals yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          final Meals = snapshot.data!.docs
              .map((doc) => mealsmodel.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: Meals.length,
            itemBuilder: (context, index) {
              final meal = Meals[index];
              final gradientColors = _getGradientColors(index);
              final mealId = meal.id;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                  child: Row(
                    children: [
                      // LEFT ICON
                      Container(
                        width: 100,
                        height: 110,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Icon(_getFoodIcon("₹${meal.title}"), size: 50, color: Colors.white),
                      ),

                      // CENTER TEXT
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal.title,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                meal.items,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "₹${meal.price}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: gradientColors[0],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // RIGHT CHECKBOX
                      Checkbox(
                        value: selectedMealsids.contains(meal.id),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedMealsids.add(meal.id);
                            } else {
                              selectedMealsids.remove(meal.id);
                            }
                          });

                          selectedMeals.clear();
                          for (var i = 0; i < Meals.length; i++) {
                            if (selectedMealsids.contains(Meals[i].id)) {
                              selectedMeals.add(Meals[i]);
                            }
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // SUBMIT BUTTON
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            if (selectedMeals.isEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Please select at least one meal")));
              return;
            }

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Meal Saved Successfully!")));

            Navigator.pop(context, selectedMeals);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Submit", style: TextStyle(fontSize: 18)),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Addmeals()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
