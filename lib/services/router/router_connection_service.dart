import 'dart:io';

class RouterConnectionService {
  Future<bool> isReachable({
    required String host,
    required int port,
    Duration timeout =
        const Duration(seconds: 3),
  }) async {
    try {
      final socket =
          await Socket.connect(
        host,
        port,
        timeout: timeout,
      );

      await socket.close();
      return true;
    } catch (_) {
      return false;
    }
  }
}
