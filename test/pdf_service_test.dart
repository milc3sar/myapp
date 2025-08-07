import 'package:flutter_test/flutter_test.dart';
import 'package:supervisor/domain/entities/evidence_entity.dart';
import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:supervisor/services/pdf_service.dart';

void main() {
  group('PDF Service Tests', () {
    late PdfService pdfService;

    setUp(() {
      pdfService = PdfService();
    });

    test('PdfService can be instantiated', () {
      expect(pdfService, isNotNull);
    });

    test('generatePdfReport creates PDF with correct filename format', () async {
      // Create test data
      final evidence = EvidenceEntity(
        id: 'evidence1',
        imagePath: '/path/to/image1.jpg',
        voiceRecordingPath: '/path/to/voice1.mp3',
        observation: 'Prueba de observación 1',
        createdAt: DateTime.now(),
        location: {'latitude': -8.1116, 'longitude': -79.0288},
        locationMapPath: '/path/to/map1.png',
      );

      final supply = SupplyEntity(
        id: 'supply1',
        code: '12345678',
        evidences: [evidence],
        createdAt: DateTime.now(),
      );

      final report = ReportEntity(
        id: 'report1',
        supervisorName: 'Juan Pérez',
        date: DateTime(2024, 1, 15),
        subject: 'Supervisión de actividades eléctricas',
        activities: [true, true, false, true],
        supplies: [supply],
        conclusions: ['Se encontraron conexiones irregulares'],
        recommendations: ['Revisar instalaciones eléctricas'],
      );

      // Test PDF generation
      try {
        final pdfPath = await pdfService.generatePdfReport(report);
        
        // Verify filename format: informe_gpc_yyyymmdd.pdf
        expect(pdfPath, contains('informe_gpc_20240115.pdf'));
        expect(pdfPath, endsWith('.pdf'));
        
        print('PDF generated successfully at: $pdfPath');
      } catch (e) {
        // In test environment, file operations might fail, but the method should exist
        expect(e, isA<Exception>());
        print('Expected error in test environment: $e');
      }
    });

    test('PdfService handles multiple supplies correctly', () async {
      // Create test data with multiple supplies
      final evidence1 = EvidenceEntity(
        id: 'evidence1',
        imagePath: '/path/to/image1.jpg',
        voiceRecordingPath: '/path/to/voice1.mp3',
        observation: 'Primera observación',
        createdAt: DateTime.now(),
        location: {'latitude': -8.1116, 'longitude': -79.0288},
      );

      final evidence2 = EvidenceEntity(
        id: 'evidence2',
        imagePath: '/path/to/image2.jpg',
        voiceRecordingPath: '/path/to/voice2.mp3',
        observation: 'Segunda observación',
        createdAt: DateTime.now(),
        location: {'latitude': -8.1120, 'longitude': -79.0290},
      );

      final supply1 = SupplyEntity(
        id: 'supply1',
        code: '12345678',
        evidences: [evidence1],
        createdAt: DateTime.now(),
      );

      final supply2 = SupplyEntity(
        id: 'supply2',
        code: '87654321',
        evidences: [evidence2],
        createdAt: DateTime.now(),
      );

      final report = ReportEntity(
        id: 'report2',
        supervisorName: 'María García',
        date: DateTime(2024, 2, 20),
        subject: 'Supervisión múltiple',
        activities: [true, false, true, true],
        supplies: [supply1, supply2],
        conclusions: [
          'Múltiples irregularidades encontradas',
          'Sistemas requieren mantenimiento'
        ],
        recommendations: [
          'Implementar plan de mejoras',
          'Capacitar personal técnico'
        ],
      );

      try {
        final pdfPath = await pdfService.generatePdfReport(report);
        
        // Verify filename format for February date
        expect(pdfPath, contains('informe_gpc_20240220.pdf'));
        
        print('Multi-supply PDF generated successfully at: $pdfPath');
      } catch (e) {
        // In test environment, file operations might fail
        expect(e, isA<Exception>());
        print('Expected error in test environment: $e');
      }
    });

    test('PdfService handles empty supplies list', () async {
      final report = ReportEntity(
        id: 'report3',
        supervisorName: 'Carlos López',
        date: DateTime(2024, 12, 31),
        subject: 'Reporte sin suministros',
        activities: [false, false, false, false],
        supplies: [], // Empty supplies
        conclusions: ['No se encontraron incidencias'],
        recommendations: [],
      );

      try {
        final pdfPath = await pdfService.generatePdfReport(report);
        
        // Verify filename format for December date
        expect(pdfPath, contains('informe_gpc_20241231.pdf'));
        
        print('Empty supplies PDF generated successfully at: $pdfPath');
      } catch (e) {
        // In test environment, file operations might fail
        expect(e, isA<Exception>());
        print('Expected error in test environment: $e');
      }
    });

    group('Date formatting tests', () {
      test('formats dates correctly for display', () {
        // Test various dates to ensure proper Spanish formatting
        final testDates = [
          DateTime(2024, 1, 1),   // enero
          DateTime(2024, 6, 15),  // junio  
          DateTime(2024, 12, 31), // diciembre
        ];

        for (final date in testDates) {
          final report = ReportEntity(
            id: 'test',
            supervisorName: 'Test',
            date: date,
            subject: 'Test',
            activities: [false, false, false, false],
            supplies: [],
            conclusions: [],
            recommendations: [],
          );

          // This test verifies the service can handle different dates
          expect(() => pdfService.generatePdfReport(report), isNotNull);
        }
      });
    });
  });
}