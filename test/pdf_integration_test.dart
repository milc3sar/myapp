import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supervisor/blocs/pdf/pdf_bloc.dart';
import 'package:supervisor/blocs/pdf/pdf_event.dart';
import 'package:supervisor/blocs/pdf/pdf_state.dart';
import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:supervisor/domain/entities/evidence_entity.dart';
import 'package:supervisor/domain/repositories/report_repository.dart';
import 'package:supervisor/services/pdf_service.dart';

// Mock classes
class MockReportRepository extends Mock implements ReportRepository {}
class MockPdfService extends Mock implements PdfService {}

void main() {
  group('PDF Generation Integration Tests', () {
    late MockReportRepository mockReportRepository;
    late MockPdfService mockPdfService;
    late PdfBloc pdfBloc;

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

    test('should emit correct states when generating PDF successfully', () async {
      // Arrange
      final report = ReportEntity(
        id: 'test-report-1',
        supervisorName: 'Ing. Test Supervisor',
        date: DateTime.now(),
        subject: 'Test Inspection',
        activities: [true, false, true, false],
        supplies: [],
        conclusions: ['Test conclusion'],
        recommendations: ['Test recommendation'],
      );

      final expectedPdfPath = '/storage/emulated/0/Download/informe_supervision_test-report-1.pdf';

      when(mockPdfService.generatePdfPath('test-report-1'))
          .thenReturn(expectedPdfPath);
      when(mockPdfService.generatePdfReport(report, expectedPdfPath))
          .thenAnswer((_) async => expectedPdfPath);
      when(mockReportRepository.setPdfPathForReport('test-report-1', expectedPdfPath))
          .thenAnswer((_) async {});

      // Act & Assert
      expectLater(
        pdfBloc.stream,
        emitsInOrder([
          isA<PdfGenerating>(),
          isA<PdfGenerated>()
              .having((state) => state.reportId, 'reportId', 'test-report-1')
              .having((state) => state.pdfPath, 'pdfPath', expectedPdfPath),
        ]),
      );

      pdfBloc.add(GeneratePdfWithReport(report));
    });

    test('should emit failure state when PDF generation fails', () async {
      // Arrange
      final report = ReportEntity(
        id: 'test-report-2',
        supervisorName: 'Ing. Test Supervisor',
        date: DateTime.now(),
        subject: 'Test Inspection',
        activities: [true, false, true, false],
        supplies: [],
        conclusions: ['Test conclusion'],
        recommendations: ['Test recommendation'],
      );

      when(mockPdfService.generatePdfPath('test-report-2'))
          .thenReturn('/test/path.pdf');
      when(mockPdfService.generatePdfReport(any, any))
          .thenThrow(Exception('PDF generation failed'));

      // Act & Assert
      expectLater(
        pdfBloc.stream,
        emitsInOrder([
          isA<PdfGenerating>(),
          isA<PdfOperationFailure>()
              .having((state) => state.message, 'message', 
                      contains('Failed to generate PDF')),
        ]),
      );

      pdfBloc.add(GeneratePdfWithReport(report));
    });
  });

  group('PDF Service Feature Tests', () {
    test('should handle complex report with multiple supplies and evidences', () {
      // Arrange
      final evidence1 = EvidenceEntity(
        id: 'evidence-1',
        imagePath: '/path/to/image1.jpg',
        voiceRecordingPath: '/path/to/audio1.mp3',
        observation: 'First evidence observation',
        createdAt: DateTime.now(),
        location: {'latitude': 10.0, 'longitude': -67.0},
      );

      final evidence2 = EvidenceEntity(
        id: 'evidence-2',
        imagePath: '/path/to/image2.jpg',
        voiceRecordingPath: '/path/to/audio2.mp3',
        observation: 'Second evidence observation',
        createdAt: DateTime.now(),
        location: {'latitude': 10.1, 'longitude': -67.1},
      );

      final supply1 = SupplyEntity(
        id: 'supply-1',
        code: '12345678',
        evidences: [evidence1],
        createdAt: DateTime.now(),
      );

      final supply2 = SupplyEntity(
        id: 'supply-2',
        code: '87654321',
        evidences: [evidence2],
        createdAt: DateTime.now(),
      );

      final complexReport = ReportEntity(
        id: 'complex-report',
        supervisorName: 'Ing. Complex Test',
        date: DateTime.now(),
        subject: 'Complex Inspection with Multiple Supplies',
        activities: [true, true, false, true],
        supplies: [supply1, supply2],
        conclusions: [
          'Multiple supplies inspected successfully',
          'All evidences properly documented',
          'Location data captured for all evidences'
        ],
        recommendations: [
          'Continue regular monitoring',
          'Schedule follow-up inspection',
          'Update maintenance records'
        ],
      );

      // Assert
      expect(complexReport.supplies, hasLength(2));
      expect(complexReport.supplies.first.evidences, hasLength(1));
      expect(complexReport.supplies.last.evidences, hasLength(1));
      expect(complexReport.conclusions, hasLength(3));
      expect(complexReport.recommendations, hasLength(3));
      expect(complexReport.activities.where((a) => a), hasLength(3));
    });

    test('should handle report with no supplies', () {
      // Arrange
      final emptyReport = ReportEntity(
        id: 'empty-report',
        supervisorName: 'Ing. Empty Test',
        date: DateTime.now(),
        subject: 'Report with No Supplies',
        activities: [false, false, false, true],
        supplies: [],
        conclusions: ['No supplies to inspect'],
        recommendations: ['Plan future inspection'],
      );

      // Assert
      expect(emptyReport.supplies, isEmpty);
      expect(emptyReport.conclusions, isNotEmpty);
      expect(emptyReport.recommendations, isNotEmpty);
      expect(emptyReport.activities.where((a) => a), hasLength(1));
    });

    test('should validate PDF file naming convention', () {
      final pdfService = PdfService();
      
      // Test different report IDs
      final testIds = [
        'report-123',
        'test-report-456',
        'complex_report_789',
      ];

      for (final id in testIds) {
        final path = pdfService.generatePdfPath(id);
        
        expect(path, contains('informe_supervision_$id.pdf'));
        expect(path, contains('/storage/emulated/0/Download/'));
        expect(path, endsWith('.pdf'));
      }
    });
  });

  group('Activity Labels Validation', () {
    test('should have correct number of activity labels', () {
      expect(PdfService.activityLabels, hasLength(4));
      expect(PdfService.activityLabels, contains('Inspección de medidores'));
      expect(PdfService.activityLabels, contains('Verificación de conexiones'));
      expect(PdfService.activityLabels, contains('Control de pérdidas técnicas'));
      expect(PdfService.activityLabels, contains('Elaboración de informe técnico'));
    });
  });
}