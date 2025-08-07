import 'package:equatable/equatable.dart';
import 'package:supervisor/domain/entities/report_entity.dart';

/// Events for the PdfBloc
abstract class PdfEvent extends Equatable {
  const PdfEvent();

  @override
  List<Object?> get props => [];
}

/// Event to generate a PDF for a report
class GeneratePdf extends PdfEvent {
  final String reportId;

  const GeneratePdf(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

/// Event to generate a PDF for a report with the report entity
class GeneratePdfWithReport extends PdfEvent {
  final ReportEntity report;

  const GeneratePdfWithReport(this.report);

  @override
  List<Object?> get props => [report];
}

/// Event to share a PDF
class SharePdf extends PdfEvent {
  final String pdfPath;
  final String shareMethod; // 'whatsapp', 'email', 'bluetooth', etc.

  const SharePdf({
    required this.pdfPath,
    required this.shareMethod,
  });

  @override
  List<Object?> get props => [pdfPath, shareMethod];
}

/// Event to preview a PDF
class PreviewPdf extends PdfEvent {
  final String pdfPath;

  const PreviewPdf(this.pdfPath);

  @override
  List<Object?> get props => [pdfPath];
}