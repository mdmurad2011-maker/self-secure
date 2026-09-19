import 'dart:io';

class StorageService {
  StorageService._();

  static final StorageService instance =
      StorageService._();

  Future<int?> fileSize(String path) async {
    try {
      final file = File(path);

      if (!await file.exists()) {
        return null;
      }

      return (await file.stat()).size;
    } catch (_) {
      return null;
    }
  }

  Future<bool> exists(String path) async {
    try {
      return await File(path).exists();
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);

      if (!await file.exists()) {
        return false;
      }

      await file.delete();

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<String>> listFiles(
    String directoryPath,
  ) async {
    try {
      final directory =
          Directory(directoryPath);

      if (!await directory.exists()) {
        return [];
      }

      final files = <String>[];

      await for (final entity
          in directory.list()) {
        if (entity is File) {
          files.add(entity.path);
        }
      }

      return files;
    } catch (_) {
      return [];
    }
  }
}
