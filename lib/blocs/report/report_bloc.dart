import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:supervisor/domain/repositories/report_repository.dart';
import 'package:uuid/uuid.dart';

import 'report_event.dart';
import 'report_state.dart';

/// BLoC for managing report-related operations
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository _reportRepository;

  ReportBloc({required ReportRepository reportRepository})
      : _reportRepository = reportRepository,
        super(const ReportInitial()) {
    on<LoadReports>(_onLoadReports);
    on<LoadReport>(_onLoadReport);
    on<CreateReport>(_onCreateReport);
    on<UpdateReport>(_onUpdateReport);
    on<DeleteReport>(_onDeleteReport);
    on<AddSupplyToReport>(_onAddSupplyToReport);
    on<RemoveSupplyFromReport>(_onRemoveSupplyFromReport);
    on<AddConclusionToReport>(_onAddConclusionToReport);
    on<RemoveConclusionFromReport>(_onRemoveConclusionFromReport);
    on<AddRecommendationToReport>(_onAddRecommendationToReport);
    on<RemoveRecommendationFromReport>(_onRemoveRecommendationFromReport);
    on<SetPdfPathForReport>(_onSetPdfPathForReport);
    on<CreateSupplyAndAddToReport>(_onCreateSupplyAndAddToReport);
  }

  Future<void> _onLoadReports(LoadReports event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      final reports = await _reportRepository.getAllReports();
      // Sort reports by date, newest first
      reports.sort((a, b) => b.date.compareTo(a.date));
      emit(ReportsLoaded(reports));
    } catch (e) {
      emit(ReportOperationFailure('Failed to load reports: ${e.toString()}'));
    }
  }



  Future<void> _onLoadReport(LoadReport event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      final report = await _reportRepository.getReportById(event.id);
      if (report != null) {
        emit(ReportLoaded(report));
      } else {
        emit(const ReportOperationFailure('Report not found'));
      }
    } catch (e) {
      emit(ReportOperationFailure('Failed to load report: ${e.toString()}'));
    }
  }

  Future<void> _onCreateReport(CreateReport event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      
      // Create a new report entity
      final report = ReportEntity(
        id: const Uuid().v4(),
        supervisorName: event.supervisorName,
        date: event.date ?? DateTime.now(),
        subject: event.subject,
        activities: event.activities,
        supplies: const [],
        conclusions: const [],
        recommendations: const [],
      );
      
      // Save the report
      await _reportRepository.saveReport(report);
      
      emit(ReportOperationSuccess('Report created successfully'));
      
      // Load all reports to update the list with the newly created report
      add(const LoadReports());
    } catch (e) {
      emit(ReportOperationFailure('Failed to create report: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateReport(UpdateReport event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      await _reportRepository.saveReport(event.report);
      emit(ReportOperationSuccess('Report updated successfully'));
      add(LoadReport(event.report.id));
    } catch (e) {
      emit(ReportOperationFailure('Failed to update report: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteReport(DeleteReport event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      await _reportRepository.deleteReport(event.id);
      emit(const ReportOperationSuccess('Report deleted successfully'));
      add(const LoadReports());
    } catch (e) {
      emit(ReportOperationFailure('Failed to delete report: ${e.toString()}'));
    }
  }

  Future<void> _onAddSupplyToReport(AddSupplyToReport event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      await _reportRepository.addSupplyToReport(event.reportId, event.supply);
      emit(const ReportOperationSuccess('Supply added to report successfully'));
      add(LoadReport(event.reportId));
    } catch (e) {
      emit(ReportOperationFailure('Failed to add supply to report: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveSupplyFromReport(RemoveSupplyFromReport event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      await _reportRepository.removeSupplyFromReport(event.reportId, event.supplyId);
      emit(const ReportOperationSuccess('Supply removed from report successfully'));
      add(LoadReport(event.reportId));
    } catch (e) {
      emit(ReportOperationFailure('Failed to remove supply from report: ${e.toString()}'));
    }
  }

  Future<void> _onAddConclusionToReport(AddConclusionToReport event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      await _reportRepository.addConclusionToReport(event.reportId, event.conclusion);
      emit(const ReportOperationSuccess('Conclusion added to report successfully'));
      add(LoadReport(event.reportId));
    } catch (e) {
      emit(ReportOperationFailure('Failed to add conclusion to report: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveConclusionFromReport(RemoveConclusionFromReport event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      await _reportRepository.removeConclusionFromReport(event.reportId, event.index);
      emit(const ReportOperationSuccess('Conclusion removed from report successfully'));
      add(LoadReport(event.reportId));
    } catch (e) {
      emit(ReportOperationFailure('Failed to remove conclusion from report: ${e.toString()}'));
    }
  }

  Future<void> _onAddRecommendationToReport(AddRecommendationToReport event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      await _reportRepository.addRecommendationToReport(event.reportId, event.recommendation);
      emit(const ReportOperationSuccess('Recommendation added to report successfully'));
      add(LoadReport(event.reportId));
    } catch (e) {
      emit(ReportOperationFailure('Failed to add recommendation to report: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveRecommendationFromReport(RemoveRecommendationFromReport event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      await _reportRepository.removeRecommendationFromReport(event.reportId, event.index);
      emit(const ReportOperationSuccess('Recommendation removed from report successfully'));
      add(LoadReport(event.reportId));
    } catch (e) {
      emit(ReportOperationFailure('Failed to remove recommendation from report: ${e.toString()}'));
    }
  }

  Future<void> _onSetPdfPathForReport(SetPdfPathForReport event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      await _reportRepository.setPdfPathForReport(event.reportId, event.pdfPath);
      emit(const ReportOperationSuccess('PDF path set for report successfully'));
      add(LoadReport(event.reportId));
    } catch (e) {
      emit(ReportOperationFailure('Failed to set PDF path for report: ${e.toString()}'));
    }
  }

  Future<void> _onCreateSupplyAndAddToReport(CreateSupplyAndAddToReport event, Emitter<ReportState> emit) async {
    try {
      emit(const ReportLoading());
      
      // Validate supply code (8 digits)
      if (event.code.length != 8 || int.tryParse(event.code) == null) {
        emit(const ReportOperationFailure('Supply code must be 8 digits'));
        return;
      }
      
      // Create a new supply entity
      final supply = SupplyEntity(
        id: const Uuid().v4(),
        code: event.code,
        evidences: const [],
        createdAt: DateTime.now(),
      );
      
      // Add the supply to the report
      await _reportRepository.addSupplyToReport(event.reportId, supply);
      
      emit(const ReportOperationSuccess('Supply created and added to report successfully'));
      
      // Reload the report to update the UI
      add(LoadReport(event.reportId));
    } catch (e) {
      emit(ReportOperationFailure('Failed to create and add supply to report: ${e.toString()}'));
    }
  }
}