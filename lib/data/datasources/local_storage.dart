import 'package:hive/hive.dart';
import 'package:supervisor/data/models/evidence.dart';
import 'package:supervisor/data/models/report.dart';
import 'package:supervisor/data/models/supply.dart';

/// Local storage implementation using Hive
class LocalStorage {
  // Box names
  static const String reportsBoxName = 'reports_box';
  static const String suppliesBoxName = 'supplies_box';
  static const String evidencesBoxName = 'evidences_box';
  static const String settingsBoxName = 'settings_box';

  // Boxes
  final Box _reportsBox;
  final Box _suppliesBox;
  final Box _evidencesBox;
  final Box _settingsBox;

  LocalStorage({
    required Box reportsBox,
    required Box suppliesBox,
    required Box evidencesBox,
    required Box settingsBox,
  })  : _reportsBox = reportsBox,
        _suppliesBox = suppliesBox,
        _evidencesBox = evidencesBox,
        _settingsBox = settingsBox;

  // Factory constructor to get instance with default boxes
  factory LocalStorage.fromDefaultBoxes() {
    return LocalStorage(
      reportsBox: Hive.box(reportsBoxName),
      suppliesBox: Hive.box(suppliesBoxName),
      evidencesBox: Hive.box(evidencesBoxName),
      settingsBox: Hive.box(settingsBoxName),
    );
  }

  // Reports methods
  Future<List<Report>> getAllReports() async {
    return _reportsBox.values.cast<Report>().toList();
  }

  Future<Report?> getReportById(String id) async {
    return _reportsBox.get(id) as Report?;
  }

  Future<void> saveReport(Report report) async {
    await _reportsBox.put(report.id, report);
  }

  Future<void> deleteReport(String id) async {
    await _reportsBox.delete(id);
  }

  // Supplies methods
  Future<List<Supply>> getAllSupplies() async {
    return _suppliesBox.values.cast<Supply>().toList();
  }

  Future<Supply?> getSupplyById(String id) async {
    return _suppliesBox.get(id) as Supply?;
  }

  Future<List<Supply>> getSuppliesByReportId(String reportId) async {
    final report = await getReportById(reportId);
    if (report == null) {
      return [];
    }
    return report.supplies;
  }

  Future<void> saveSupply(Supply supply) async {
    await _suppliesBox.put(supply.id, supply);
  }

  Future<void> deleteSupply(String id) async {
    await _suppliesBox.delete(id);
  }

  // Evidences methods
  Future<List<Evidence>> getAllEvidences() async {
    return _evidencesBox.values.cast<Evidence>().toList();
  }

  Future<Evidence?> getEvidenceById(String id) async {
    return _evidencesBox.get(id) as Evidence?;
  }

  Future<void> saveEvidence(Evidence evidence) async {
    await _evidencesBox.put(evidence.id, evidence);
  }

  Future<void> deleteEvidence(String id) async {
    await _evidencesBox.delete(id);
  }

  // Settings methods
  Future<dynamic> getSetting(String key) async {
    return _settingsBox.get(key);
  }

  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  Future<void> deleteSetting(String key) async {
    await _settingsBox.delete(key);
  }
}