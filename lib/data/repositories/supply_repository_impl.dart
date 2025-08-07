import 'package:supervisor/data/datasources/local_storage.dart';
import 'package:supervisor/data/models/evidence.dart';
import 'package:supervisor/data/models/supply.dart';
import 'package:supervisor/domain/entities/evidence_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:supervisor/domain/repositories/supply_repository.dart';

/// Implementation of the SupplyRepository interface
class SupplyRepositoryImpl implements SupplyRepository {
  final LocalStorage _localStorage;

  SupplyRepositoryImpl({required LocalStorage localStorage})
      : _localStorage = localStorage;

  @override
  Future<List<SupplyEntity>> getAllSupplies() async {
    final supplies = await _localStorage.getAllSupplies();
    return supplies.map(_mapSupplyToEntity).toList();
  }

  @override
  Future<SupplyEntity?> getSupplyById(String id) async {
    final supply = await _localStorage.getSupplyById(id);
    return supply != null ? _mapSupplyToEntity(supply) : null;
  }

  @override
  Future<List<SupplyEntity>> getSuppliesByReportId(String reportId) async {
    final supplies = await _localStorage.getSuppliesByReportId(reportId);
    return supplies.map(_mapSupplyToEntity).toList();
  }

  @override
  Future<void> saveSupply(SupplyEntity supply) async {
    await _localStorage.saveSupply(_mapEntityToSupply(supply));
  }

  @override
  Future<void> deleteSupply(String id) async {
    await _localStorage.deleteSupply(id);
  }

  @override
  Future<void> addEvidenceToSupply(String supplyId, EvidenceEntity evidence) async {
    final supply = await _localStorage.getSupplyById(supplyId);
    if (supply == null) {
      throw Exception('Supply not found');
    }

    final updatedEvidences = [...supply.evidences, _mapEntityToEvidence(evidence)];
    final updatedSupply = supply.copyWith(evidences: updatedEvidences);
    await _localStorage.saveSupply(updatedSupply);
  }

  @override
  Future<void> removeEvidenceFromSupply(String supplyId, String evidenceId) async {
    final supply = await _localStorage.getSupplyById(supplyId);
    if (supply == null) {
      throw Exception('Supply not found');
    }

    final updatedEvidences = supply.evidences.where((e) => e.id != evidenceId).toList();
    final updatedSupply = supply.copyWith(evidences: updatedEvidences);
    await _localStorage.saveSupply(updatedSupply);
  }

  @override
  Future<void> updateEvidenceInSupply(String supplyId, EvidenceEntity evidence) async {
    final supply = await _localStorage.getSupplyById(supplyId);
    if (supply == null) {
      throw Exception('Supply not found');
    }

    final updatedEvidences = supply.evidences.map((e) {
      return e.id == evidence.id ? _mapEntityToEvidence(evidence) : e;
    }).toList();
    
    final updatedSupply = supply.copyWith(evidences: updatedEvidences);
    await _localStorage.saveSupply(updatedSupply);
  }

  // Helper methods to map between domain entities and data models
  SupplyEntity _mapSupplyToEntity(Supply supply) {
    return SupplyEntity(
      id: supply.id,
      code: supply.code,
      evidences: supply.evidences.map(_mapEvidenceToEntity).toList(),
      createdAt: supply.createdAt,
    );
  }

  Supply _mapEntityToSupply(SupplyEntity entity) {
    return Supply(
      id: entity.id,
      code: entity.code,
      evidences: entity.evidences.map(_mapEntityToEvidence).toList(),
      createdAt: entity.createdAt,
    );
  }

  EvidenceEntity _mapEvidenceToEntity(Evidence evidence) {
    return EvidenceEntity(
      id: evidence.id,
      imagePath: evidence.imagePath,
      voiceRecordingPath: evidence.voiceRecordingPath,
      observation: evidence.observation,
      createdAt: evidence.createdAt,
      location: evidence.location,
      locationMapPath: evidence.locationMapPath,
    );
  }

  Evidence _mapEntityToEvidence(EvidenceEntity entity) {
    return Evidence(
      id: entity.id,
      imagePath: entity.imagePath,
      voiceRecordingPath: entity.voiceRecordingPath,
      observation: entity.observation,
      createdAt: entity.createdAt,
      location: entity.location,
      locationMapPath: entity.locationMapPath,
    );
  }
}