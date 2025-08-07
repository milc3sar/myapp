import 'package:flutter_test/flutter_test.dart';
import 'package:supervisor/services/pdf_service.dart';
import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:supervisor/domain/entities/evidence_entity.dart';
import 'dart:io';

void main() {
  group('PdfService Tests', () {
    late PdfService pdfService;
    late Directory tempDir;

    setUpAll(() async {
      pdfService = PdfService();
      tempDir = await Directory.systemTemp.createTemp('pdf_test');
    });

    tearDownAll(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('should generate PDF for empty report', () async {
      // Arrange
      final report = ReportEntity(
        id: 'test-report-1',
        supervisorName: 'Juan Pérez',
        date: DateTime(2024, 1, 15, 10, 30),
        subject: 'Supervisión rutinaria de infraestructura',
        activities: [true, false, true, false, false, false, false, false],
        supplies: [],
        conclusions: ['Todo en orden'],
        recommendations: ['Continuar con las revisiones periódicas'],
      );

      // Act
      final pdfPath = await pdfService.generateReportPdf(report, tempDir.path);

      // Assert
      expect(pdfPath, isNotNull);
      final file = File(pdfPath);
      expect(await file.exists(), isTrue);
      expect(await file.length(), greaterThan(0));
      
      // Verify filename format
      expect(pdfPath, contains('informe_supervision_test-report-1_20240115_1030.pdf'));
    });

    test('should generate PDF for report with supplies and evidences', () async {
      // Arrange
      final evidence1 = EvidenceEntity(
        id: 'evidence-1',
        imagePath: '/path/to/image1.jpg',
        voiceRecordingPath: '/path/to/audio1.m4a',
        observation: 'Medidor en buen estado, lectura normal',
        createdAt: DateTime(2024, 1, 15, 11, 0),
        location: {'latitude': -12.046374, 'longitude': -77.042793},
      );

      final evidence2 = EvidenceEntity(
        id: 'evidence-2',
        imagePath: '/path/to/image2.jpg',
        voiceRecordingPath: '/path/to/audio2.m4a',
        observation: 'Conexión presenta corrosión menor',
        createdAt: DateTime(2024, 1, 15, 11, 15),
        location: {'latitude': -12.046500, 'longitude': -77.042900},
      );

      final supply1 = SupplyEntity(
        id: 'supply-1',
        code: '12345678',
        evidences: [evidence1, evidence2],
        createdAt: DateTime(2024, 1, 15, 11, 0),
      );

      final supply2 = SupplyEntity(
        id: 'supply-2',
        code: '87654321',
        evidences: [],
        createdAt: DateTime(2024, 1, 15, 11, 30),
      );

      final report = ReportEntity(
        id: 'test-report-2',
        supervisorName: 'María García',
        date: DateTime(2024, 1, 15, 9, 0),
        subject: 'Inspección detallada de medidores zona centro',
        activities: [true, true, false, true, false, true, true, false],
        supplies: [supply1, supply2],
        conclusions: [
          'Se encontraron 2 suministros en la zona asignada',
          'Un suministro presenta corrosión menor que debe monitorearse',
          'El resto de la infraestructura está en condiciones normales'
        ],
        recommendations: [
          'Programar mantenimiento preventivo en 3 meses',
          'Realizar seguimiento del suministro 12345678',
          'Documentar todas las intervenciones futuras'
        ],
      );

      // Act
      final pdfPath = await pdfService.generateReportPdf(report, tempDir.path);

      // Assert
      expect(pdfPath, isNotNull);
      final file = File(pdfPath);
      expect(await file.exists(), isTrue);
      expect(await file.length(), greaterThan(0));
      
      // Verify filename format
      expect(pdfPath, contains('informe_supervision_test-report-2_20240115_0900.pdf'));
    });

    test('should handle special characters in report data', () async {
      // Arrange
      final report = ReportEntity(
        id: 'test-report-3',
        supervisorName: 'José María Rodríguez-Pérez',
        date: DateTime(2024, 12, 31, 23, 59),
        subject: 'Supervisión especial: verificación post-tormenta área N°123',
        activities: [false, false, false, false, false, false, false, false],
        supplies: [],
        conclusions: [
          'Revisión completada satisfactoriamente según normativa N°456-2024',
          'No se detectaron anomalías críticas en la infraestructura evaluada'
        ],
        recommendations: [
          'Mantener protocolo de seguridad vigente (Res. N°789/2024)',
          'Programar revisión extraordinaria en 30 días hábiles'
        ],
      );

      // Act
      final pdfPath = await pdfService.generateReportPdf(report, tempDir.path);

      // Assert
      expect(pdfPath, isNotNull);
      final file = File(pdfPath);
      expect(await file.exists(), isTrue);
      expect(await file.length(), greaterThan(0));
    });

    test('should create output directory if it does not exist', () async {
      // Arrange
      final nonExistentDir = '${tempDir.path}/non_existent_subdir';
      final report = ReportEntity(
        id: 'test-report-4',
        supervisorName: 'Test Supervisor',
        date: DateTime.now(),
        subject: 'Test Subject',
        activities: [],
        supplies: [],
        conclusions: [],
        recommendations: [],
      );

      // Act
      final pdfPath = await pdfService.generateReportPdf(report, nonExistentDir);

      // Assert
      expect(pdfPath, isNotNull);
      final file = File(pdfPath);
      expect(await file.exists(), isTrue);
      expect(await Directory(nonExistentDir).exists(), isTrue);
    });
  });
}