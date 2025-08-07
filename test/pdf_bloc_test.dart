import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supervisor/blocs/pdf/pdf_bloc.dart';
import 'package:supervisor/blocs/pdf/pdf_event.dart';
import 'package:supervisor/blocs/pdf/pdf_state.dart';
import 'package:supervisor/services/pdf_service.dart';
import 'package:supervisor/domain/repositories/report_repository.dart';
import 'package:supervisor/domain/entities/report_entity.dart';

// Mock classes
class MockReportRepository extends Mock implements ReportRepository {}
class MockPdfService extends Mock implements PdfService {}

void main() {
  group('PdfBloc Tests', () {
    late PdfBloc pdfBloc;
    late MockReportRepository mockReportRepository;
    late MockPdfService mockPdfService;

    setUp(() {
      mockReportRepository = MockReportRepository();
      mockPdfService = MockPdfService();
      pdfBloc = PdfBloc(
        reportRepository: mockReportRepository,
        pdfService: mockPdfService,
      );
    });

    tearDown(() {
      pdfBloc.close();
    });

    test('initial state should be PdfInitial', () {
      expect(pdfBloc.state, isA<PdfInitial>());
    });

    group('GeneratePdf', () {
      final testReport = ReportEntity(
        id: 'test-report-1',
        supervisorName: 'Test Supervisor',
        date: DateTime.now(),
        subject: 'Test Subject',
        activities: [true, false, true],
        supplies: [],
        conclusions: ['Test conclusion'],
        recommendations: ['Test recommendation'],
      );

      test('should emit PdfGenerated when PDF generation succeeds', () async {
        // Arrange
        const reportId = 'test-report-1';
        const expectedPdfPath = '/test/path/report.pdf';
        
        when(mockReportRepository.getReportById(reportId))
            .thenAnswer((_) async => testReport);
        when(mockPdfService.generateReportPdf(testReport, any))
            .thenAnswer((_) async => expectedPdfPath);
        when(mockReportRepository.setPdfPathForReport(reportId, expectedPdfPath))
            .thenAnswer((_) async {});

        // Act
        pdfBloc.add(const GeneratePdf(reportId));

        // Assert
        await expectLater(
          pdfBloc.stream,
          emitsInOrder([
            isA<PdfGenerating>(),
            PdfGenerated(reportId: reportId, pdfPath: expectedPdfPath),
          ]),
        );

        verify(mockReportRepository.getReportById(reportId)).called(1);
        verify(mockPdfService.generateReportPdf(testReport, any)).called(1);
        verify(mockReportRepository.setPdfPathForReport(reportId, expectedPdfPath)).called(1);
      });

      test('should emit PdfOperationFailure when report is not found', () async {
        // Arrange
        const reportId = 'non-existent-report';
        
        when(mockReportRepository.getReportById(reportId))
            .thenAnswer((_) async => null);

        // Act
        pdfBloc.add(const GeneratePdf(reportId));

        // Assert
        await expectLater(
          pdfBloc.stream,
          emitsInOrder([
            isA<PdfGenerating>(),
            const PdfOperationFailure('Report not found'),
          ]),
        );

        verify(mockReportRepository.getReportById(reportId)).called(1);
        verifyNever(mockPdfService.generateReportPdf(any, any));
      });

      test('should emit PdfOperationFailure when PDF generation fails', () async {
        // Arrange
        const reportId = 'test-report-1';
        const errorMessage = 'File system error';
        
        when(mockReportRepository.getReportById(reportId))
            .thenAnswer((_) async => testReport);
        when(mockPdfService.generateReportPdf(testReport, any))
            .thenThrow(Exception(errorMessage));

        // Act
        pdfBloc.add(const GeneratePdf(reportId));

        // Assert
        await expectLater(
          pdfBloc.stream,
          emitsInOrder([
            isA<PdfGenerating>(),
            PdfOperationFailure('Failed to generate PDF: Exception: $errorMessage'),
          ]),
        );

        verify(mockReportRepository.getReportById(reportId)).called(1);
        verify(mockPdfService.generateReportPdf(testReport, any)).called(1);
        verifyNever(mockReportRepository.setPdfPathForReport(any, any));
      });
    });

    group('GeneratePdfWithReport', () {
      final testReport = ReportEntity(
        id: 'test-report-2',
        supervisorName: 'Another Supervisor',
        date: DateTime.now(),
        subject: 'Another Subject',
        activities: [false, true, false],
        supplies: [],
        conclusions: [],
        recommendations: [],
      );

      test('should emit PdfGenerated when PDF generation succeeds', () async {
        // Arrange
        const expectedPdfPath = '/test/path/another_report.pdf';
        
        when(mockPdfService.generateReportPdf(testReport, any))
            .thenAnswer((_) async => expectedPdfPath);
        when(mockReportRepository.setPdfPathForReport(testReport.id, expectedPdfPath))
            .thenAnswer((_) async {});

        // Act
        pdfBloc.add(GeneratePdfWithReport(testReport));

        // Assert
        await expectLater(
          pdfBloc.stream,
          emitsInOrder([
            isA<PdfGenerating>(),
            PdfGenerated(reportId: testReport.id, pdfPath: expectedPdfPath),
          ]),
        );

        verify(mockPdfService.generateReportPdf(testReport, any)).called(1);
        verify(mockReportRepository.setPdfPathForReport(testReport.id, expectedPdfPath)).called(1);
      });

      test('should emit PdfOperationFailure when PDF generation fails', () async {
        // Arrange
        const errorMessage = 'Permission denied';
        
        when(mockPdfService.generateReportPdf(testReport, any))
            .thenThrow(Exception(errorMessage));

        // Act
        pdfBloc.add(GeneratePdfWithReport(testReport));

        // Assert
        await expectLater(
          pdfBloc.stream,
          emitsInOrder([
            isA<PdfGenerating>(),
            PdfOperationFailure('Failed to generate PDF: Exception: $errorMessage'),
          ]),
        );

        verify(mockPdfService.generateReportPdf(testReport, any)).called(1);
        verifyNever(mockReportRepository.setPdfPathForReport(any, any));
      });
    });

    // Note: SharePdf and PreviewPdf tests would require mocking File system operations
    // which are more complex. For now, we'll focus on the core PDF generation functionality.
  });
}