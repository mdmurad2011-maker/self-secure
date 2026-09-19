import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/private_app.dart';
import '../../models/private_website.dart';

class PrivateStorageService {
  static const String _appsKey =
      'self_secure_private_apps';

  static const String _websitesKey =
      'self_secure_private_websites';

  Future<List<PrivateApp>> getApps() async {
    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getStringList(_appsKey) ?? <String>[];

    return data
        .map(
          (value) => PrivateApp.fromJson(
            Map<String, dynamic>.from(
              jsonDecode(value) as Map,
            ),
          ),
        )
        .toList();
  }

  Future<void> saveApps(
    List<PrivateApp> apps,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setStringList(
      _appsKey,
      apps
          .map(
            (app) => jsonEncode(app.toJson()),
          )
          .toList(),
    );
  }

  Future<List<PrivateWebsite>>
      getWebsites() async {
    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getStringList(_websitesKey) ??
            <String>[];

    return data
        .map(
          (value) => PrivateWebsite.fromJson(
            Map<String, dynamic>.from(
              jsonDecode(value) as Map,
            ),
          ),
        )
        .toList();
  }

  Future<void> saveWebsites(
    List<PrivateWebsite> websites,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setStringList(
      _websitesKey,
      websites
          .map(
            (website) =>
                jsonEncode(
                  website.toJson(),
                ),
          )
          .toList(),
    );
  }

  Future<void> clearPrivateData() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_appsKey);
    await prefs.remove(_websitesKey);
  }
}
