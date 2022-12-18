import 'package:flutter/material.dart';

///
import 'package:flutter_screenutil/flutter_screenutil.dart';

///
import 'package:moodexample/themes/app_theme.dart';

/// 执行器
class Execute extends StatefulWidget {
  const Execute({
    Key? key,
    required this.execute,
  }) : super(key: key);

  final Function()? execute;

  @override
  Widget build(BuildContext context) {
    ///
    return Row(
    );
  }

  @override
  State<StatefulWidget> createState() => _ExecuteState();
}

class _ExecuteState extends State<Execute>{


  @override
  Widget build(BuildContext context) {
    return Row();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.execute!.call();
    });
  }

}

