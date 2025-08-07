import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supervisor/blocs/pdf/pdf_bloc.dart';
import 'package:supervisor/blocs/pdf/pdf_event.dart';
import 'package:supervisor/blocs/pdf/pdf_state.dart';
import 'package:supervisor/services/sample_data_factory.dart';

/// Widget that demonstrates PDF generation functionality
/// This is a utility widget for testing and demonstration purposes
class PdfGenerationDemo extends StatelessWidget {
  const PdfGenerationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generación de PDF - Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<PdfBloc, PdfState>(
        listener: (context, state) {
          if (state is PdfGenerated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('PDF generado exitosamente: ${state.pdfPath}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is PdfOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is PdfShared) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.blue,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Generador de PDF de Informes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                
                const Text(
                  'Esta pantalla permite generar PDFs de ejemplo para probar la funcionalidad del sistema de informes.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                
                // Status indicator
                _buildStatusCard(state),
                const SizedBox(height: 30),
                
                // Action buttons
                ElevatedButton.icon(
                  onPressed: state is PdfGenerating ? null : () => _generateMinimalPdf(context),
                  icon: const Icon(Icons.description),
                  label: const Text('Generar Informe Básico'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),
                
                ElevatedButton.icon(
                  onPressed: state is PdfGenerating ? null : () => _generateSamplePdf(context),
                  icon: const Icon(Icons.article),
                  label: const Text('Generar Informe Completo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),
                
                ElevatedButton.icon(
                  onPressed: state is PdfGenerating ? null : () => _generateComprehensivePdf(context),
                  icon: const Icon(Icons.assignment),
                  label: const Text('Generar Informe Exhaustivo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Share button (only visible when PDF is generated)
                if (state is PdfGenerated) ...[
                  OutlinedButton.icon(
                    onPressed: () => _sharePdf(context, state.pdfPath),
                    icon: const Icon(Icons.share),
                    label: const Text('Compartir PDF'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  OutlinedButton.icon(
                    onPressed: () => _previewPdf(context, state.pdfPath),
                    icon: const Icon(Icons.preview),
                    label: const Text('Vista Previa'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(PdfState state) {
    String statusText;
    Color backgroundColor;
    IconData icon;

    if (state is PdfInitial) {
      statusText = 'Listo para generar PDF';
      backgroundColor = Colors.grey.shade100;
      icon = Icons.ready_for_pickup;
    } else if (state is PdfGenerating) {
      statusText = 'Generando PDF...';
      backgroundColor = Colors.orange.shade100;
      icon = Icons.hourglass_empty;
    } else if (state is PdfGenerated) {
      statusText = 'PDF generado exitosamente';
      backgroundColor = Colors.green.shade100;
      icon = Icons.check_circle;
    } else if (state is PdfSharing) {
      statusText = 'Compartiendo PDF...';
      backgroundColor = Colors.blue.shade100;
      icon = Icons.share;
    } else if (state is PdfShared) {
      statusText = 'PDF compartido';
      backgroundColor = Colors.blue.shade100;
      icon = Icons.done;
    } else if (state is PdfOperationFailure) {
      statusText = 'Error en la operación';
      backgroundColor = Colors.red.shade100;
      icon = Icons.error;
    } else {
      statusText = 'Estado desconocido';
      backgroundColor = Colors.grey.shade100;
      icon = Icons.help;
    }

    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (state is PdfGenerated)
                    Text(
                      'Archivo: ${state.pdfPath.split('/').last}',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
            if (state is PdfGenerating)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }

  void _generateMinimalPdf(BuildContext context) {
    final report = SampleDataFactory.createMinimalReport();
    context.read<PdfBloc>().add(GeneratePdfWithReport(report));
  }

  void _generateSamplePdf(BuildContext context) {
    final report = SampleDataFactory.createSampleReport();
    context.read<PdfBloc>().add(GeneratePdfWithReport(report));
  }

  void _generateComprehensivePdf(BuildContext context) {
    final report = SampleDataFactory.createComprehensiveReport();
    context.read<PdfBloc>().add(GeneratePdfWithReport(report));
  }

  void _sharePdf(BuildContext context, String pdfPath) {
    context.read<PdfBloc>().add(SharePdf(
      pdfPath: pdfPath,
      shareMethod: 'general',
    ));
  }

  void _previewPdf(BuildContext context, String pdfPath) {
    context.read<PdfBloc>().add(PreviewPdf(pdfPath));
  }
}