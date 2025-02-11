import 'package:flutter/widgets.dart';
 
class FavouriteIconProvider extends ChangeNotifier {
 bool _isFavourited = false;
 
 bool get isFavourited => _isFavourited;
 
 set isFavourited(bool value) {
   _isFavourited = value;
   notifyListeners();
 }
}