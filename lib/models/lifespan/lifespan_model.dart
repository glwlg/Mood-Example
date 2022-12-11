import 'dart:convert';

LifespanModel lifespanModelFromJson(String str) =>
    LifespanModel.fromJson(json.decode(str));

String lifespanModelToJson(LifespanModel data) => json.encode(data.toJson());

/// 心情详细数据
class LifespanModel {
  LifespanModel({
    required this.lifespanData,
  });

  final LifespanData lifespanData;

  factory LifespanModel.fromJson(Map<String, dynamic> json) => LifespanModel(
        lifespanData: LifespanData.fromJson(json["data"][0]),
      );

  Map<String, dynamic> toJson() => {"lifespanData": lifespanData.toJson()};
}

LifespanData lifespanDataFromJson(String str) =>
    LifespanData.fromJson(json.decode(str));

String lifespanDataToJson(LifespanData data) => json.encode(data.toJson());

/// 人生详细数据
class LifespanData {
  LifespanData({
    required this.id,
    required this.birthDay,
    required this.life,
    required this.createTime,
    this.updateTime,
  });

  // id
  late int id;

  // 生日
  late String birthDay;

  // 寿命
  late int life;

  // 创建日期
  late String createTime;

  // 修改日期
  late DateTime? updateTime;

  factory LifespanData.fromJson(Map<String, dynamic> json) => LifespanData(
        id: json["id"],
        birthDay: json["birthDay"],
        life: json["life"],
        createTime: json["createTime"],
        updateTime: DateTime.parse(json["updateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "birthDay": birthDay,
        "life": life,
        "createTime": createTime,
        "updateTime": updateTime.toString().substring(0, 10),
      };
}
