import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/diary_entry.dart';

class DiaryStorageService {
  static const String _key =
      'self_secure_diary_entries';

  Future<List<DiaryEntry>> getEntries() async {
    final prefs =
        await SharedPreferences.getInstance();

    final values =
        prefs.getStringList(_key) ?? [];

    final entries = <DiaryEntry>[];

    for (final value in values) {
      try {
        final decoded = jsonDecode(value);

        if (decoded is Map<String, dynamic>) {
          entries.add(
            DiaryEntry.fromJson(decoded),
          );
        }
      } catch (_) {
        // Ignore invalid stored entries.
      }
    }

    entries.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    return entries;
  }

  Future<void> saveEntry(
    DiaryEntry entry,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final entries = await getEntries();

    final index = entries.indexWhere(
      (item) => item.id == entry.id,
    );

    if (index >= 0) {
      entries[index] = entry;
    } else {
      entries.insert(0, entry);
    }

    await prefs.setStringList(
      _key,
      entries
          .map(
            (item) => jsonEncode(
              item.toJson(),
            ),
          )
          .toList(),
    );
  }

  Future<void> deleteEntry(
    String id,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final entries = await getEntries();

    entries.removeWhere(
      (item) => item.id == id,
    );

    await prefs.setStringList(
      _key,
      entries
          .map(
            (item) => jsonEncode(
              item.toJson(),
            ),
          )
          .toList(),
    );
  }

  Future<void> clearEntries() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}
