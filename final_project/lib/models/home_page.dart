import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page.freezed.dart';

@freezed
class HomePageModel with _$HomePageModel {
  const factory HomePageModel({
    required int selectedIndex,
  }) = _HomePageModel;
}
