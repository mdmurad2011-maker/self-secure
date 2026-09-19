import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/private_website.dart';

class PrivateWebsiteStorage {
  static const String _key =
      'self_secure_private_websites';

  Future<List<PrivateWebsite>> getWebsites() async {
    final prefs =
        await SharedPreferences.getInstance();

    final values =
        prefs.getStringList(_key) ?? [];

    final websites = <PrivateWebsite>[];

    for (final value in values) {
      try {
        final decoded = jsonDecode(value);

        if (decoded is Map<String, dynamic>) {
          websites.add(
            PrivateWebsite.fromJson(decoded),
          );
        }
      } catch (_) {
        // Ignore invalid stored entries.
      }
    }

    return websites;
  }

  Future<void> saveWebsite(
    PrivateWebsite website,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final websites = await getWebsites();

    final index = websites.indexWhere(
      (item) => item.id == website.id,
    );

    if (index >= 0) {
      websites[index] = website;
    } else {
      websites.add(website);
    }

    await prefs.setStringList(
      _key,
      websites
          .map(
            (item) => jsonEncode(
              item.toJson(),
            ),
          )
          .toList(),
    );
  }

  Future<void> deleteWebsite(
    String id,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final websites = await getWebsites();

    websites.removeWhere(
      (item) => item.id == id,
    );

    await prefs.setStringList(
      _key,
      websites
          .map(
            (item) => jsonEncode(
              item.toJson(),
            ),
          )
          .toList(),
    );
  }

  Future<void> clearWebsites() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
