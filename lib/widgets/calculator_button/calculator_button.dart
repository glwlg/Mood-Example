import 'package:flutter/material.dart';

///
import 'package:flutter_screenutil/flutter_screenutil.dart';

///
import 'package:moodexample/themes/app_theme.dart';

/// 操作按钮
class CalculatorButton extends StatelessWidget {
  const CalculatorButton({
    Key? key,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.style,
    this.text,
    this.child,
    this.onTap,
  }) : super(key: key);

  /// 语义描述
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final ButtonStyle? style;
  final String? text;
  final Widget? child;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    // 屏幕自适应 设置尺寸（填写设计中设备的屏幕尺寸）如果设计基于360dp * 690dp的屏幕
    ScreenUtil.init(
      context,
      designSize: Size(AppTheme.wdp, AppTheme.hdp),
    );

    ///
    final double getWidth = width ?? 48.w;
    final double getHeight = height ?? 50.h;
    final ButtonStyle getStyle = style ??
        ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).buttonTheme.colorScheme!.primary),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))));
    final TextStyle getTextStyle =
        TextStyle(color: Theme.of(context).textTheme.bodyText1!.color);

    ///
    return Expanded(
      child: Container(
        width: getWidth,
        height: getHeight,
        margin: const EdgeInsets.all(5),
        constraints: BoxConstraints(minWidth: double.infinity, minHeight: 20.h),
        child: TextButton(
            style: getStyle,
            onPressed: onTap,
            child: child ??
                Text(
                  text ?? "",
                  style: getTextStyle,
                )),
      ),
    );
  }
}

class CalculatorOperatorButton extends StatelessWidget {
  const CalculatorOperatorButton({
    Key? key,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.style,
    this.text,
    this.child,
    this.onTap,
  }) : super(key: key);

  /// 语义描述
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final ButtonStyle? style;
  final String? text;
  final Widget? child;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    // 屏幕自适应 设置尺寸（填写设计中设备的屏幕尺寸）如果设计基于360dp * 690dp的屏幕
    ScreenUtil.init(
      context,
      designSize: Size(AppTheme.wdp, AppTheme.hdp),
    );

    final ButtonStyle getStyle = style ??
        ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).buttonTheme.colorScheme!.secondary),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))));

    ///
    return CalculatorButton(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      style: getStyle,
      onTap: onTap,
      text: text,
      child: child,
    );
  }
}
