import 'package:supervisor/domain/entities/evidence_entity.dart';
import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:supervisor/services/pdf_service.dart';

/// Example usage of the PDF service
/// This demonstrates how the PDF generation should be used in the application
void main() async {
  // Create sample evidence
  final evidence1 = EvidenceEntity(
    id: '1',
    imagePath: '/storage/photos/evidence1.jpg',
    voiceRecordingPath: '/storage/audio/voice1.mp3',
    observation: 'Se observa conexión irregular en el medidor eléctrico',
    createdAt: DateTime.now(),
    location: {
      'latitude': -8.1116,
      'longitude': -79.0288,
    },
    locationMapPath: '/storage/maps/location1.png',
  );

  final evidence2 = EvidenceEntity(
    id: '2',
    imagePath: '/storage/photos/evidence2.jpg',
    voiceRecordingPath: '/storage/audio/voice2.mp3',
    observation: 'Cable expuesto presenta riesgo de electrocución',
    createdAt: DateTime.now(),
    location: {
      'latitude': -8.1120,
      'longitude': -79.0285,
    },
    locationMapPath: '/storage/maps/location2.png',
  );

  final evidence3 = EvidenceEntity(
    id: '3',
    imagePath: '/storage/photos/evidence3.jpg',
    voiceRecordingPath: '/storage/audio/voice3.mp3',
    observation: 'Instalación no cumple con normativas de seguridad',
    createdAt: DateTime.now(),
    location: {
      'latitude': -8.1118,
      'longitude': -79.0290,
    },
    locationMapPath: '/storage/maps/location3.png',
  );

  // Create sample supplies with evidences
  final supply1 = SupplyEntity(
    id: 'supply1',
    code: '12345678',
    evidences: [evidence1, evidence2, evidence3],
    createdAt: DateTime.now(),
  );

  final supply2 = SupplyEntity(
    id: 'supply2',
    code: '87654321',
    evidences: [evidence1], // Single evidence for second supply
    createdAt: DateTime.now(),
  );

  // Create sample report
  final report = ReportEntity(
    id: 'report_001',
    supervisorName: 'Carlos Rodriguez Pérez',
    date: DateTime.now(),
    subject: 'Supervisión de actividades realizadas en sector Norte',
    activities: [
      true,  // Actividades de Control de Pérdidas
      true,  // Actividades de Barreras Técnicas
      false, // Actividades de Mantenimiento Preventivo
      true,  // Actividades de Mantenimiento Correctivo
    ],
    supplies: [supply1, supply2],
    conclusions: [
      'Se encontraron múltiples conexiones irregulares que representan pérdidas técnicas',
      'Los cables expuestos constituyen un riesgo de seguridad para los usuarios',
      'Las instalaciones no cumplen con las normativas técnicas vigentes',
    ],
    recommendations: [
      'Realizar inspecciones más frecuentes en la zona',
      'Implementar programa de normalización de conexiones',
    ],
  );

  // Generate PDF
  final pdfService = PdfService();
  
  try {
    final pdfPath = await pdfService.generatePdfReport(report);
    print('PDF generado exitosamente en: $pdfPath');
    
    // Expected filename format: informe_gpc_20240807.pdf (example for today's date)
    // PDF will contain all sections as specified in the requirements:
    // - Header with date
    // - To/From/Subject information
    // - Objective section
    // - Activities performed
    // - Results with photographic evidence
    // - Conclusions
    // - Recommendations
    // - Signature section
    
  } catch (e) {
    print('Error al generar PDF: $e');
  }
}