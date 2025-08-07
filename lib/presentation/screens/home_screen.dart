import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supervisor/blocs/report/report_bloc.dart';
import 'package:supervisor/blocs/report/report_event.dart';
import 'package:supervisor/blocs/report/report_state.dart';
import 'package:supervisor/domain/entities/report_entity.dart';

/// Home screen of the application
/// Shows a list of recent reports and allows creating a new one
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Load reports when the screen is first built
    context.read<ReportBloc>().add(const LoadReports());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisión'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implement menu options
            },
          ),
        ],
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReportsLoaded) {
            return _buildReportsList(context, state.reports);
          } else if (state is ReportOperationFailure) {
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
                    'Error: ${state.message}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReportBloc>().add(const LoadReports());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else {
            return _buildEmptyState(context);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateReportDialog(context);
        },
        tooltip: 'Nuevo Reporte',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReportsList(BuildContext context, List<ReportEntity> reports) {
    if (reports.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(report.subject),
            subtitle: Text(
              'Supervisor: ${report.supervisorName}\nFecha: ${_formatDate(report.date)}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to report detail screen
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.description_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay reportes',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea un nuevo reporte con el botón +',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateReportDialog(BuildContext context) {
    final supervisorNameController = TextEditingController();
    final subjectController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final activities = [false, false, false, false]; // Control Pérdidas, Barreras Técnicas, Mant. Preventivo, Mant. Correctivo

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Reporte'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: supervisorNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Supervisor',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre del supervisor';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Asunto',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el asunto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Actividades realizadas:'),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        children: [
                          CheckboxListTile(
                            title: const Text('Control de Pérdidas'),
                            value: activities[0],
                            onChanged: (value) {
                              setState(() {
                                activities[0] = value ?? false;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Barreras Técnicas'),
                            value: activities[1],
                            onChanged: (value) {
                              setState(() {
                                activities[1] = value ?? false;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Mantenimiento Preventivo'),
                            value: activities[2],
                            onChanged: (value) {
                              setState(() {
                                activities[2] = value ?? false;
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Mantenimiento Correctivo'),
                            value: activities[3],
                            onChanged: (value) {
                              setState(() {
                                activities[3] = value ?? false;
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Create the report
                  context.read<ReportBloc>().add(
                    CreateReport(
                      supervisorName: supervisorNameController.text,
                      subject: subjectController.text,
                      activities: activities,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}