import 'dart:io';

class CctvSnapshotService {
  Future<bool> saveSnapshot({
    required String sourcePath,
    required String destinationPath,
  }) async {
    final source = File(sourcePath);

    if (!await source.exists()) {
      return false;
    }

    try {
      final destination =
          File(destinationPath);

      await destination.parent.create(
        recursive: true,
      );

      await source.copy(
        destination.path,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> snapshotExists(
    String path,
  ) async {
    return File(path).exists();
  }

  Future<bool> deleteSnapshot(
    String path,
  ) async {
    final file = File(path);

    if (!await file.exists()) {
      return false;
    }

    try {
      await file.delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}
