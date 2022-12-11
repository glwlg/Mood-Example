import 'package:flutter/material.dart';

///
import 'package:flutter_screenutil/flutter_screenutil.dart';

///
import 'package:moodexample/themes/app_theme.dart';

/// 操作按钮
class CalculatorResult extends StatelessWidget {
  const CalculatorResult(
    this.data, {
    Key? key,
    this.width,
    this.height,
    this.padding,
  }) : super(key: key);

  /// 语义描述
  final String data;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    // 屏幕自适应 设置尺寸（填写设计中设备的屏幕尺寸）如果设计基于360dp * 690dp的屏幕
    ScreenUtil.init(
      context,
      designSize: Size(AppTheme.wdp, AppTheme.hdp),
    );

    ///
    final double getWidth = width ?? 48.w;
    final double getHeight = height ?? 60.h;
    final double getFontSize = width ?? 50.w;
    final EdgeInsetsGeometry getPadding = padding ??
        EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: 15.w,
        );

    ///
    return Expanded(
        child: Padding(
      padding: getPadding,
      child: Container(
        width: getWidth,
        height: getHeight,
        alignment: Alignment.bottomRight,
        child: Text(
          data,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1!.color,
              fontSize: getFontSize,
              fontWeight: FontWeight.w700),
        ),
      ),
    ));
  }
}
