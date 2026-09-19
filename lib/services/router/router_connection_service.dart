import 'dart:io';

class RouterConnectionService {
  Future<bool> isReachable({
    required String host,
    int port = 80,
    Duration timeout =
        const Duration(seconds: 3),
  }) async {
    final address = host.trim();

    if (address.isEmpty) {
      return false;
    }

    try {
      final socket =
          await Socket.connect(
        address,
        port,
        timeout: timeout,
      );

      await socket.close();

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> ping({
    required String host,
  }) async {
    final address = host.trim();

    if (address.isEmpty) {
      return false;
    }

    try {
      final result =
          await InternetAddress.lookup(address);

      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
