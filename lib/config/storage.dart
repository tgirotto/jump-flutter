import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JumpStorage {
  static final storage = new FlutterSecureStorage();

  Future<void> write(String key, String value) {
    return storage.write(key: key, value: value);
  }

  Future<String?> read(String key, String value) {
    return storage.read(key: key);
  }

  Future<void> deleteAll() {
    return storage.deleteAll();
  }

  Future<void> delete(String key) {
    return storage.delete(key: key);
  }
}
