/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 17/4/26 - 16:34
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BaseSecureStorage {
    // Singleton pattern with Factory constructor
    static final BaseSecureStorage _instance = BaseSecureStorage._internal();
    factory BaseSecureStorage() => _instance;
    BaseSecureStorage._internal();

    // Cấu hình mặc định an toàn nhất
    final _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );

    /// Ghi dữ liệu
    Future<void> write(String key, String value) async {
        await _storage.write(key: key, value: value);
    }

    /// Đọc dữ liệu
    Future<String?> read(String key) async {
        return await _storage.read(key: key);
    }

    /// Xóa một key
    Future<void> delete(String key) async {
        await _storage.delete(key: key);
    }

    /// Xóa sạch mọi thứ
    Future<void> deleteAll() async {
        await _storage.deleteAll();
    }
}