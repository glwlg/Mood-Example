import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Packages
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodexample/view_models/calculator/calculator_view_model.dart';
import 'package:moodexample/widgets/calculator_button/calculator_button.dart';
import 'package:moodexample/widgets/calculator_input/calculator_input.dart';
import 'package:moodexample/widgets/calculator_result/calculator_result.dart';
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
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: 20.w,
          left: 24.w,
          right: 24.w,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    S.of(context).calculator_title,
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                        ),
                    semanticsLabel:
                        S.of(context).app_bottomNavigationBar_title_calculator,
                  ),
                ),
                Image.asset(
                  "assets/images/woolly/woolly-heart.png",
                  height: 60.w,
                  excludeFromSemantics: true,
                ),
              ],
            ),
            Row(
              children: const [
                Expanded(
                  child: CalculatorCard(key: Key("widget_calculator_body")),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// 计算器卡片
class CalculatorCard extends StatefulWidget {
  /// id
  final int? id;

  /// 输入
  final String? input;

  /// 结果
  final String? result;

  const CalculatorCard({
    Key? key,
    this.id,
    this.input,
    this.result,
  }) : super(key: key);

  @override
  State<CalculatorCard> createState() => _CalculatorCardState();
}

class _CalculatorCardState extends State<CalculatorCard> {
  Decimal _x = Decimal.zero;
  Decimal _y = Decimal.zero;
  bool _afterOption = false;
  String _input = "";
  String _result = "0";
  String _option = "";

  void _optionPressed(String value) {
    debugPrint("input $value");
    setState(() {
      switch (value) {
        case 'cal_per':
          if (!_afterOption && _y == Decimal.zero) {
            clean();
          } else {
            switch (_option) {
              case 'cal_divide':
              case 'cal_multiply':
                _y = Decimal.parse((_y.toDouble() / 100).toString());
                pressEqual();
                break;
              case 'cal_subtract':
              case 'cal_add':
                break;
            }
          }
          break;
        case 'cal_ce':
          _result = '0';
          break;
        case 'cal_c':
          clean();
          break;
        case 'cal_del':
          if (_result.length == 1) {
            _result = '0';
          } else {
            _result = _result.substring(0, _result.length - 1);
          }
          break;
        case 'cal_divide':
          _x = Decimal.parse(_result);
          _afterOption = true;
          _option = value;
          _input = '$_result ÷';
          break;
        case 'cal_multiply':
          _x = Decimal.parse(_result);
          _afterOption = true;
          _option = value;
          _input = '$_result x';
          break;
        case 'cal_subtract':
          _x = Decimal.parse(_result);
          _afterOption = true;
          _option = value;
          _input = '$_result -';
          break;
        case 'cal_add':
          _x = Decimal.parse(_result);
          _afterOption = true;
          _option = value;
          _input = '$_result +';
          break;
        case 'cal_equal':
          pressEqual();
          break;
        case 'cal_one_divided':
          if (_y != Decimal.zero) {
            _x = _y;
            _y = Decimal.zero;
            _input = _x.toString();
          }
          if (_afterOption) {
            _option = '';
            _input = _x.toString();
            _afterOption = false;
          }
          if (_input == '') {
            _input = _x.toString();
          }
          _input = '1/($_input)';
          _x = Decimal.parse((1 / _x.toDouble()).toString());
          _result = _x.toString();
          break;
        case 'cal_square':
          if (_y != Decimal.zero) {
            _x = _y;
            _y = Decimal.zero;
            _input = _x.toString();
          }
          if (_afterOption) {
            _option = '';
            _input = _x.toString();
            _afterOption = false;
          }
          if (_input == '') {
            _input = _x.toString();
          }
          _input = 'sqr($_input)';
          _x = _x * _x;
          _result = _x.toString();
          break;
        case 'cal_square_root':
          if (_y != Decimal.zero) {
            _x = _y;
            _y = Decimal.zero;
            _input = _x.toString();
          }
          if (_afterOption) {
            _option = '';
            _input = _x.toString();
            _afterOption = false;
          }
          if (_input == '') {
            _input = _x.toString();
          }
          _input = '√($_input)';
          _x = Decimal.parse(sqrt(_x.toDouble()).toString());
          _result = _x.toString();
          break;
      }
    });
  }

  void _numberPressed(String value) {
    debugPrint("input $value");
    setState(() {
      if (_afterOption) {
        _x = Decimal.parse(_result);
        _y = Decimal.parse(value);
        _result = value;
        _afterOption = false;
      } else {
        if (_result == '0') {
          _result = value;
          _x = Decimal.parse(value);
        } else {
          _result += value;
          if (_option == "") {
            _x = Decimal.parse(_result);
          } else {
            _y = Decimal.parse(_result);
          }
        }
      }
    });
  }

  void clean() {
    _x = Decimal.zero;
    _y = Decimal.zero;
    _afterOption = false;
    _input = "";
    _result = "0";
    _option = "";
  }

  void pressEqual() {
    if (_afterOption) {
      _y = _x;
      _afterOption = false;
    }
    switch (_option) {
      case 'cal_divide':
        _input = '$_x ÷ $_y =';
        _x = Decimal.parse((_x.toDouble() / _y.toDouble()).toString());
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 0.w, bottom: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalculatorInput(_input),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalculatorResult(_result),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalculatorOperatorButton(
                  key: const Key("cal_per"),
                  onTap: () => _optionPressed('cal_per'),
                  text: "%"),
              CalculatorOperatorButton(
                  key: const Key("cal_ce"),
                  onTap: () => _optionPressed('cal_ce'),
                  text: "CE"),
              CalculatorOperatorButton(
                  key: const Key("cal_c"),
                  onTap: () => _optionPressed('cal_c'),
                  text: "C"),
              CalculatorOperatorButton(
                  key: const Key("cal_del"),
                  onTap: () => _optionPressed('cal_del'),
                  child: Icon(
                    Icons.backspace_outlined,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  )),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalculatorOperatorButton(
                  key: const Key("cal_one_divided"),
                  onTap: () => _optionPressed('cal_one_divided'),
                  text: "⅟X"),
              CalculatorOperatorButton(
                  key: const Key("cal_square"),
                  onTap: () => _optionPressed('cal_square'),
                  text: "X²"),
              CalculatorOperatorButton(
                  key: const Key("cal_square_root"),
                  onTap: () => _optionPressed('cal_square_root'),
                  text: "√"),
              CalculatorOperatorButton(
                  key: const Key("cal_divide"),
                  onTap: () => _optionPressed('cal_divide'),
                  text: "÷")
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalculatorButton(
                  key: const Key("cal_seven"),
                  onTap: () => _numberPressed('7'),
                  text: "7"),
              CalculatorButton(
                  key: const Key("cal_eight"),
                  onTap: () => _numberPressed('8'),
                  text: "8"),
              CalculatorButton(
                  key: const Key("cal_nine"),
                  onTap: () => _numberPressed('9'),
                  text: "9"),
              CalculatorOperatorButton(
                  key: const Key("cal_multiply"),
                  onTap: () => _optionPressed('cal_multiply'),
                  text: "×")
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalculatorButton(
                  key: const Key("cal_four"),
                  onTap: () => _numberPressed('4'),
                  text: "4"),
              CalculatorButton(
                  key: const Key("cal_five"),
                  onTap: () => _numberPressed('5'),
                  text: "5"),
              CalculatorButton(
                  key: const Key("cal_six"),
                  onTap: () => _numberPressed('6'),
                  text: "6"),
              CalculatorOperatorButton(
                  key: const Key("cal_subtract"),
                  onTap: () => _optionPressed('cal_subtract'),
                  text: "-")
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalculatorButton(
                  key: const Key("cal_one"),
                  onTap: () => _numberPressed('1'),
                  text: "1"),
              CalculatorButton(
                  key: const Key("cal_two"),
                  onTap: () => _numberPressed('2'),
                  text: "2"),
              CalculatorButton(
                  key: const Key("cal_three"),
                  onTap: () => _numberPressed('3'),
                  text: "3"),
              CalculatorOperatorButton(
                  key: const Key("cal_add"),
                  onTap: () => _optionPressed('cal_add'),
                  text: "+")
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalculatorButton(
                  key: const Key("cal_negative"),
                  onTap: () => _optionPressed('cal_negative'),
                  text: "∓"),
              CalculatorButton(
                  key: const Key("cal_zero"),
                  onTap: () => _numberPressed('0'),
                  text: "0"),
              CalculatorButton(
                  key: const Key("cal_point"),
                  onTap: () => _optionPressed('cal_point'),
                  text: "."),
              CalculatorOperatorButton(
                key: const Key("cal_equal"),
                onTap: () => _optionPressed('cal_equal'),
                child: Text("=",
                    style: TextStyle(
                        color: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .primary)),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).buttonTheme.colorScheme!.onSecondary),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
              )
            ],
          ),
        ],
      ),
    );
  }
}
