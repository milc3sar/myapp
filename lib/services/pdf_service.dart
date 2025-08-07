import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:supervisor/domain/entities/evidence_entity.dart';

/// Service responsible for generating PDF reports according to the GPC format
class PdfService {
  /// Activity names corresponding to the boolean array in ReportEntity
  static const List<String> activityNames = [
    'Actividades de Control de Pérdidas',
    'Actividades de Barreras Técnicas', 
    'Actividades de Mantenimiento Preventivo',
    'Actividades de Mantenimiento Correctivo',
  ];

  /// Generates a PDF report with the specified format
  /// Returns the path where the PDF was saved
  Future<String> generatePdfReport(ReportEntity report) async {
    final pdf = pw.Document();

    // Format date for display and filename
    final formattedDate = _formatDateForDisplay(report.date);
    final filenameDate = _formatDateForFilename(report.date);
    
    // Create the PDF content
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            _buildHeader(formattedDate),
            pw.SizedBox(height: 20),
            
            // To, From, Subject section
            _buildRecipientInfo(report.supervisorName, formattedDate),
            pw.SizedBox(height: 20),
            
            // Objective section
            _buildObjectiveSection(formattedDate),
            pw.SizedBox(height: 15),
            
            // Activities section
            _buildActivitiesSection(report.activities),
            pw.SizedBox(height: 15),
            
            // Results section with photographic evidence
            _buildResultsSection(report.supplies),
            pw.SizedBox(height: 15),
            
            // Conclusions section
            _buildConclusionsSection(report.conclusions),
            pw.SizedBox(height: 15),
            
            // Recommendations section
            _buildRecommendationsSection(report.recommendations),
            pw.SizedBox(height: 20),
            
            // Signature section
            _buildSignatureSection(report.supervisorName, formattedDate),
          ];
        },
      ),
    );

    // Save the PDF file
    final filename = 'informe_gpc_$filenameDate.pdf';
    final directory = Directory('/storage/emulated/0/Download');
    
    // Create directory if it doesn't exist (for testing purposes)
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    
    return filePath;
  }

  /// Builds the header section of the PDF
  pw.Widget _buildHeader(String formattedDate) {
    return pw.Center(
      child: pw.Text(
        'INFORME GPC $formattedDate',
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds the recipient information section
  pw.Widget _buildRecipientInfo(String supervisorName, String formattedDate) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Para:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text('Jefe de Gestión de Pérdidas y Conexiones (e)'),
        pw.SizedBox(height: 10),
        
        pw.Text(
          'De:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text('$supervisorName – Técnico Electricista'),
        pw.SizedBox(height: 10),
        
        pw.Text(
          'Asunto:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text('Supervisión de actividades realizadas el $formattedDate'),
      ],
    );
  }

  /// Builds the objective section
  pw.Widget _buildObjectiveSection(String formattedDate) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '1. OBJETIVO:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text('Informar las actividades desarrolladas el día $formattedDate.'),
      ],
    );
  }

  /// Builds the activities section
  pw.Widget _buildActivitiesSection(List<bool> activities) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '2. ACCIONES REALIZADAS:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text('Se han supervisado las siguientes actividades:'),
        pw.SizedBox(height: 5),
        
        // List completed activities
        for (int i = 0; i < activities.length && i < activityNames.length; i++)
          if (activities[i])
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10),
              child: pw.Text('${i + 1} ${activityNames[i]}'),
            ),
      ],
    );
  }

  /// Builds the results section with photographic evidence
  pw.Widget _buildResultsSection(List<SupplyEntity> supplies) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '3. RESULTADOS: TOMAS FOTOGRÁFICAS',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        
        // Generate content for each supply
        for (int supplyIndex = 0; supplyIndex < supplies.length; supplyIndex++)
          _buildSupplySection(supplies[supplyIndex], supplyIndex + 1),
      ],
    );
  }

  /// Builds a supply section with its evidences
  pw.Widget _buildSupplySection(SupplyEntity supply, int sectionNumber) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '3.$sectionNumber Suministro: ${supply.code}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        
        // Process evidences (up to 3 photos per supply as per format)
        for (int i = 0; i < supply.evidences.length && i < 3; i++)
          _buildEvidenceSection(supply.evidences[i], i + 1),
        
        // Observations section
        if (supply.evidences.isNotEmpty) ...[
          pw.Text(
            'Observaciones:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          
          for (int i = 0; i < supply.evidences.length && i < 3; i++)
            pw.Text('[${supply.evidences[i].observation}]'),
        ],
        
        pw.SizedBox(height: 15),
      ],
    );
  }

  /// Builds an evidence section (photo + location map placeholder)
  pw.Widget _buildEvidenceSection(EvidenceEntity evidence, int photoNumber) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Foto $photoNumber'),
        pw.Container(
          height: 100,
          width: 150,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
          ),
          child: pw.Center(
            child: pw.Text(
              '[Foto $photoNumber]',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ),
        pw.SizedBox(height: 5),
        
        pw.Text('Mapa de ubicación $photoNumber'),
        pw.Container(
          height: 80,
          width: 150,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
          ),
          child: pw.Center(
            child: pw.Text(
              '[Ubicación: ${evidence.location['latitude']?.toStringAsFixed(6) ?? 'N/A'}, ${evidence.location['longitude']?.toStringAsFixed(6) ?? 'N/A'}]',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center,
            ),
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  /// Builds the conclusions section
  pw.Widget _buildConclusionsSection(List<String> conclusions) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '4. CONCLUSIONES:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text('Se ha logrado evidenciar los siguientes incumplimientos:'),
        pw.SizedBox(height: 5),
        
        for (int i = 0; i < conclusions.length; i++)
          pw.Text('4.${i + 1} ${conclusions[i]}'),
      ],
    );
  }

  /// Builds the recommendations section
  pw.Widget _buildRecommendationsSection(List<String> recommendations) {
    final defaultRecommendations = [
      'La contratista debe ejecutar los correctivos y el levantamiento de las observaciones encontradas.',
      'Actuar según contrato.',
    ];
    
    // Combine custom recommendations with default ones
    final allRecommendations = [...recommendations, ...defaultRecommendations];
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '5. RECOMENDACIONES:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        for (int i = 0; i < allRecommendations.length; i++)
          pw.Text('5.${i + 1} ${allRecommendations[i]}'),
      ],
    );
  }

  /// Builds the signature section
  pw.Widget _buildSignatureSection(String supervisorName, String formattedDate) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Firma:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(supervisorName),
        pw.SizedBox(height: 10),
        
        pw.Text('Dpto. de Gestión de Pérdidas y Conexiones'),
        pw.SizedBox(height: 10),
        
        pw.Text('Trujillo, $formattedDate'),
      ],
    );
  }

  /// Formats date for display (e.g., "15 de enero de 2024")
  String _formatDateForDisplay(DateTime date) {
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  /// Formats date for filename (e.g., "20240115")
  String _formatDateForFilename(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  }
}