import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/home_page.dart';

class HomeScreenController extends StateNotifier<HomePageModel> {
  HomeScreenController() : super(const HomePageModel(selectedIndex: 0));

  @override
  void dispose() {
    super.dispose();
  }

  void updateSelectedIndex(newIndex) {
    state = state.copyWith(selectedIndex: newIndex);
  }
}
