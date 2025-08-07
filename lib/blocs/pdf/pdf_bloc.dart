import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supervisor/domain/repositories/report_repository.dart';
import 'package:supervisor/services/pdf_service.dart';

import 'pdf_event.dart';
import 'pdf_state.dart';

/// BLoC for managing PDF-related operations
class PdfBloc extends Bloc<PdfEvent, PdfState> {
  final ReportRepository _reportRepository;
  final PdfService _pdfService;

  PdfBloc({
    required ReportRepository reportRepository,
    required PdfService pdfService,
  })  : _reportRepository = reportRepository,
        _pdfService = pdfService,
        super(const PdfInitial()) {
    on<GeneratePdf>(_onGeneratePdf);
    on<GeneratePdfWithReport>(_onGeneratePdfWithReport);
    on<SharePdf>(_onSharePdf);
    on<PreviewPdf>(_onPreviewPdf);
  }

  Future<void> _onGeneratePdf(GeneratePdf event, Emitter<PdfState> emit) async {
    try {
      emit(const PdfGenerating());
      
      // Get the report
      final report = await _reportRepository.getReportById(event.reportId);
      if (report == null) {
        emit(const PdfOperationFailure('Report not found'));
        return;
      }
      
      // Generate PDF using the PDF service
      final pdfPath = await _pdfService.generatePdfReport(report);
      
      // Update the report with the PDF path
      await _reportRepository.setPdfPathForReport(report.id, pdfPath);
      
      emit(PdfGenerated(reportId: report.id, pdfPath: pdfPath));
    } catch (e) {
      emit(PdfOperationFailure('Failed to generate PDF: ${e.toString()}'));
    }
  }

  Future<void> _onGeneratePdfWithReport(GeneratePdfWithReport event, Emitter<PdfState> emit) async {
    try {
      emit(const PdfGenerating());
      
      // Generate PDF using the PDF service
      final pdfPath = await _pdfService.generatePdfReport(event.report);
      
      // Update the report with the PDF path
      await _reportRepository.setPdfPathForReport(event.report.id, pdfPath);
      
      emit(PdfGenerated(reportId: event.report.id, pdfPath: pdfPath));
    } catch (e) {
      emit(PdfOperationFailure('Failed to generate PDF: ${e.toString()}'));
    }
  }

  Future<void> _onSharePdf(SharePdf event, Emitter<PdfState> emit) async {
    try {
      emit(const PdfSharing());
      
      // Share the PDF file using share_plus package
      await Share.shareXFiles(
        [XFile(event.pdfPath)],
        text: 'Informe GPC - Supervisión de actividades',
      );
      
      emit(const PdfShared('PDF shared successfully'));
    } catch (e) {
      emit(PdfOperationFailure('Failed to share PDF: ${e.toString()}'));
    }
  }

  Future<void> _onPreviewPdf(PreviewPdf event, Emitter<PdfState> emit) async {
    try {
      // TODO: Implement PDF preview
      // This is a placeholder implementation
      // In a real implementation, we would navigate to a PDF preview screen
      
      // For now, we'll just emit a success state
      emit(const PdfShared('PDF preview opened'));
    } catch (e) {
      emit(PdfOperationFailure('Failed to preview PDF: ${e.toString()}'));
    }
  }
}