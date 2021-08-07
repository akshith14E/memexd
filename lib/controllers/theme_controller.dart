import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final ThemeData themeData;
  const ThemeState._(this.themeData);

  factory ThemeState.dark() => ThemeState._(ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: kPrimaryColor,
      dividerColor: kShadeTwoDark,
      cardColor: kShadeOneDark,
      sliderTheme: SliderThemeData().copyWith(
          thumbColor: Colors.orange,
          activeTrackColor: kPrimaryColor,
          inactiveTrackColor: kShadeTwoDark),
      iconTheme: IconThemeData().copyWith(color: kShadeTwoDark, size: 32),
      textTheme: TextTheme().copyWith(
          bodyText1: TextStyle(color: kShadeTwoDark),
          bodyText2: TextStyle(color: kShadeThreeDark)),
      scaffoldBackgroundColor: kAppBackgroundColorDark,
      highlightColor: Colors.white,
      backgroundColor: kShadeOneDark));

  factory ThemeState.light() => ThemeState._(ThemeData.light().copyWith(
      brightness: Brightness.light,
      primaryColor: kPrimaryColor,
      dividerColor: kShadeTwoLight,
      cardColor: kShadeOneLight,
      sliderTheme: SliderThemeData().copyWith(
          thumbColor: Colors.orange,
          activeTrackColor: kPrimaryColor,
          inactiveTrackColor: kShadeTwoDark),
      iconTheme: IconThemeData().copyWith(color: kShadeTwoLight, size: 32),
      textTheme: TextTheme().copyWith(
          bodyText1: TextStyle(color: kShadeTwoLight),
          bodyText2: TextStyle(color: kShadeThreeLight)),
      highlightColor: Colors.black87,
      scaffoldBackgroundColor: kAppBackgroundColorLight,
      backgroundColor: kShadeOneLight));

  bool operator ==(Object o) {
    if (identical(this, 0)) return true;
    return o is ThemeState && o.themeData.brightness == themeData.brightness;
  }

  @override
  int get hashCode => themeData.hashCode;
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeState>((ref) {
  final _prefs = ref.watch(sharedPrefsProvider)!;
  return ThemeController(_prefs);
});

class ThemeController extends StateNotifier<ThemeState> {
  SharedPreferences _preferences;
  static final key = 'lightTheme';

  ThemeController(this._preferences) : super(ThemeState.light()) {
    state = _getThemeFromPref() ? ThemeState.light() : ThemeState.dark();
  }

  bool getTheme() {
    return _getThemeFromPref();
  }
  void toggleTheme() {
    _setThemeToPref(state == ThemeState.dark());
    state == ThemeState.dark()
        ? state = ThemeState.light()
        : state = ThemeState.dark();
  }

  void _setThemeToPref(bool value) async {
    await _preferences.setBool(key, value);
  }

  bool _getThemeFromPref() {
    if (_preferences.getBool(key) == null)
      return true;
    else
      return _preferences.getBool(key)!;
  }
}
