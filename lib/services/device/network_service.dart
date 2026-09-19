import 'dart:io';

class NetworkService {
  NetworkService._();

  static final NetworkService instance =
      NetworkService._();

  Future<bool> isConnected() async {
    try {
      final result =
          await InternetAddress.lookup(
        'example.com',
      );

      return result.isNotEmpty &&
          result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<String> connectionStatus() async {
    final connected =
        await isConnected();

    return connected
        ? 'online'
        : 'offline';
  }
}
