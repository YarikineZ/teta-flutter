import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/models/contacts_page.dart';
import 'package:messenger/services/realtime_db_servise.dart';
import 'package:messenger/services/user_service.dart';

class ContactsScreenController extends StateNotifier<ContactsPageModel> {
  final TextEditingController textEditingController = TextEditingController();
  final RealtimeDbService realtimeDbService = GetIt.I.get<RealtimeDbService>();
  final UserService userService = GetIt.I.get<UserService>();

  ContactsScreenController() : super(const ContactsPageModel(isAdding: false));

  void showAddContactWindow() {
    state = state.copyWith(isAdding: true);
  }

  void hideAddContactWindow() {
    state = state.copyWith(isAdding: false);
  }

  void addContact() {
    realtimeDbService.addContact(
        userService.user.id, textEditingController.text);
  }
}
