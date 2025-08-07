import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supervisor/blocs/supply/supply_bloc.dart';
import 'package:supervisor/blocs/supply/supply_event.dart';
import 'package:supervisor/blocs/supply/supply_state.dart';
import 'package:supervisor/domain/entities/evidence_entity.dart';
import 'package:supervisor/domain/entities/supply_entity.dart';

/// Screen that displays the evidences for a specific supply
/// Allows viewing evidences in a gallery format and taking new photos
class EvidenceScreen extends StatefulWidget {
  final String supplyId;

  const EvidenceScreen({
    super.key,
    required this.supplyId,
  });

  @override
  State<EvidenceScreen> createState() => _EvidenceScreenState();
}

class _EvidenceScreenState extends State<EvidenceScreen> {
  late SupplyEntity _supply;

  @override
  void initState() {
    super.initState();
    // Load the supply when the screen is first built
    context.read<SupplyBloc>().add(LoadSupply(widget.supplyId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evidencias - Suministro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implement menu options
            },
          ),
        ],
      ),
      body: BlocConsumer<SupplyBloc, SupplyState>(
        listener: (context, state) {
          if (state is SupplyOperationSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar() // Hide any current SnackBar
              ..showSnackBar(
                SnackBar(content: Text(state.message)),
              );
          } else if (state is SupplyOperationFailure) {
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
          if (state is SupplyLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SupplyLoaded) {
            _supply = state.supply;
            return _buildEvidencesList(context, _supply);
          } else {
            // Show empty state instead of error screen
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.image_not_supported_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No se pudo cargar el suministro',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SupplyBloc>().add(LoadSupply(widget.supplyId));
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // This is a placeholder for the "Take Photo" functionality
          // Not implementing as per requirements
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Funcionalidad de tomar foto no implementada'),
            ),
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildEvidencesList(BuildContext context, SupplyEntity supply) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Supply code
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Código de Suministro:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    supply.code,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Take photo button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // This is a placeholder for the "Take Photo" functionality
                // Not implementing as per requirements
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad de tomar foto no implementada'),
                  ),
                );
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('TOMAR FOTO'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Evidences gallery
          Text(
            'Evidencias (${supply.evidences.length}):',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          
          if (supply.evidences.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'No hay evidencias registradas',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            _buildEvidencesGrid(supply.evidences),
        ],
      ),
    );
  }

  Widget _buildEvidencesGrid(List<EvidenceEntity> evidences) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: evidences.length,
      itemBuilder: (context, index) {
        final evidence = evidences[index];
        return _buildEvidenceItem(evidence);
      },
    );
  }

  Widget _buildEvidenceItem(EvidenceEntity evidence) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // This is a placeholder for viewing the evidence details
          // Not implementing as per requirements
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Visualización de evidencia no implementada'),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 48,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Evidencia ${evidence.id.substring(0, 4)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}