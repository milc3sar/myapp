import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supervisor/blocs/report/report_bloc.dart';
import 'package:supervisor/blocs/report/report_event.dart';
import 'package:supervisor/blocs/report/report_state.dart';
import 'package:supervisor/blocs/pdf/pdf_bloc.dart';
import 'package:supervisor/blocs/pdf/pdf_event.dart';
import 'package:supervisor/blocs/pdf/pdf_state.dart';
import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';
import 'package:uuid/uuid.dart';

/// Screen that displays the details of a report
/// Allows selecting activities, viewing supplies, and generating PDF
class ReportDetailScreen extends StatefulWidget {
  final String reportId;

  const ReportDetailScreen({
    super.key,
    required this.reportId,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  late List<bool> _activities;
  late ReportEntity _report;
  bool _activitiesChanged = false;

  @override
  void initState() {
    super.initState();
    // Load the report when the screen is first built
    context.read<ReportBloc>().add(LoadReport(widget.reportId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Reporte'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implement menu options
            },
          ),
        ],
      ),
      body: BlocConsumer<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is ReportOperationSuccess) {
            // Don't show snackbar for activity updates (when message contains "updated successfully")
            if (!state.message.contains("updated successfully")) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar() // Hide any current SnackBar
                ..showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
            }
          } else if (state is ReportOperationFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar() // Hide any current SnackBar
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReportLoaded) {
            _report = state.report;
            // Initialize activities if not already initialized
            if (!_activitiesChanged) {
              _activities = List.from(_report.activities);
            }
            return _buildReportDetails(context, _report);
          } else {
            // Show loading indicator instead of error message during transitions
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 160, // Fixed width for both buttons
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showAddSupplyDialog(context);
                      },
                      icon: const Icon(Icons.add_box),
                      label: const Text('Suministro'),
                    ),
                  ),
                  SizedBox(
                    width: 160, // Fixed width for both buttons
                    child: BlocConsumer<PdfBloc, PdfState>(
                      listener: (context, state) {
                        if (state is PdfGenerated) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('PDF generado exitosamente: ${state.pdfPath}'),
                              backgroundColor: Colors.green,
                              action: SnackBarAction(
                                label: 'Compartir',
                                onPressed: () {
                                  context.read<PdfBloc>().add(SharePdf(
                                    pdfPath: state.pdfPath,
                                    shareMethod: 'general',
                                  ));
                                },
                              ),
                            ),
                          );
                        } else if (state is PdfOperationFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al generar PDF: ${state.message}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (state is PdfShared) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                      },
                      builder: (context, pdfState) {
                        final isGenerating = pdfState is PdfGenerating;
                        return ElevatedButton.icon(
                          onPressed: isGenerating ? null : () {
                            context.read<PdfBloc>().add(GeneratePdfWithReport(_report));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          icon: isGenerating 
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.picture_as_pdf),
                          label: Text(isGenerating ? 'Generando...' : 'Informar'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildReportDetails(BuildContext context, ReportEntity report) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Report information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información del Reporte',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  _buildInfoRow('Supervisor:', report.supervisorName),
                  _buildInfoRow('Asunto:', report.subject),
                  _buildInfoRow('Fecha:', _formatDate(report.date)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Activities selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Actividades Realizadas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  CheckboxListTile(
                    title: const Text('Control de Pérdidas'),
                    value: _activities[0],
                    onChanged: (value) {
                      setState(() {
                        _activities[0] = value ?? false;
                        _activitiesChanged = true;
                      });
                      _updateActivities();
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Barreras Técnicas'),
                    value: _activities[1],
                    onChanged: (value) {
                      setState(() {
                        _activities[1] = value ?? false;
                        _activitiesChanged = true;
                      });
                      _updateActivities();
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Mantenimiento Preventivo'),
                    value: _activities[2],
                    onChanged: (value) {
                      setState(() {
                        _activities[2] = value ?? false;
                        _activitiesChanged = true;
                      });
                      _updateActivities();
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Mantenimiento Correctivo'),
                    value: _activities[3],
                    onChanged: (value) {
                      setState(() {
                        _activities[3] = value ?? false;
                        _activitiesChanged = true;
                      });
                      _updateActivities();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Supplies list
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suministros',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  if (report.supplies.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text('No hay suministros registrados'),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: report.supplies.length,
                      itemBuilder: (context, index) {
                        final supply = report.supplies[index];
                        return _buildSupplyItem(supply);
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplyItem(SupplyEntity supply) {
    return ListTile(
      title: Text('Código: ${supply.code}'),
      subtitle: Text('Evidencias: ${supply.evidences.length}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigate to evidence screen for this supply
        context.goNamed(
          'evidence_screen',
          pathParameters: {
            'reportId': widget.reportId,
            'supplyId': supply.id,
          },
        );
      },
    );
  }

  void _updateActivities() {
    final updatedReport = ReportEntity(
      id: _report.id,
      supervisorName: _report.supervisorName,
      date: _report.date,
      subject: _report.subject,
      activities: _activities,
      supplies: _report.supplies,
      conclusions: _report.conclusions,
      recommendations: _report.recommendations,
      pdfPath: _report.pdfPath,
    );
    
    context.read<ReportBloc>().add(UpdateReport(updatedReport));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showAddSupplyDialog(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Agregar Suministro'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Código de Suministro',
                hintText: 'Ingrese un código de 8 dígitos',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un código';
                }
                if (value.length != 8) {
                  return 'El código debe tener 8 dígitos';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Create a new supply entity with current timestamp
                  final supply = SupplyEntity(
                    id: const Uuid().v4(),
                    code: codeController.text,
                    evidences: const [],
                    createdAt: DateTime.now(),
                  );
                  
                  // Add the supply to the report
                  context.read<ReportBloc>().add(
                    AddSupplyToReport(_report.id, supply),
                  );
                  
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }
}