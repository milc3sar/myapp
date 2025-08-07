import 'package:flutter/material.dart';

/// Home screen of the application
/// Shows a list of recent reports and allows creating a new one
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: _buildReportsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to report form screen
        },
        tooltip: 'Nuevo Reporte',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReportsList() {
    // This is a placeholder for the actual implementation
    // In the future, this will be connected to a BLoC to fetch reports
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
}