import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supervisor/blocs/report/report_bloc.dart';
import 'package:supervisor/blocs/report/report_event.dart';
import 'package:supervisor/blocs/report/report_state.dart';
import 'package:supervisor/domain/entities/report_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';

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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar el reporte',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReportBloc>().add(LoadReport(widget.reportId));
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
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
                        // This is a placeholder for the "Add Supply" functionality
                        // Not implementing as per requirements
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Funcionalidad de agregar suministro no implementada'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_box),
                      label: const Text('Suministro'),
                    ),
                  ),
                  SizedBox(
                    width: 160, // Fixed width for both buttons
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // This is a placeholder for the "Generate PDF" functionality
                        // Not implementing as per requirements
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Funcionalidad de informar (PDF) no implementada'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Red background for the button
                        foregroundColor: Colors.white, // White text and icon
                      ),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Informar'),
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
        // Navigate to supply detail screen (not implemented)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Navegación a detalles de suministro no implementada'),
          ),
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
}