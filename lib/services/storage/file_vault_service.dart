import 'dart:io';

class FileVaultService {
  Future<bool> fileExists(
    String path,
  ) async {
    return File(path).exists();
  }

  Future<File?> readFile(
    String path,
  ) async {
    final file = File(path);

    if (!await file.exists()) {
      return null;
    }

    return file;
  }

  Future<void> deleteFile(
    String path,
  ) async {
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  }
}
