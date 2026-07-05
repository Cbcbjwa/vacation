import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const storage = FlutterSecureStorage();

  Future<void> saveAccessToken(String token) async {
    await storage.write(key: "accessToken", value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await storage.write(key: "refreshToken", value: token);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: "accessToken");
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: "refreshToken");
  }

  Future<void> clear() async {
    await storage.deleteAll();
  }

  Future<void> deleteAccessToken() async {
    await storage.delete(key: "accessToken");
  }

Future<void> deleteRefreshToken() async {
    await storage.delete(key: "refreshToken");
  }
}