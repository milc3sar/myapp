import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:supervisor/domain/entities/evidence_entity.dart';

/// Utility class to create sample data for testing PDF generation
class SampleDataFactory {
  /// Creates a sample report with realistic data
  static ReportEntity createSampleReport() {
    final evidence1 = EvidenceEntity(
      id: 'evidence-001',
      imagePath: '/storage/emulated/0/Pictures/medidor_001.jpg',
      voiceRecordingPath: '/storage/emulated/0/Audio/observacion_001.m4a',
      observation: 'Medidor en buen estado, lectura: 15,234 kWh. '
          'No se observan signos de manipulación o daños externos. '
          'Cableado en condiciones normales.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      location: {
        'latitude': -12.046374,
        'longitude': -77.042793,
      },
    );

    final evidence2 = EvidenceEntity(
      id: 'evidence-002',
      imagePath: '/storage/emulated/0/Pictures/conexion_001.jpg',
      voiceRecordingPath: '/storage/emulated/0/Audio/observacion_002.m4a',
      observation: 'Conexión presenta leve oxidación en los bornes. '
          'Se recomienda limpieza y aplicación de protector anticorrosivo. '
          'Tensión medida: 220V dentro de parámetros normales.',
      createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      location: {
        'latitude': -12.046421,
        'longitude': -77.042850,
      },
    );

    final evidence3 = EvidenceEntity(
      id: 'evidence-003',
      imagePath: '/storage/emulated/0/Pictures/caja_001.jpg',
      voiceRecordingPath: '/storage/emulated/0/Audio/observacion_003.m4a',
      observation: 'Caja de medición en excelente estado. '
          'Sellado íntegro, sin evidencia de apertura no autorizada. '
          'Etiquetas de identificación legibles.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      location: {
        'latitude': -12.046500,
        'longitude': -77.042900,
      },
    );

    final supply1 = SupplyEntity(
      id: 'supply-001',
      code: '12345678',
      evidences: [evidence1, evidence2],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    );

    final supply2 = SupplyEntity(
      id: 'supply-002',
      code: '87654321',
      evidences: [evidence3],
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    );

    return ReportEntity(
      id: 'report-sample-${DateTime.now().millisecondsSinceEpoch}',
      supervisorName: 'Ing. Carlos Eduardo Mendoza Vargas',
      date: DateTime.now(),
      subject: 'Supervisión técnica rutinaria - Sector Residencial Norte',
      activities: [
        true,  // Revisión técnica de equipos
        true,  // Verificación de medidores
        true,  // Inspección de conexiones
        false, // Evaluación de infraestructura
        true,  // Control de calidad
        false, // Supervisión de trabajos
        true,  // Toma de lecturas
        true,  // Verificación de normativas
      ],
      supplies: [supply1, supply2],
      conclusions: [
        'Se realizó la supervisión de 2 suministros en el sector asignado.',
        'El 90% de los equipos se encuentran en condiciones operativas normales.',
        'Se detectó oxidación menor en el suministro 12345678 que requiere atención preventiva.',
        'Todas las lecturas de medidores están dentro de los parámetros esperados.',
        'Los sellos de seguridad se encuentran íntegros en todos los medidores revisados.',
      ],
      recommendations: [
        'Programar mantenimiento preventivo para el suministro 12345678 en un plazo de 30 días.',
        'Aplicar tratamiento anticorrosivo en conexiones con signos de oxidación.',
        'Continuar con las supervisiones rutinarias según cronograma establecido.',
        'Documentar todas las intervenciones realizadas en el sistema de gestión.',
        'Capacitar al personal local sobre identificación temprana de problemas de corrosión.',
      ],
    );
  }

  /// Creates a minimal report for basic testing
  static ReportEntity createMinimalReport() {
    return ReportEntity(
      id: 'report-minimal-${DateTime.now().millisecondsSinceEpoch}',
      supervisorName: 'Juan Pérez',
      date: DateTime.now(),
      subject: 'Supervisión básica',
      activities: [true, false, false, false, false, false, false, false],
      supplies: [],
      conclusions: ['Supervisión completada sin incidencias.'],
      recommendations: ['Mantener protocolo actual.'],
    );
  }

  /// Creates a comprehensive report with multiple supplies for stress testing
  static ReportEntity createComprehensiveReport() {
    final supplies = <SupplyEntity>[];
    
    for (int i = 1; i <= 5; i++) {
      final evidences = <EvidenceEntity>[];
      
      for (int j = 1; j <= 3; j++) {
        evidences.add(EvidenceEntity(
          id: 'evidence-${i.toString().padLeft(2, '0')}-${j.toString().padLeft(2, '0')}',
          imagePath: '/storage/emulated/0/Pictures/evidence_${i}_$j.jpg',
          voiceRecordingPath: '/storage/emulated/0/Audio/audio_${i}_$j.m4a',
          observation: 'Evidencia $j del suministro $i. '
              'Estado: ${j % 2 == 0 ? "Normal" : "Requiere atención"}. '
              'Observaciones técnicas detalladas para registro completo.',
          createdAt: DateTime.now().subtract(Duration(hours: i, minutes: j * 15)),
          location: {
            'latitude': -12.046374 + (i * 0.001),
            'longitude': -77.042793 + (j * 0.001),
          },
        ));
      }
      
      supplies.add(SupplyEntity(
        id: 'supply-${i.toString().padLeft(3, '0')}',
        code: '${12345678 + i}',
        evidences: evidences,
        createdAt: DateTime.now().subtract(Duration(hours: i)),
      ));
    }

    return ReportEntity(
      id: 'report-comprehensive-${DateTime.now().millisecondsSinceEpoch}',
      supervisorName: 'Ing. María Elena Rodriguez Fernández',
      date: DateTime.now(),
      subject: 'Supervisión técnica exhaustiva - Proyecto de mejora infraestructura eléctrica',
      activities: [true, true, true, true, true, false, true, true],
      supplies: supplies,
      conclusions: [
        'Se supervisaron 5 suministros en el área de intervención del proyecto.',
        'El 80% de los equipos evaluados se encuentran en condiciones óptimas.',
        'Se identificaron 2 suministros que requieren mantenimiento preventivo.',
        'La infraestructura general cumple con las normativas técnicas vigentes.',
        'Se documentaron todas las observaciones según protocolos establecidos.',
        'Los trabajos realizados se ejecutaron siguiendo estándares de calidad requeridos.',
      ],
      recommendations: [
        'Implementar programa de mantenimiento predictivo para optimizar recursos.',
        'Establecer cronograma de revisiones trimestrales para equipos críticos.',
        'Actualizar registro fotográfico de todos los equipos supervisados.',
        'Coordinar con área de mantenimiento para atención de observaciones identificadas.',
        'Realizar seguimiento de las recomendaciones implementadas en próxima supervisión.',
        'Capacitar personal técnico en uso de nuevas herramientas de diagnóstico.',
      ],
    );
  }
}