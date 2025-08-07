import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:supervisor/domain/entities/evidence_entity.dart';

/// Service for generating PDF reports
class PdfService {
  /// Activity labels for the report
  static const List<String> activityLabels = [
    'Inspección de medidores',
    'Verificación de conexiones',
    'Control de pérdidas técnicas',
    'Elaboración de informe técnico',
  ];

  /// Generate a PDF report from ReportEntity
  Future<String> generatePdfReport(ReportEntity report, String outputPath) async {
    final pdf = pw.Document();

    // Create the PDF document
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildReportTitle(report),
          pw.SizedBox(height: 20),
          _buildReportInfo(report),
          pw.SizedBox(height: 20),
          _buildActivitiesSection(report),
          pw.SizedBox(height: 20),
          _buildSuppliesSection(report),
          pw.SizedBox(height: 20),
          _buildConclusionsSection(report),
          pw.SizedBox(height: 20),
          _buildRecommendationsSection(report),
          pw.SizedBox(height: 30),
          _buildSignatureSection(),
        ],
      ),
    );

    // Save the PDF file
    final file = File(outputPath);
    await file.writeAsBytes(await pdf.save());
    
    return outputPath;
  }

  /// Build the header section
  pw.Widget _buildHeader() {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.only(bottom: 20),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(width: 2, color: PdfColors.black),
        ),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'GESTIÓN DE PÉRDIDAS Y CONEXIONES (GPC)',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'INFORME DE SUPERVISIÓN TÉCNICA',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the footer section
  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Text(
        'Página ${context.pageNumber} de ${context.pagesCount}',
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

  /// Build the report title
  pw.Widget _buildReportTitle(ReportEntity report) {
    return pw.Center(
      child: pw.Text(
        'INFORME DE SUPERVISIÓN - ${report.subject.toUpperCase()}',
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  /// Build the basic report information section
  pw.Widget _buildReportInfo(ReportEntity report) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '1. INFORMACIÓN GENERAL',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  'Supervisor: ${report.supervisorName}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  'Fecha: ${_formatDate(report.date)}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Asunto: ${report.subject}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  /// Build the activities section
  pw.Widget _buildActivitiesSection(ReportEntity report) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '2. ACTIVIDADES REALIZADAS',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ...List.generate(
            activityLabels.length.clamp(0, report.activities.length),
            (index) => report.activities[index]
                ? pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 3),
                    child: pw.Row(
                      children: [
                        pw.Text(
                          '• ',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            activityLabels[index],
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  )
                : pw.Container(),
          ),
        ],
      ),
    );
  }

  /// Build the supplies and evidences section
  pw.Widget _buildSuppliesSection(ReportEntity report) {
    if (report.supplies.isEmpty) {
      return pw.Container();
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '3. SUMINISTROS Y EVIDENCIAS',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ...report.supplies.map((supply) => _buildSupplySection(supply)),
        ],
      ),
    );
  }

  /// Build individual supply section
  pw.Widget _buildSupplySection(SupplyEntity supply) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Suministro: ${supply.code}',
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 5),
        if (supply.evidences.isNotEmpty) ...[
          pw.Text(
            'Evidencias:',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          ...supply.evidences.map((evidence) => _buildEvidenceSection(evidence)),
        ],
        pw.SizedBox(height: 10),
      ],
    );
  }

  /// Build individual evidence section
  pw.Widget _buildEvidenceSection(EvidenceEntity evidence) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(left: 10, bottom: 10),
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Fecha: ${_formatDateTime(evidence.createdAt)}',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 3),
          if (evidence.observation.isNotEmpty) ...[
            pw.Text(
              'Observación: ${evidence.observation}',
              style: const pw.TextStyle(fontSize: 9),
            ),
            pw.SizedBox(height: 3),
          ],
          if (evidence.location.isNotEmpty) ...[
            pw.Text(
              'Ubicación: Lat: ${evidence.location['latitude']?.toStringAsFixed(6) ?? 'N/A'}, '
              'Lon: ${evidence.location['longitude']?.toStringAsFixed(6) ?? 'N/A'}',
              style: const pw.TextStyle(fontSize: 9),
            ),
            pw.SizedBox(height: 3),
          ],
          pw.Text(
            'Imagen: ${evidence.imagePath.split('/').last}',
            style: const pw.TextStyle(fontSize: 9),
          ),
          if (evidence.voiceRecordingPath.isNotEmpty) ...[
            pw.SizedBox(height: 3),
            pw.Text(
              'Audio: ${evidence.voiceRecordingPath.split('/').last}',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ],
      ),
    );
  }

  /// Build the conclusions section
  pw.Widget _buildConclusionsSection(ReportEntity report) {
    if (report.conclusions.isEmpty) {
      return pw.Container();
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '4. CONCLUSIONES',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ...report.conclusions.asMap().entries.map(
                (entry) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 5),
                  child: pw.Text(
                    '${entry.key + 1}. ${entry.value}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  /// Build the recommendations section
  pw.Widget _buildRecommendationsSection(ReportEntity report) {
    if (report.recommendations.isEmpty) {
      return pw.Container();
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '5. RECOMENDACIONES',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ...report.recommendations.asMap().entries.map(
                (entry) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 5),
                  child: pw.Text(
                    '${entry.key + 1}. ${entry.value}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  /// Build the signature section
  pw.Widget _buildSignatureSection() {
    return pw.Container(
      child: pw.Column(
        children: [
          pw.SizedBox(height: 50),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              pw.Container(
                width: 200,
                child: pw.Column(
                  children: [
                    pw.Container(
                      height: 1,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Firma del Supervisor',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Format date as DD/MM/YYYY
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  /// Format date and time as DD/MM/YYYY HH:mm
  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  /// Generate output path for PDF
  String generatePdfPath(String reportId) {
    final directory = Directory('/storage/emulated/0/Download');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return '/storage/emulated/0/Download/informe_supervision_$reportId.pdf';
  }
}