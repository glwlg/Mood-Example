import 'package:flutter/material.dart';

///
import 'package:moodexample/db/preferences_db.dart';
import 'package:moodexample/models/calculator/calculator_model.dart';

///
import 'package:moodexample/models/mood/mood_model.dart';
import 'package:moodexample/models/mood/mood_category_model.dart';
import 'package:moodexample/services/mood/mood_service.dart';

// 心情页相关
class CalculatorViewModel extends ChangeNotifier {
  /// 心情数据List
  List<CalculatorData>? _calculatorDataList = [];

  /// 心情数据
  late CalculatorData _calculatorData = CalculatorData(id:1,input: '',result: '0',createTime: '');

  /// 当前选择的日期
  DateTime _nowDateTime = DateTime.now();

  /// 心情数据加载
  bool _calculatorDataLoading = true;

  /// 所有已记录心情的日期
  List _calculatorRecordedDate = [];

  /// 所有心情数据List
  List<CalculatorData>? _calculatorAllDataList = [];

  /// 赋值心情数据
  void setMoodDataList(CalculatorModel calculatorModel) {
    _calculatorDataList = [];
    _calculatorDataList = calculatorModel.calculatorData;
    _calculatorDataLoading = false;
    notifyListeners();
  }

  /// 赋值心情数据加载
  setMoodDataLoading(bool moodDataLoading) {
    _calculatorDataLoading = moodDataLoading;
    notifyListeners();
  }

  /// 心情单个数据
  setMoodData(CalculatorData calculatorData) {
    _calculatorData = calculatorData;
  }

  /// 赋值当前选择的日期
  setNowDateTime(DateTime dateTime) {
    _nowDateTime = dateTime;
  }

  /// 赋值所有已记录心情的日期
  setMoodRecordedDate(List moodRecordedDate) {
    _calculatorRecordedDate = [];
    _calculatorRecordedDate = moodRecordedDate;
    notifyListeners();
  }


  /// 赋值所有心情数据
  void setMoodAllDataList(CalculatorModel calculatorModel) {
    _calculatorAllDataList = [];
    _calculatorAllDataList = calculatorModel.calculatorData;
    notifyListeners();
  }

  /// 心情数据
  List<CalculatorData>? get calculatorDataList => _calculatorDataList;
  CalculatorData? get calculatorData => _calculatorData;
  DateTime get nowDateTime => _nowDateTime;
  bool get calculatorDataLoading => _calculatorDataLoading;
  List get calculatorRecordedDate => _calculatorRecordedDate;
  List<CalculatorData>? get calculatorAllDataList => _calculatorAllDataList;
}
