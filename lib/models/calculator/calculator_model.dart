import 'dart:convert';

CalculatorModel calculatorModelFromJson(String str) =>
    CalculatorModel.fromJson(json.decode(str));

String calculatorModelToJson(CalculatorModel data) =>
    json.encode(data.toJson());

/// 心情详细数据
class CalculatorModel {
  CalculatorModel({
    this.calculatorData,
  });

  final List<CalculatorData>? calculatorData;

  factory CalculatorModel.fromJson(Map<String, dynamic> json) =>
      CalculatorModel(
        calculatorData: List<CalculatorData>.from(
          json["data"].map(
            (x) => CalculatorData.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "calculatorData": List<dynamic>.from(
          calculatorData!.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

CalculatorData moodDataFromJson(String str) =>
    CalculatorData.fromJson(json.decode(str));

String moodDataToJson(CalculatorData data) => json.encode(data.toJson());

/// 心情详细数据
class CalculatorData {
  CalculatorData({
    this.id,
    this.input,
    this.result,
    this.createTime,
  });

  // ID
  late int? id;

  // 输入
  late String? input;

  // 结果
  late String? result;

  // 创建日期
  late String? createTime;

  factory CalculatorData.fromJson(Map<String, dynamic> json) => CalculatorData(
        id: json["id"],
        input: json["input"],
        result: json["result"],
        createTime: json["createTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "input": input,
        "result": result,
        "createTime": createTime,
      };
}
