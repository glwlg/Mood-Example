import 'package:flutter/material.dart';

import 'package:moodexample/models/lifespan/lifespan_model.dart';

// 心情页相关
class LifespanViewModel extends ChangeNotifier {
  /// 数据
  late LifespanData _lifespanData;

  /// 数据加载
  bool _lifespanDataLoading = true;

  /// 赋值数据加载
  setLifespanDataLoading(bool lifespanDataLoading) {
    _lifespanDataLoading = lifespanDataLoading;
    notifyListeners();
  }

  /// 设置数据
  setLifespanData(LifespanData lifespanData) {
    _lifespanData = lifespanData;
    _lifespanDataLoading = false;
    notifyListeners();
  }

  /// 赋值当前选择的日期
  setBirthday(DateTime dateTime) {
    _lifespanData.birthDay = dateTime.toString().substring(0, 10);
  }


  /// 赋值当前选择的日期
  setLife(int life) {
    _lifespanData.life = life;
  }

  /// 数据
  LifespanData? get lifespanData => _lifespanData;

  bool get lifespanDataLoading => _lifespanDataLoading;
}
