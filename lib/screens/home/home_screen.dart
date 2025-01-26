import 'package:dio/dio.dart';
import 'package:find_resto/data/api/restaurant_service.dart';
import 'package:find_resto/screens/home/restaurant_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Calling the getRestaurants() method
    RestaurantService().getRestaurants();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Find Resto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mau makan apa hari ini?",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
                itemCount: 15, // Number of times to display RestaurantCard
                itemBuilder: (context, index) {
                  return  RestaurantCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}