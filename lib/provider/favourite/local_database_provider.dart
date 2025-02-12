import 'package:find_resto/data/model/restaurant/restaurant.dart';
import 'package:flutter/material.dart';

import 'package:find_resto/data/local/local_database_service.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final LocalDatabaseService _service;

  LocalDatabaseProvider(this._service);

  String _message = "";
  String get message => _message;

  List<Restaurant>? _restaurantList;
  List<Restaurant>? get restaurantList => _restaurantList;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  Future<void> saveRestaurantFav(Restaurant value) async {
   try {
     final result = await _service.insertItem(value);
 
     final isError = result == 0;
     if (isError) {
       _message = "Gagal menyimpan data restoran.";
     } else {
       _message = "Data restoran telah disimpan.";
     }
   } catch (e) {
     _message = "Gagal menyimpan data restoran.";
   }
   notifyListeners();
 }

  Future<void> loadAllRestaurantFav() async {
   try {
     _restaurantList = await _service.getAllItems();
     _restaurant = null;
     _message = "Semua data restoran telah dimuat.";
     notifyListeners();
   } catch (e) {
     _message = "Gagal memuat data restoran.";
     notifyListeners();
   }
 }

 Future<void> loadRestaurantById(String id) async {
   try {
     _restaurant = await _service.getItemById(id);
     _message = "Semua data restoran telah dimuat.";
     notifyListeners();
   } catch (e) {
     _message = "Gagal memuat data restoran.";
     notifyListeners();
   }
 }

  Future<void> removeRestaurantById(String id) async {
   try {
     await _service.removeItem(id);
 
     _message = "Data restoran telah dihapus.";
     notifyListeners();
   } catch (e) {
     _message = "Data restoran gagal dihapus.";
     notifyListeners();
   }
 }

  bool checkItemFav(String id) {
  bool isSameRestaurant = false;
  if (_restaurant == null) {
    isSameRestaurant = false;
  } else {
    isSameRestaurant = _restaurant!.id == id;
  }
  return isSameRestaurant;
 }
}
