import '../../models/location_model.dart';
import 'location_storage_service.dart';

class LocationHistoryService {
  LocationHistoryService();

  static final LocationHistoryService instance =
      LocationHistoryService();

  final LocationStorageService _storage =
      LocationStorageService();

  Future<List<LocationModel>> getHistory() async {
    final values = await _storage.read();

    return values
        .map(
          (item) => LocationModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<List<LocationModel>> getAll() {
    return getHistory();
  }

  Future<void> add(LocationModel location) async {
    await _storage.write(location.toJson());
  }

  Future<void> saveLocation(LocationModel location) async {
    await add(location);
  }

  Future<List<LocationModel>> getBetween({
    required DateTime from,
    required DateTime to,
  }) async {
    final values = await getHistory();

    return values.where((location) {
      return !location.timestamp.isBefore(from) &&
          !location.timestamp.isAfter(to);
    }).toList();
  }

  Future<LocationModel?> latest() async {
    final values = await getHistory();

    if (values.isEmpty) {
      return null;
    }

    values.sort(
      (a, b) => b.timestamp.compareTo(a.timestamp),
    );

    return values.first;
  }

  Future<void> clear() {
    return _storage.clear();
  }

  Future<void> clearHistory() {
    return clear();
  }

  Future<void> deleteLocation(String id) async {
    final values = await getHistory();

    values.removeWhere(
      (location) => location.id == id,
    );

    await _storage.replace(
      values.map((location) => location.toJson()).toList(),
    );
  }
}