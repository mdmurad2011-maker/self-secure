import 'dart:io';

class RouterDiscoveryService {
  Future<List<String>> discover({
    String subnet = '192.168.1',
    int start = 1,
    int end = 254,
    int port = 80,
    Duration timeout = const Duration(milliseconds: 300),
  }) async {
    final found = <String>[];

    for (var i = start; i <= end; i++) {
      final host = '$subnet.$i';

      try {
        final socket = await Socket.connect(
          host,
          port,
          timeout: timeout,
        );

        found.add(host);

        await socket.close();
      } catch (_) {
        // Host is not reachable on the selected port.
      }
    }

    return found;
  }

  Future<bool> isReachable({
    required String host,
    int port = 80,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    try {
      final socket = await Socket.connect(
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
