import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';

/// Repository interface for Report operations
abstract class ReportRepository {
  /// Get all reports
  Future<List<ReportEntity>> getAllReports();
  
  /// Get a report by ID
  Future<ReportEntity?> getReportById(String id);
  
  /// Save a report
  Future<void> saveReport(ReportEntity report);
  
  /// Delete a report
  Future<void> deleteReport(String id);
  
  /// Add a supply to a report
  Future<void> addSupplyToReport(String reportId, SupplyEntity supply);
  
  /// Remove a supply from a report
  Future<void> removeSupplyFromReport(String reportId, String supplyId);
  
  /// Update a supply in a report
  Future<void> updateSupplyInReport(String reportId, SupplyEntity supply);
  
  /// Add a conclusion to a report
  Future<void> addConclusionToReport(String reportId, String conclusion);
  
  /// Remove a conclusion from a report
  Future<void> removeConclusionFromReport(String reportId, int index);
  
  /// Add a recommendation to a report
  Future<void> addRecommendationToReport(String reportId, String recommendation);
  
  /// Remove a recommendation from a report
  Future<void> removeRecommendationFromReport(String reportId, int index);
  
  /// Set the PDF path for a report
  Future<void> setPdfPathForReport(String reportId, String pdfPath);
}