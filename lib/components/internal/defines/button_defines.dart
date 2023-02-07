// Flutter imports:
import 'package:flutter/material.dart';

class ButtonIcon {
  final Widget? icon;
  final Color? backgroundColor;

  const ButtonIcon({this.icon, this.backgroundColor});
}

const controlBarButtonBackgroundColor = Colors.white;
final controlBarButtonCheckedBackgroundColor =
    const Color(0xff2C2F3E).withOpacity(0.6);

typedef ButtonClickBoolCallback = void Function(bool isON);
