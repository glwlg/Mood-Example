import 'dart:convert';
import 'package:flutter/material.dart';

///
import 'package:moodexample/db/db.dart';
import 'package:moodexample/models/lifespan/lifespan_model.dart';

///
import 'package:moodexample/models/mood/mood_model.dart';
import 'package:moodexample/models/mood/mood_category_model.dart';
import 'package:moodexample/view_models/lifespan/lifespan_view_model.dart';
import 'package:moodexample/view_models/mood/mood_view_model.dart';

class LifespanService {


  /// 获取数据
  static Future<void> getLifespanData(
      LifespanViewModel lifespanViewModel) async {
    // 查询心情数据
    final lifespanData = await DB.db.selectLifespan();
    Map<String, List> lifespanDataAll = {"data": lifespanData};
    // 转换模型
    LifespanModel lifespanModel = lifespanModelFromJson(json.encode(lifespanDataAll));
    // 更新数据
    lifespanViewModel.setLifespanData(lifespanModel.lifespanData);
  }

  /// 修改数据
  static Future<bool> editLifespan(
      LifespanData lifespanData,
  ) async {
    // 修改数据
    lifespanData.updateTime = DateTime.now();
    bool result = await DB.db.updateLifespan(lifespanData);
    return result;
  }


}
