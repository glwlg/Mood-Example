/// 寿命表
class TableLifespanInfo {
  /// 表名称
  static const String tableName = 'lifespan_info';

  /// id
  static const String fieldId = 'id';

  /// 生日
  static const String fieldBirthDay = 'birthDay';

  /// 寿命
  static const String fieldLife = 'life';

  /// 创建时间
  static const String fieldCreateTime = 'createTime';

  /// 修改时间
  static const String fieldUpdateTime = 'updateTime';

  /// 删除数据库
  final String dropTable = "DROP TABLE IF EXISTS $tableName";

  /// 创建数据库
  final String createTable = '''
      CREATE TABLE IF NOT EXISTS $tableName (
        $fieldId INTEGER PRIMARY KEY,
        $fieldBirthDay TEXT,
        $fieldLife INT,
        $fieldCreateTime VARCHAR(40),
        $fieldUpdateTime VARCHAR(40)
      );
    ''';
}
