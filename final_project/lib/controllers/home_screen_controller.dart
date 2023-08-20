import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb hide PhoneAuthProvider;

class HomeScreenController extends StateNotifier<HomePageModel> {
  HomeScreenController() : super(const HomePageModel(selectedIndex: 0));

  void updateSelectedIndex(newIndex) {
    state = state.copyWith(selectedIndex: newIndex);
  }
}
