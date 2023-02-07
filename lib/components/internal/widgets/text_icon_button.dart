// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:zego_uikit/components/internal/internal.dart';

class ZegoTextIconButton extends StatefulWidget {
  final String? text;
  final ButtonIcon? icon;

  final Size? iconSize;
  final double? iconTextSpacing;
  final Size? buttonSize;

  ///  You can do what you want after clicked.
  final VoidCallback? onPressed;

  const ZegoTextIconButton({
    Key? key,
    this.text,
    this.icon,
    this.iconTextSpacing,
    this.iconSize,
    this.buttonSize,
    this.onPressed,
  }) : super(key: key);

  @override
  State<ZegoTextIconButton> createState() => _ZegoTextIconButtonState();
}

class _ZegoTextIconButtonState extends State<ZegoTextIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget(),
          ...text(),
        ],
      ),
    );
  }

  Widget iconWidget() {
    if (widget.icon == null) {
      return Container();
    }

    return Container(
      width: widget.buttonSize?.width ?? 50.w,
      height: widget.buttonSize?.width ?? 50.h,
      decoration: BoxDecoration(
        color: widget.icon?.backgroundColor ?? Colors.transparent,
      ),
      child: SizedBox(
        width: widget.iconSize?.width ?? 50.w,
        height: widget.iconSize?.height ?? 50.h,
        child: widget.icon?.icon ??
            Image(
              image: UIKitImage.asset(StyleIconUrls.inviteVideo).image,
              fit: BoxFit.fill,
            ),
      ),
    );
  }

  List<Widget> text() {
    if (widget.text == null || widget.text!.isEmpty) {
      return [];
    }

    return [
      SizedBox(height: widget.iconTextSpacing ?? 12.r),
      Text(
        widget.text!,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.none,
        ),
      ),
    ];
  }

  void onPressed() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }
}
