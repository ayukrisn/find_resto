import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:find_resto/provider/main/index_nav_provider.dart';
import 'package:find_resto/screens/home/home_screen.dart';
import 'package:find_resto/screens/favourite/favourite_screen.dart';
import 'package:find_resto/screens/settings/setting_screen.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(
        builder: (context, value, child) {
          return switch (value.indexBottomNavBar) {
            1 => const FavouriteScreen(),
            2 => const SettingScreen(),
            _ => const HomeScreen(),
          };
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<IndexNavProvider>().indexBottomNavBar,
        onTap: (index) {
          context.read<IndexNavProvider>().setIndextBottomNavBar = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            tooltip: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favourite",
            tooltip: "Favourite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Pengaturan",
            tooltip: "Pengaturan",
          ),
        ],
      ),
    );
  }
}
