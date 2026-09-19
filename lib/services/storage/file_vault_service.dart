import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FileVaultService {
  static const String _key =
      'self_secure_file_vault';

  Future<List<Map<String, dynamic>>> getFiles() async {
    final prefs =
        await SharedPreferences.getInstance();

    final values =
        prefs.getStringList(_key) ?? [];

    final files = <Map<String, dynamic>>[];

    for (final value in values) {
      try {
        final decoded = jsonDecode(value);

        if (decoded is Map<String, dynamic>) {
          files.add(decoded);
        }
      } catch (_) {
        // Ignore invalid stored entries.
      }
    }

    return files;
  }

  Future<void> saveFile({
    required String id,
    required String name,
    required String path,
    int size = 0,
  }) async {
    final prefs =
        await SharedPreferences.getInstance();

    final files = await getFiles();

    final file = <String, dynamic>{
      'id': id,
      'name': name,
      'path': path,
      'size': size,
      'createdAt':
          DateTime.now().toIso8601String(),
    };

    final index = files.indexWhere(
      (item) => item['id']?.toString() == id,
    );

    if (index >= 0) {
      files[index] = file;
    } else {
      files.insert(0, file);
    }

    await prefs.setStringList(
      _key,
      files.map(jsonEncode).toList(),
    );
  }

  Future<void> deleteFile(
    String id,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final files = await getFiles();

    files.removeWhere(
      (item) => item['id']?.toString() == id,
    );

    await prefs.setStringList(
      _key,
      files.map(jsonEncode).toList(),
    );
  }

  Future<void> clearVault() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
