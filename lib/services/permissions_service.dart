import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service to handle permission requests and checks
class PermissionsService {
  static const String _permissionsRequestedKey = 'permissions_requested';
  final Box _settingsBox;

  PermissionsService({required Box settingsBox}) : _settingsBox = settingsBox;

  /// Factory constructor to create a PermissionsService from the default settings box
  factory PermissionsService.fromDefaultBox() {
    final settingsBox = Hive.box('settings_box');
    return PermissionsService(settingsBox: settingsBox);
  }

  /// Check if permissions have been requested before
  bool get permissionsRequested {
    return _settingsBox.get(_permissionsRequestedKey, defaultValue: false);
  }

  /// Mark permissions as requested
  Future<void> markPermissionsAsRequested() async {
    await _settingsBox.put(_permissionsRequestedKey, true);
  }

  /// Check if all required permissions are granted
  Future<bool> checkAllPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;
    final locationStatus = await Permission.location.status;
    final storageStatus = await Permission.storage.status;

    return cameraStatus.isGranted && 
           microphoneStatus.isGranted && 
           locationStatus.isGranted && 
           storageStatus.isGranted;
  }

  /// Request all required permissions
  Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.location,
      Permission.storage,
    ];

    return await permissions.request();
  }

  /// Show permission explanation dialog
  Future<bool> showPermissionExplanationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permisos necesarios'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                'Para que la aplicación funcione correctamente, necesitamos los siguientes permisos:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('• Cámara: para tomar fotos de evidencias'),
              Text('• Micrófono: para grabar notas de voz'),
              Text('• Ubicación: para registrar la ubicación de las evidencias'),
              Text('• Almacenamiento: para guardar fotos y documentos'),
              SizedBox(height: 10),
              Text(
                'Sin estos permisos, algunas funciones de la aplicación no estarán disponibles.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}