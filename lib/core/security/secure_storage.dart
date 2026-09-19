import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();

  static final SecureStorage instance =
      SecureStorage._();

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  Future<void> write(
    String key,
    String value,
  ) async {
    await _storage.write(
      key: key,
      value: value,
    );
  }

  Future<String?> read(
    String key,
  ) async {
    return _storage.read(key: key);
  }

  Future<void> delete(
    String key,
  ) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<bool> containsKey(
    String key,
  ) async {
    return _storage.containsKey(key: key);
  }
}
