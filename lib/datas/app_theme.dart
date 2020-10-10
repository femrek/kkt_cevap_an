import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppTheme {
  static const int SYSTEM = 0;
  static const int LIGHT = 1;
  static const int DARK = 2;

  static bool _isDark;
  static int _theme; // 0 => System Default | 1 => Light | 2 => Dark



  static Color primaryDark;
  static Color primary;
  static Color accent;
  static Color onAccent;

  static Color appBarBg;

  static Color scaffoldBg;
  static Color scaffoldBgDark;
  static Color onScaffold;

  static Color cardBg;
  static Color cardTitle;
  static Color cardDisabledBg;
  static Color onCardDisabled;
  static Color cardAlertBg;
  static Color onCardAlert;

  static Color shadowColor;

  static Color drawerBg;
  static Color drawerTileBg;
  static Color drawerTileText;
  static Color drawerTileTextActive;
  static Color drawerTileRadioUnselected;
  static Color drawerTileRadioActive;



  static final Map<String, Color> appColorsDark = {
    'primaryDark': const Color(0xff021c1e),
    'primary': ThemeData.dark().primaryColor,
    'accent': const Color(0xff66eeff),
    'onAccent': Colors.black,

    'appBarBg': ThemeData.dark().primaryColor,

    'scaffoldBg': ThemeData.dark().scaffoldBackgroundColor,
    'scaffoldBgDark': const Color(0xff2a2a2a),
    'onScaffold': Colors.white,

    'cardBg': ThemeData.dark().cardColor,
    'cardTitle': Colors.white,
    'cardDisabledBg': Color(0xff444444),
    'onCardDisabled': Color(0xff666666),
    'cardAlertBg': Color(0xffff2222),
    'onCardAlert': Colors.white,

    'shadowColor': Colors.black54,

    'drawerBg': const Color(0xff111111),
    'drawerTileBg': const Color(0xff222222),
    'drawerTileText': const Color(0xffeeeeee),
    'drawerTileTextActive': const Color(0xff66eeff), //0xff9999ff
    'drawerTileRadioUnselected': const Color(0xffaaaaaa),
    'drawerTileRadioActive': const Color(0xff66eeff),
  };

  static final Map<String, Color> appColorsLight = {
    'primaryDark': const Color(0xff018786),
    'primary': const Color(0xff018786),
    'accent': const Color(0xff18FFFF),
    'onAccent': Colors.black,

    'appBarBg': const Color(0xff018786),

    'scaffoldBg': ThemeData.light().scaffoldBackgroundColor,
    'scaffoldBgDark': const Color(0xffe5e5e5),
    'onScaffold': Colors.black,

    'cardBg': const Color(0xffc5c5c5),
    'cardTitle': Colors.black,
    'cardDisabledBg': Color(0xff444444),
    'onCardDisabled': Color(0xff444444),
    'cardAlertBg': Color(0xffff2222),
    'onCardAlert': Colors.white,

    'shadowColor': Colors.black54,

    'drawerBg': const Color(0xffeeeeee),
    'drawerTileBg': const Color(0xffd2d2d2),
    'drawerTileText': const Color(0xff111111),
    'drawerTileTextActive': const Color(0xff11c0c0), //0xff5544dd
    'drawerTileRadioUnselected': const Color(0xff333333),
    'drawerTileRadioActive': const Color(0xff11c0c0),
  };

  static getOptionsFromDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _theme = prefs.getInt('theme') ?? 0;
    setIsDarkWithTheme();
  }

  static bool get isDark {
    return _isDark;
  }

  static int get theme {
    return _theme;
  }


  static setColorsValue() {
    primaryDark = _isDark ? appColorsDark['primaryDark'] : appColorsLight['primaryDark'];
    primary = _isDark ? appColorsDark['primary'] : appColorsLight['primary'];
    accent = _isDark ? appColorsDark['accent'] : appColorsLight['accent'];
    onAccent = _isDark ? appColorsDark['onAccent'] : appColorsLight['onAccent'];
    appBarBg = _isDark ? appColorsDark['appBarBg'] : appColorsLight['appBarBg'];
    scaffoldBg = _isDark ? appColorsDark['scaffoldBg'] : appColorsLight['scaffoldBg'];
    scaffoldBgDark = _isDark ? appColorsDark['scaffoldBgDark'] : appColorsLight['scaffoldBgDark'];
    onScaffold = _isDark ? appColorsDark['onScaffold'] : appColorsLight['onScaffold'];
    cardBg = _isDark ? appColorsDark['cardBg'] : appColorsLight['cardBg'];
    cardTitle = _isDark ? appColorsDark['cardTitle'] : appColorsLight['cardTitle'];
    cardDisabledBg = _isDark ? appColorsDark['cardDisabledBg'] : appColorsLight['cardDisabledBg'];
    onCardDisabled = _isDark ? appColorsDark['onCardDisabled'] : appColorsLight['onCardDisabled'];
    cardAlertBg = _isDark ? appColorsDark['cardAlertBg'] : appColorsLight['cardAlertBg'];
    onCardAlert = _isDark ? appColorsDark['onCardAlert'] : appColorsLight['onCardAlert'];
    shadowColor = _isDark ? appColorsDark['shadowColor'] : appColorsLight['shadowColor'];
    drawerBg = _isDark ? appColorsDark['drawerBg'] : appColorsLight['drawerBg'];
    drawerTileBg = _isDark ? appColorsDark['drawerTileBg'] : appColorsLight['drawerTileBg'];
    drawerTileText = _isDark ? appColorsDark['drawerTileText'] : appColorsLight['drawerTileText'];
    drawerTileTextActive = _isDark ? appColorsDark['drawerTileTextActive'] : appColorsLight['drawerTileTextActive'];
    drawerTileRadioUnselected = _isDark ? appColorsDark['drawerTileRadioUnselected'] : appColorsLight['drawerTileRadioUnselected'];
    drawerTileRadioActive = _isDark ? appColorsDark['drawerTileRadioActive'] : appColorsLight['drawerTileRadioActive'];
  }

  static setIsDarkWithTheme() {
    switch (_theme) {
      case 1:
        {
          _isDark = false;
        }
        break;
      case 2:
        {
          _isDark = true;
        }
        break;
      default:
        {
          _isDark = (SchedulerBinding.instance.window.platformBrightness ==
              Brightness.dark);
        }
        break;
    }
    setColorsValue();
  }
  /// example: AppTheme.setTheme(AppTheme.Dark);
  static setTheme(int theme) {
    _theme = theme;
    setIsDarkWithTheme();
    _updateTheme();
  }

  static void _updateTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', _theme);
  }

}
