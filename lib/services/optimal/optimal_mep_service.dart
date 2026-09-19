class OptimalMepService {
  String? _baseUrl;

  void configure(String baseUrl) {
    _baseUrl = baseUrl.trim().replaceAll(RegExp(r'/$'), '');
  }

  String? get baseUrl => _baseUrl;

  bool get isConfigured =>
      _baseUrl != null && _baseUrl!.isNotEmpty;

  Uri? buildUri(String path) {
    if (!isConfigured) {
      return null;
    }

    final cleanPath = path.startsWith('/')
        ? path.substring(1)
        : path;

    return Uri.parse('$_baseUrl/$cleanPath');
  }
}
