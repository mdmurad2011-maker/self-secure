class Validators {
  Validators._();

  static bool isRequired(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static bool isValidPin(String? value) {
    if (value == null) return false;
    return RegExp(r'^\d{4,6}$').hasMatch(value);
  }

  static bool isValidEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }

    return RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(value.trim());
  }

  static bool isValidUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }

    final uri = Uri.tryParse(value.trim());

    return uri != null &&
        (uri.scheme == 'http' ||
            uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  static bool isValidHost(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }

    final host = value.trim();

    final ipPattern = RegExp(
      r'^(\d{1,3}\.){3}\d{1,3}$',
    );

    final hostnamePattern = RegExp(
      r'^[a-zA-Z0-9.-]+$',
    );

    return ipPattern.hasMatch(host) ||
        hostnamePattern.hasMatch(host);
  }

  static bool isValidPort(int? port) {
    return port != null &&
        port >= 1 &&
        port <= 65535;
  }
}
