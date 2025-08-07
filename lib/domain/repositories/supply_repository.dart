import 'package:supervisor/domain/entities/evidence_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';

/// Repository interface for Supply operations
abstract class SupplyRepository {
  /// Get all supplies
  Future<List<SupplyEntity>> getAllSupplies();
  
  /// Get a supply by ID
  Future<SupplyEntity?> getSupplyById(String id);
  
  /// Get supplies by report ID
  Future<List<SupplyEntity>> getSuppliesByReportId(String reportId);
  
  /// Save a supply
  Future<void> saveSupply(SupplyEntity supply);
  
  /// Delete a supply
  Future<void> deleteSupply(String id);
  
  /// Add evidence to a supply
  Future<void> addEvidenceToSupply(String supplyId, EvidenceEntity evidence);
  
  /// Remove evidence from a supply
  Future<void> removeEvidenceFromSupply(String supplyId, String evidenceId);
  
  /// Update evidence in a supply
  Future<void> updateEvidenceInSupply(String supplyId, EvidenceEntity evidence);
}