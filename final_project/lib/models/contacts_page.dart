import 'package:freezed_annotation/freezed_annotation.dart';

part 'contacts_page.freezed.dart';

@freezed
class ContactsPageModel with _$ContactsPageModel {
  const factory ContactsPageModel({
    required bool isAdding,
    required bool isAddCintactButtonActive,
  }) = _ContactsPageModel;
}
