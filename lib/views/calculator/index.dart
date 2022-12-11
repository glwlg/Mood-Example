import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moodexample/models/calculator/calculator_model.dart';
import 'package:moodexample/models/lifespan/lifespan_model.dart';
import 'package:moodexample/services/lifespan/lifespan_service.dart';
import 'package:moodexample/view_models/calculator/calculator_view_model.dart';
import 'package:moodexample/view_models/lifespan/lifespan_view_model.dart';
import 'package:provider/provider.dart';

///
import 'package:moodexample/themes/app_theme.dart';
import 'package:moodexample/generated/l10n.dart';
import 'package:moodexample/common/utils.dart';

/// 心情页（记录列表）
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorState();
}

class _CalculatorState extends State<CalculatorPage>
    with AutomaticKeepAliveClientMixin {
  /// AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    init(context);
  }

  @override
  Widget build(BuildContext context) {
    /// AutomaticKeepAliveClientMixin
    super.build(context);
    // 屏幕自适应 设置尺寸（填写设计中设备的屏幕尺寸）如果设计基于360dp * 690dp的屏幕
    ScreenUtil.init(
      context,
      designSize: Size(AppTheme.wdp, AppTheme.hdp),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: const SafeArea(
        child: CalculatorBody(key: Key("widget_calculator_body")),
      ),
    );
  }
}

/// 初始化
init(BuildContext context) {
  CalculatorViewModel calculatorViewModel =
      Provider.of<CalculatorViewModel>(context, listen: false);

  /// 获取数据
  // LifespanService.getLifespanData(calculatorViewModel);
}

/// 主体
class CalculatorBody extends StatefulWidget {
  const CalculatorBody({Key? key}) : super(key: key);

  @override
  State<CalculatorBody> createState() => _CalculatorBodyState();
}

class _CalculatorBodyState extends State<CalculatorBody> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      primary: false,
      shrinkWrap: false,
      slivers: [
        SliverAppBar(
          pinned: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Align(
            child: Container(
              margin: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      S.of(context).calculator_title,
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                          ),
                      semanticsLabel: S
                          .of(context)
                          .app_bottomNavigationBar_title_calculator,
                    ),
                  ),
                  Image.asset(
                    "assets/images/woolly/woolly-heart.png",
                    height: 60.w,
                    excludeFromSemantics: true,
                  ),
                ],
              ),
            ),
          ),
          collapsedHeight: 100.w,
          expandedHeight: 100.w,
        ),

        /// 下拉加载
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            vibrate();
            init(context);
          },
        ),

        /// 数据
        Consumer<CalculatorViewModel>(
          builder: (_, calculatorViewModel, child) {
            /// 加载数据的占位
            // if (calculatorViewModel.calculatorDataLoading) {
            //   return SliverFixedExtentList(
            //     itemExtent: 280.w,
            //     delegate: SliverChildBuilderDelegate(
            //           (builder, index) {
            //         return Align(
            //           child: CupertinoActivityIndicator(radius: 12.sp),
            //         );
            //       },
            //       childCount: 1,
            //     ),
            //   );
            // }

            CalculatorData? calculatorData = calculatorViewModel.calculatorData;

            /// 有内容显示
            return SliverToBoxAdapter(
                child: CalculatorCard(
                    key: Key("widget_calculator_body"),
                    id: calculatorData?.id ?? -1,
                    input: calculatorData?.input ?? '',
                    result: calculatorData?.result ?? ''));
          },
        ),

        /// 占位高度
        SliverToBoxAdapter(child: SizedBox(height: 64.w)),
      ],
    );
  }
}

/// 计算器卡片
class CalculatorCard extends StatefulWidget {
  /// id
  final int id;

  /// 输入
  final String input;

  /// 结果
  final String result;

  const CalculatorCard({
    Key? key,
    required this.id,
    required this.input,
    required this.result,
  }) : super(key: key);

  @override
  State<CalculatorCard> createState() => _CalculatorCardState();
}

class _CalculatorCardState extends State<CalculatorCard> {
  num _x = 0;
  num _y = 0;
  bool _afterOption = false;
  String _input = "";
  String _result = "0";
  String _option = "";

  /// type 1: number  2:option
  void _input_pressed(int type, String value) {
    debugPrint("input $type $value");
    setState(() {
      if (type == 1) {
        if (_afterOption) {
          _x = num.parse(_result);
          _y = num.parse(value);
          _result = value;
          _afterOption = false;
        } else {
          if (_result == '0') {
            _result = value;
            _x = num.parse(value);
          } else {
            _result += value;
            if (_option == "") {
              _x = num.parse(_result);
            } else {
              _y = num.parse(_result);
            }
          }
        }
      } else if (type == 2) {
        switch (value) {
          case 'cal_del':
            if (_result.length == 1) {
              _result = '0';
            } else {
              _result = _result.substring(0, _result.length - 1);
            }
            break;
          case 'cal_ce':
            _result = '0';
            break;
          case 'cal_c':
            _x = 0;
            _y = 0;
            _afterOption = false;
            _input = "";
            _result = "0";
            _option = "";
            break;
          case 'cal_divide':
            _x = num.parse(_result);
            _afterOption = true;
            _option = value;
            _input = '$_result ÷';
            break;
          case 'cal_multiply':
            _x = num.parse(_result);
            _afterOption = true;
            _option = value;
            _input = '$_result x';
            break;
          case 'cal_subtract':
            _x = num.parse(_result);
            _afterOption = true;
            _option = value;
            _input = '$_result -';
            break;
          case 'cal_add':
            _x = num.parse(_result);
            _afterOption = true;
            _option = value;
            _input = '$_result +';
            break;
          case 'cal_equal':
            if (_afterOption) {
              _y = _x;
              _afterOption = false;
            }
            switch (_option) {
              case 'cal_divide':
                _input = '$_x ÷ $_y =';
                _x = _x / _y;
                _result = _x.toString();
                break;
              case 'cal_multiply':
                _input = '$_x x $_y =';
                _x = _x * _y;
                _result = _x.toString();
                break;
              case 'cal_subtract':
                _input = '$_x - $_y =';
                _x = _x - _y;
                _result = _x.toString();
                break;
              case 'cal_add':
                _input = '$_x + $_y =';
                _x = _x + _y;
                _result = _x.toString();
                break;
            }
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.key,
      child: Container(
        margin:
            EdgeInsets.only(left: 24.w, right: 24.w, top: 0.w, bottom: 12.w),
        child: GestureDetector(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 320.w,
            ),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                            bottom: 10.w,
                          ),
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              _input,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          bottom: 15.w,
                        ),
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            _result,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 50.w,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          key: const Key("cal_per"),
                          color: Colors.white,
                          margin: const EdgeInsets.all(5),
                          constraints: BoxConstraints(
                              minWidth: double.infinity, minHeight: 50.h),
                          child: TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)))),
                              onPressed: () => _input_pressed(2, 'cal_per'),
                              child: const Text("%")),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                              minWidth: double.infinity, minHeight: 50.h),
                          key: const Key("cal_ce"),
                          color: Colors.white,
                          margin: const EdgeInsets.all(5),
                          child: TextButton(
                              onPressed: () => _input_pressed(2, 'cal_ce'),
                              child: const Text("CE")),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            key: const Key("cal_c"),
                            color: Colors.white,
                            margin: const EdgeInsets.all(5),
                            constraints: BoxConstraints(
                                minWidth: double.infinity, minHeight: 50.h),
                            child: TextButton(
                                onPressed: () => _input_pressed(2, 'cal_c'),
                                child: const Text("C"))),
                      ),
                      Expanded(
                        child: Container(
                            key: const Key("cal_del"),
                            color: Colors.white,
                            margin: const EdgeInsets.all(5),
                            constraints: BoxConstraints(
                                minWidth: double.infinity, minHeight: 50.h),
                            child: TextButton(
                                onPressed: () => _input_pressed(2, 'cal_del'),
                                child: const Icon(Icons.backspace_outlined))),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                              key: const Key("cal_one_divided"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () =>
                                      _input_pressed(2, 'cal_one_divided'),
                                  child: const Text("⅟X")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_square"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () =>
                                      _input_pressed(2, 'cal_square'),
                                  child: const Text("X²")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_square_root"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () =>
                                      _input_pressed(2, 'cal_square_root'),
                                  child: const Text("√")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_divide"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () =>
                                      _input_pressed(2, 'cal_divide'),
                                  child: const Text("÷"))))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                              key: const Key("cal_seven"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () => _input_pressed(1, '7'),
                                  child: const Text("7")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_eight"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () => _input_pressed(1, '8'),
                                  child: const Text("8")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_nine"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () => _input_pressed(1, '9'),
                                  child: const Text("9")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_multiply"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () =>
                                      _input_pressed(2, 'cal_multiply'),
                                  child: const Text("×"))))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                              key: const Key("cal_four"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () => _input_pressed(1, '4'),
                                  child: const Text("4")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_five"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () => _input_pressed(1, '5'),
                                  child: const Text("5")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_six"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () => _input_pressed(1, '6'),
                                  child: const Text("6")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_subtract"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () =>
                                      _input_pressed(2, 'cal_subtract'),
                                  child: const Text("-"))))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                              key: const Key("cal_one"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () => _input_pressed(1, '1'),
                                  child: const Text("1")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_two"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () => _input_pressed(1, '2'),
                                  child: const Text("2")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_three"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () => _input_pressed(1, '3'),
                                  child: const Text("3")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_add"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () => _input_pressed(2, 'cal_add'),
                                  child: const Text("+"))))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Container(
                              key: const Key("cal_negative"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () =>
                                      _input_pressed(2, 'cal_negative'),
                                  child: const Text("∓")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_zero"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () => _input_pressed(1, '0'),
                                  child: const Text("0")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_point"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () =>
                                      _input_pressed(2, 'cal_point'),
                                  child: const Text(".")))),
                      Expanded(
                          child: Container(
                              key: const Key("cal_equal"),
                              color: Colors.white,
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 50.h),
                              child: TextButton(
                                  onPressed: () =>
                                      _input_pressed(2, 'cal_equal'),
                                  child: const Text("="))))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
