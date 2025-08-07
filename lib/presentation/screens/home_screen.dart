import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supervisor/blocs/report/report_bloc.dart';
import 'package:supervisor/blocs/report/report_event.dart';
import 'package:supervisor/blocs/report/report_state.dart';
import 'package:supervisor/domain/entities/report_entity.dart';

/// Home screen of the application
/// Shows a list of recent reports and allows creating a new one
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load reports when the screen is first built
    context.read<ReportBloc>().add(const LoadReports());
  }

  @override
  Widget build(BuildContext context) {
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
              // Navigate to report detail screen using go_router
              context.pushNamed(
                'report_detail',
                pathParameters: {'reportId': report.id},
              );
              // No need for .then() callback as reports are reloaded by the MyRouteObserver in router.dart
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
    // Activities are now set to false by default and will be selected in the report detail screen
    final activities = [false, false, false, false]; 

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
                  // Activities selection removed as per requirements
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
                  // Create the report with default activities (all false)
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
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}