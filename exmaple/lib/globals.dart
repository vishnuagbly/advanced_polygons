import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

extension ScreenDouble on double {
  double get w => this * Globals.screenWidth;

  double get h => this * Globals.screenHeight;
}

class Globals {
  final BuildContext context;
  final ThemeData theme;
  FlutterView? _view;
  static Globals? _instance;

  FlutterView get view {
    _view ??= View.of(context);
    return _view!;
  }

  static Globals get instance {
    final instance = _instance;
    if (instance == null) throw AssertionError('Globals not initialized');
    return instance;
  }

  Globals._(this.context) : theme = Theme.of(context);

  static initialize(BuildContext context) => _instance = Globals._(context);

  //Here we are creating a static function instead of final value, because
  //screen size can change during the app, in case of resizing of window in web
  //or desktop
  static double get rawScreenWidth =>
      instance.view.physicalSize.width / instance.view.devicePixelRatio;

  static double get rawScreenHeight =>
      instance.view.physicalSize.height / instance.view.devicePixelRatio;

  static double get screenWidth => min(rawScreenWidth, 500);

  static double get screenHeight => rawScreenHeight;

  static double get screenPadding => min(min(10, 0.1.w), 0.1.h);

  static double get borderRadiusValue => 0.03.w;

  static const gravatarUrl = "https://www.gravatar.com/avatar";

  static BorderRadius get borderRadius =>
      BorderRadius.circular(borderRadiusValue);

  static String? validateNum(String? text, [bool isDouble = true]) {
    text ??= '';
    if (text.isEmpty) return null;
    final value = isDouble ? double.tryParse(text) : int.tryParse(text);
    if (value == null) {
      return 'Value should be of ${isDouble ? 'double' : 'int'} type';
    }
    return null;
  }

  //Constants
  ///Border Radius Value used in [kCircularBorder].
  static const kCircularBorderRadiusValue = 1e+5;

  ///Completely Circular Border
  static const kCircularBorder =
      BorderRadius.all(Radius.circular(kCircularBorderRadiusValue));

  static const kDisabledOpacity = 0.3;

  static const kTypeWriterSpeed = Duration(milliseconds: 100);
}
