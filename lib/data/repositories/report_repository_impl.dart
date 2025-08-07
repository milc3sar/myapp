import 'package:supervisor/data/datasources/local_storage.dart';
import 'package:supervisor/data/models/report.dart';
import 'package:supervisor/data/models/supply.dart';
import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:supervisor/domain/repositories/report_repository.dart';

import '../../domain/entities/evidence_entity.dart';
import '../models/evidence.dart';

/// Implementation of the ReportRepository interface
class ReportRepositoryImpl implements ReportRepository {
  final LocalStorage _localStorage;

  ReportRepositoryImpl({required LocalStorage localStorage})
      : _localStorage = localStorage;

  @override
  Future<List<ReportEntity>> getAllReports() async {
    final reports = await _localStorage.getAllReports();
    return reports.map(_mapReportToEntity).toList();
  }

  @override
  Future<ReportEntity?> getReportById(String id) async {
    final report = await _localStorage.getReportById(id);
    return report != null ? _mapReportToEntity(report) : null;
  }

  @override
  Future<void> saveReport(ReportEntity report) async {
    await _localStorage.saveReport(_mapEntityToReport(report));
  }

  @override
  Future<void> deleteReport(String id) async {
    await _localStorage.deleteReport(id);
  }

  @override
  Future<void> addSupplyToReport(String reportId, SupplyEntity supply) async {
    final report = await _localStorage.getReportById(reportId);
    if (report == null) {
      throw Exception('Report not found');
    }

    final updatedSupplies = [...report.supplies, _mapEntityToSupply(supply)];
    final updatedReport = report.copyWith(supplies: updatedSupplies);
    await _localStorage.saveReport(updatedReport);
  }

  @override
  Future<void> removeSupplyFromReport(String reportId, String supplyId) async {
    final report = await _localStorage.getReportById(reportId);
    if (report == null) {
      throw Exception('Report not found');
    }

    final updatedSupplies = report.supplies.where((s) => s.id != supplyId).toList();
    final updatedReport = report.copyWith(supplies: updatedSupplies);
    await _localStorage.saveReport(updatedReport);
  }

  @override
  Future<void> updateSupplyInReport(String reportId, SupplyEntity supply) async {
    final report = await _localStorage.getReportById(reportId);
    if (report == null) {
      throw Exception('Report not found');
    }

    final updatedSupplies = report.supplies.map((s) {
      return s.id == supply.id ? _mapEntityToSupply(supply) : s;
    }).toList();
    
    final updatedReport = report.copyWith(supplies: updatedSupplies);
    await _localStorage.saveReport(updatedReport);
  }

  @override
  Future<void> addConclusionToReport(String reportId, String conclusion) async {
    final report = await _localStorage.getReportById(reportId);
    if (report == null) {
      throw Exception('Report not found');
    }

    final updatedConclusions = [...report.conclusions, conclusion];
    final updatedReport = report.copyWith(conclusions: updatedConclusions);
    await _localStorage.saveReport(updatedReport);
  }

  @override
  Future<void> removeConclusionFromReport(String reportId, int index) async {
    final report = await _localStorage.getReportById(reportId);
    if (report == null) {
      throw Exception('Report not found');
    }

    if (index < 0 || index >= report.conclusions.length) {
      throw Exception('Invalid conclusion index');
    }

    final updatedConclusions = List<String>.from(report.conclusions);
    updatedConclusions.removeAt(index);
    
    final updatedReport = report.copyWith(conclusions: updatedConclusions);
    await _localStorage.saveReport(updatedReport);
  }

  @override
  Future<void> addRecommendationToReport(String reportId, String recommendation) async {
    final report = await _localStorage.getReportById(reportId);
    if (report == null) {
      throw Exception('Report not found');
    }

    final updatedRecommendations = [...report.recommendations, recommendation];
    final updatedReport = report.copyWith(recommendations: updatedRecommendations);
    await _localStorage.saveReport(updatedReport);
  }

  @override
  Future<void> removeRecommendationFromReport(String reportId, int index) async {
    final report = await _localStorage.getReportById(reportId);
    if (report == null) {
      throw Exception('Report not found');
    }

    if (index < 0 || index >= report.recommendations.length) {
      throw Exception('Invalid recommendation index');
    }

    final updatedRecommendations = List<String>.from(report.recommendations);
    updatedRecommendations.removeAt(index);
    
    final updatedReport = report.copyWith(recommendations: updatedRecommendations);
    await _localStorage.saveReport(updatedReport);
  }

  @override
  Future<void> setPdfPathForReport(String reportId, String pdfPath) async {
    final report = await _localStorage.getReportById(reportId);
    if (report == null) {
      throw Exception('Report not found');
    }

    final updatedReport = report.copyWith(pdfPath: pdfPath);
    await _localStorage.saveReport(updatedReport);
  }

  // Helper methods to map between domain entities and data models
  ReportEntity _mapReportToEntity(Report report) {
    return ReportEntity(
      id: report.id,
      supervisorName: report.supervisorName,
      date: report.date,
      subject: report.subject,
      activities: report.activities,
      supplies: report.supplies.map(_mapSupplyToEntity).toList(),
      conclusions: report.conclusions,
      recommendations: report.recommendations,
      pdfPath: report.pdfPath,
    );
  }

  Report _mapEntityToReport(ReportEntity entity) {
    return Report(
      id: entity.id,
      supervisorName: entity.supervisorName,
      date: entity.date,
      subject: entity.subject,
      activities: entity.activities,
      supplies: entity.supplies.map(_mapEntityToSupply).toList(),
      conclusions: entity.conclusions,
      recommendations: entity.recommendations,
      pdfPath: entity.pdfPath,
    );
  }

  SupplyEntity _mapSupplyToEntity(Supply supply) {
    return SupplyEntity(
      id: supply.id,
      code: supply.code,
      createdAt: supply.createdAt,
      evidences: supply.evidences.map((e) => EvidenceEntity(
        id: e.id,
        imagePath: e.imagePath,
        voiceRecordingPath: e.voiceRecordingPath,
        observation: e.observation,
        createdAt: e.createdAt,
        location: e.location,
        locationMapPath: e.locationMapPath,
      )).toList(),
    );
  }

  Supply _mapEntityToSupply(SupplyEntity entity) {
    return Supply(
      id: entity.id,
      code: entity.code,
      createdAt: entity.createdAt,
      evidences: entity.evidences.map((e) => Evidence(
        id: e.id,
        imagePath: e.imagePath,
        voiceRecordingPath: e.voiceRecordingPath,
        observation: e.observation,
        createdAt: e.createdAt,
        location: e.location,
        locationMapPath: e.locationMapPath,
      )).toList(),
    );
  }
}