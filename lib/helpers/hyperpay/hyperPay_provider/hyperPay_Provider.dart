import 'package:flutter/material.dart';

class HyperPayProvider with ChangeNotifier{
  bool isLoading=false;
  setIsLoading(bool value){
    isLoading=value;
    notifyListeners();
  }
  /// get checkoutId

}