import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  Profile? profile;
  bool isLoading = false;

  Future<void> fetchProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      profile = await UserService().getProfile();
    } catch (e) {
      print(e);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(String name, String phone) async {
    await UserService().updateProfile(name, phone);
    await fetchProfile(); // reload
  }
}