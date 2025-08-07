import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:supervisor/domain/entities/evidence_entity.dart';

/// Service for generating PDF reports following the official GPC format
class PdfService {
  static const List<String> activityLabels = [
    'Revisión técnica de equipos',
    'Verificación de medidores',
    'Inspección de conexiones',
    'Evaluación de infraestructura',
    'Control de calidad',
    'Supervisión de trabajos',
    'Toma de lecturas',
    'Verificación de normativas',
  ];

  /// Generates a PDF report for the given report entity
  /// Returns the file path where the PDF was saved
  Future<String> generateReportPdf(ReportEntity report, String outputDir) async {
    final pdf = pw.Document();

    // Add pages to the PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header section
            _buildHeader(report),
            pw.SizedBox(height: 20),
            
            // Activities section
            _buildActivitiesSection(report.activities),
            pw.SizedBox(height: 20),
            
            // Supplies and evidences section
            _buildSuppliesSection(report.supplies),
            pw.SizedBox(height: 20),
            
            // Conclusions section
            _buildConclusionsSection(report.conclusions),
            pw.SizedBox(height: 20),
            
            // Recommendations section
            _buildRecommendationsSection(report.recommendations),
            pw.SizedBox(height: 30),
            
            // Footer/Signature section
            _buildFooter(report),
          ];
        },
      ),
    );

    // Save the PDF
    final fileName = 'informe_supervision_${report.id}_${_formatDateForFilename(report.date)}.pdf';
    final filePath = '$outputDir/$fileName';
    final file = File(filePath);
    
    // Ensure the directory exists
    await file.parent.create(recursive: true);
    
    // Write the PDF bytes to file
    final bytes = await pdf.save();
    await file.writeAsBytes(bytes);

    return filePath;
  }

  /// Builds the header section of the PDF
  pw.Widget _buildHeader(ReportEntity report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Title
        pw.Center(
          child: pw.Text(
            'INFORME DE SUPERVISIÓN TÉCNICA',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Center(
          child: pw.Text(
            'ÁREA DE GESTIÓN DE PÉRDIDAS Y CONEXIONES (GPC)',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.normal,
            ),
          ),
        ),
        pw.SizedBox(height: 20),
        
        // Report information
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Supervisor: ${report.supervisorName}'),
                  pw.Text('Fecha: ${_formatDate(report.date)}'),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Text('Asunto: ${report.subject}'),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the activities section with checkboxes
  pw.Widget _buildActivitiesSection(List<bool> activities) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '1. ACTIVIDADES REALIZADAS',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        
        // Activities with checkboxes
        pw.Wrap(
          children: List.generate(
            activityLabels.length,
            (index) {
              final isChecked = index < activities.length ? activities[index] : false;
              return pw.Container(
                width: 250,
                margin: const pw.EdgeInsets.only(bottom: 5),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 10,
                      height: 10,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                      ),
                      child: isChecked
                          ? pw.Center(
                              child: pw.Text(
                                '✓',
                                style: pw.TextStyle(fontSize: 8),
                              ),
                            )
                          : null,
                    ),
                    pw.SizedBox(width: 5),
                    pw.Expanded(
                      child: pw.Text(
                        activityLabels[index],
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds the supplies section with evidences
  pw.Widget _buildSuppliesSection(List<SupplyEntity> supplies) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '2. SUMINISTROS REVISADOS Y EVIDENCIAS',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        
        if (supplies.isEmpty)
          pw.Text('No se registraron suministros.')
        else
          ...supplies.map((supply) => _buildSupplySection(supply)).toList(),
      ],
    );
  }

  /// Builds a single supply section with its evidences
  pw.Widget _buildSupplySection(SupplyEntity supply) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Text(
            'Suministro: ${supply.code}',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 5),
        
        if (supply.evidences.isEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 10),
            child: pw.Text('No se registraron evidencias para este suministro.'),
          )
        else
          ...supply.evidences.asMap().entries.map((entry) {
            final index = entry.key;
            final evidence = entry.value;
            return _buildEvidenceSection(evidence, index + 1);
          }).toList(),
        
        pw.SizedBox(height: 15),
      ],
    );
  }

  /// Builds a single evidence section
  pw.Widget _buildEvidenceSection(EvidenceEntity evidence, int evidenceNumber) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 10, bottom: 10),
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Evidencia $evidenceNumber',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          
          // Evidence details
          pw.Text('Fecha y hora: ${_formatDate(evidence.createdAt)}'),
          pw.Text('Ubicación: Lat: ${evidence.location['latitude']?.toStringAsFixed(6)}, '
                  'Lng: ${evidence.location['longitude']?.toStringAsFixed(6)}'),
          
          if (evidence.observation.isNotEmpty) ...[
            pw.SizedBox(height: 5),
            pw.Text('Observación:'),
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10),
              child: pw.Text(
                evidence.observation,
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
          ],
          
          pw.SizedBox(height: 5),
          pw.Text(
            'Imagen: ${_getFileNameFromPath(evidence.imagePath)}',
            style: const pw.TextStyle(fontSize: 9),
          ),
          
          if (evidence.voiceRecordingPath.isNotEmpty)
            pw.Text(
              'Audio: ${_getFileNameFromPath(evidence.voiceRecordingPath)}',
              style: const pw.TextStyle(fontSize: 9),
            ),
        ],
      ),
    );
  }

  /// Builds the conclusions section
  pw.Widget _buildConclusionsSection(List<String> conclusions) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '3. CONCLUSIONES',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        
        if (conclusions.isEmpty)
          pw.Text('No se registraron conclusiones.')
        else
          ...conclusions.asMap().entries.map((entry) {
            final index = entry.key;
            final conclusion = entry.value;
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 5),
              child: pw.Text('${index + 1}. $conclusion'),
            );
          }).toList(),
      ],
    );
  }

  /// Builds the recommendations section
  pw.Widget _buildRecommendationsSection(List<String> recommendations) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '4. RECOMENDACIONES',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        
        if (recommendations.isEmpty)
          pw.Text('No se registraron recomendaciones.')
        else
          ...recommendations.asMap().entries.map((entry) {
            final index = entry.key;
            final recommendation = entry.value;
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 5),
              child: pw.Text('${index + 1}. $recommendation'),
            );
          }).toList(),
      ],
    );
  }

  /// Builds the footer/signature section
  pw.Widget _buildFooter(ReportEntity report) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 40),
        pw.Text(
          '____________________________',
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          report.supervisorName,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          'Supervisor Técnico',
          style: pw.TextStyle(fontSize: 10),
        ),
        pw.Text(
          'Área de Gestión de Pérdidas y Conexiones (GPC)',
          style: pw.TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  /// Formats a date for display
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
           '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Formats a date for filename (safe characters only)
  String _formatDateForFilename(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}_'
           '${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}';
  }

  /// Extracts filename from a full path
  String _getFileNameFromPath(String path) {
    return path.split('/').last;
  }
}