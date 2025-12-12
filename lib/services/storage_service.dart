import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储服务
/// 直接存的
class StorageService {
  static const String _keyPassword = 'password';
  static const String _keyNotebookPath = 'notebook_path';
  static const String _keyFirstLaunch = 'first_launch';

  static SharedPreferences? _prefs;

  /// 初始化存储服务
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// 检查是否首次启动
  Future<bool> isFirstLaunch() async {
    await init();
    return _prefs!.getBool(_keyFirstLaunch) ?? true;
  }

  /// 设置首次启动标记
  Future<void> setFirstLaunchComplete() async {
    await init();
    await _prefs!.setBool(_keyFirstLaunch, false);
  }

  /// 设置密码（明文存储）
  Future<void> setPassword(String password) async {
    await init();
    if (password.isEmpty) {
      await _prefs!.remove(_keyPassword);
      return;
    }
    await _prefs!.setString(_keyPassword, password);
  }

  /// 验证密码
  Future<bool> verifyPassword(String password) async {
    await init();
    final storedPassword = _prefs!.getString(_keyPassword);
    if (storedPassword == null) {
      return true; // 没有设置密码，验证通过
    }
    return password == storedPassword;
  }

  /// 检查是否设置了密码
  Future<bool> hasPassword() async {
    await init();
    return _prefs!.containsKey(_keyPassword);
  }

  /// 设置笔记本目录路径
  Future<void> setNotebookPath(String path) async {
    await init();
    await _prefs!.setString(_keyNotebookPath, path);
  }

  /// 获取笔记本目录路径
  Future<String?> getNotebookPath() async {
    await init();
    return _prefs!.getString(_keyNotebookPath);
  }

  /// 清空所有数据
  Future<void> clearAllData() async {
    await init();
    await _prefs!.clear();
  }
}
