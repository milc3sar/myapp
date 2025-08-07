import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supervisor/domain/repositories/report_repository.dart';
import 'package:supervisor/services/pdf_service.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import 'pdf_event.dart';
import 'pdf_state.dart';

/// BLoC for managing PDF-related operations
class PdfBloc extends Bloc<PdfEvent, PdfState> {
  final ReportRepository _reportRepository;
  final PdfService _pdfService;

  PdfBloc({
    required ReportRepository reportRepository,
    PdfService? pdfService,
  })  : _reportRepository = reportRepository,
        _pdfService = pdfService ?? PdfService(),
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
      
      // Generate the PDF using the PDF service
      final outputDir = '/storage/emulated/0/Download';
      final pdfPath = await _pdfService.generateReportPdf(report, outputDir);
      
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
      
      // Generate the PDF using the PDF service
      final outputDir = '/storage/emulated/0/Download';
      final pdfPath = await _pdfService.generateReportPdf(event.report, outputDir);
      
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
      
      // Check if the PDF file exists
      final file = File(event.pdfPath);
      if (!await file.exists()) {
        emit(const PdfOperationFailure('PDF file not found'));
        return;
      }
      
      // Share the PDF using the Share Plus package
      final result = await Share.shareXFiles(
        [XFile(event.pdfPath)],
        text: 'Informe de Supervisión Técnica - GPC',
        subject: 'Informe de Supervisión',
      );
      
      if (result.status == ShareResultStatus.success) {
        emit(const PdfShared('PDF shared successfully'));
      } else if (result.status == ShareResultStatus.dismissed) {
        emit(const PdfShared('Share was cancelled'));
      } else {
        emit(const PdfOperationFailure('Failed to share PDF'));
      }
    } catch (e) {
      emit(PdfOperationFailure('Failed to share PDF: ${e.toString()}'));
    }
  }

  Future<void> _onPreviewPdf(PreviewPdf event, Emitter<PdfState> emit) async {
    try {
      // Check if the PDF file exists
      final file = File(event.pdfPath);
      if (!await file.exists()) {
        emit(const PdfOperationFailure('PDF file not found'));
        return;
      }
      
      // For PDF preview, we can use the native system to open the PDF
      // This could be extended to implement a custom PDF viewer if needed
      emit(PdfShared('PDF ready for preview at: ${event.pdfPath}'));
    } catch (e) {
      emit(PdfOperationFailure('Failed to preview PDF: ${e.toString()}'));
    }
  }
}