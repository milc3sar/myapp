import 'package:equatable/equatable.dart';
import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';

/// Events for the ReportBloc
abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all reports
class LoadReports extends ReportEvent {
  const LoadReports();
}

/// Event to load a specific report by ID
class LoadReport extends ReportEvent {
  final String id;

  const LoadReport(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to create a new report
class CreateReport extends ReportEvent {
  final String supervisorName;
  final String subject;
  final List<bool> activities;
  final DateTime? date;

  const CreateReport({
    required this.supervisorName,
    required this.subject,
    required this.activities,
    this.date,
  });

  @override
  List<Object?> get props => [supervisorName, subject, activities, date];
}

/// Event to update an existing report
class UpdateReport extends ReportEvent {
  final ReportEntity report;

  const UpdateReport(this.report);

  @override
  List<Object?> get props => [report];
}

/// Event to delete a report
class DeleteReport extends ReportEvent {
  final String id;

  const DeleteReport(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to add a supply to a report
class AddSupplyToReport extends ReportEvent {
  final String reportId;
  final SupplyEntity supply;

  const AddSupplyToReport(this.reportId, this.supply);

  @override
  List<Object?> get props => [reportId, supply];
}

/// Event to remove a supply from a report
class RemoveSupplyFromReport extends ReportEvent {
  final String reportId;
  final String supplyId;

  const RemoveSupplyFromReport(this.reportId, this.supplyId);

  @override
  List<Object?> get props => [reportId, supplyId];
}

/// Event to add a conclusion to a report
class AddConclusionToReport extends ReportEvent {
  final String reportId;
  final String conclusion;

  const AddConclusionToReport(this.reportId, this.conclusion);

  @override
  List<Object?> get props => [reportId, conclusion];
}

/// Event to remove a conclusion from a report
class RemoveConclusionFromReport extends ReportEvent {
  final String reportId;
  final int index;

  const RemoveConclusionFromReport(this.reportId, this.index);

  @override
  List<Object?> get props => [reportId, index];
}

/// Event to add a recommendation to a report
class AddRecommendationToReport extends ReportEvent {
  final String reportId;
  final String recommendation;

  const AddRecommendationToReport(this.reportId, this.recommendation);

  @override
  List<Object?> get props => [reportId, recommendation];
}

/// Event to remove a recommendation from a report
class RemoveRecommendationFromReport extends ReportEvent {
  final String reportId;
  final int index;

  const RemoveRecommendationFromReport(this.reportId, this.index);

  @override
  List<Object?> get props => [reportId, index];
}

/// Event to set the PDF path for a report
class SetPdfPathForReport extends ReportEvent {
  final String reportId;
  final String pdfPath;

  const SetPdfPathForReport(this.reportId, this.pdfPath);

  @override
  List<Object?> get props => [reportId, pdfPath];
}

/// Event to create a supply with a code and add it to a report
class CreateSupplyAndAddToReport extends ReportEvent {
  final String reportId;
  final String code;

  const CreateSupplyAndAddToReport({
    required this.reportId,
    required this.code,
  });

  @override
  List<Object?> get props => [reportId, code];
}