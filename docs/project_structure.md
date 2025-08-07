# Estructura del Proyecto

Este documento describe la organización de carpetas y archivos propuesta para la aplicación de Supervisión de Obras, siguiendo las mejores prácticas para proyectos Flutter con patrón BLoC.

## Organización de Carpetas

```
lib/
├── blocs/                  # Componentes BLoC para gestión de estado
│   ├── report/             # BLoCs relacionados con reportes
│   ├── supply/             # BLoCs relacionados con suministros
│   └── pdf/                # BLoCs relacionados con generación de PDF
│
├── data/                   # Capa de datos
│   ├── models/             # Modelos de datos
│   ├── repositories/       # Repositorios para acceso a datos
│   └── datasources/        # Fuentes de datos (local, remoto)
│
├── presentation/           # Capa de presentación
│   ├── screens/            # Pantallas principales
│   ├── widgets/            # Widgets reutilizables
│   └── themes/             # Temas y estilos
│
├── core/                   # Funcionalidades centrales
│   ├── utils/              # Utilidades y helpers
│   ├── constants/          # Constantes de la aplicación
│   └── services/           # Servicios (PDF, cámara, voz a texto)
│
└── main.dart               # Punto de entrada de la aplicación
```

## Archivos Clave y sus Propósitos

### Punto de Entrada

- **main.dart**: Inicializa la aplicación, configura temas, rutas y providers.

### Capa de Datos

- **data/models/report.dart**: Modelo para representar un reporte completo.
- **data/models/supply.dart**: Modelo para representar un suministro con sus evidencias.
- **data/models/evidence.dart**: Modelo para representar una evidencia (foto + observación).
- **data/repositories/report_repository.dart**: Interfaz para operaciones con reportes.
- **data/repositories/supply_repository.dart**: Interfaz para operaciones con suministros.
- **data/datasources/local_storage.dart**: Implementación de almacenamiento local.

### Capa de BLoC

- **blocs/report/report_bloc.dart**: Gestiona el estado del reporte actual.
- **blocs/report/report_event.dart**: Define eventos para el ReportBloc.
- **blocs/report/report_state.dart**: Define estados para el ReportBloc.
- **blocs/supply/supply_bloc.dart**: Gestiona el estado de suministros y evidencias.
- **blocs/pdf/pdf_bloc.dart**: Gestiona la generación y compartición de PDFs.

### Capa de Presentación

- **presentation/screens/home_screen.dart**: Pantalla principal de la aplicación.
- **presentation/screens/report_form_screen.dart**: Formulario para crear un nuevo reporte.
- **presentation/screens/supply_form_screen.dart**: Formulario para agregar un suministro.
- **presentation/screens/evidence_screen.dart**: Pantalla para capturar evidencias (foto seguida obligatoriamente por grabación de voz).
- **presentation/screens/evidence_detail_screen.dart**: Pantalla para mostrar la imagen completa y su descripción transcrita.
- **presentation/screens/pdf_preview_screen.dart**: Previsualización del PDF generado.
- **presentation/widgets/camera_widget.dart**: Widget para captura de fotos.
- **presentation/widgets/voice_recorder_widget.dart**: Widget para grabación de voz.
- **presentation/widgets/evidence_gallery_widget.dart**: Widget para mostrar evidencias en formato galería.
- **presentation/themes/app_theme.dart**: Definición del tema de la aplicación.

### Servicios Centrales

- **core/services/pdf_service.dart**: Servicio para generación de PDFs.
- **core/services/speech_service.dart**: Servicio para transcripción de voz a texto.
- **core/services/camera_service.dart**: Servicio para manejo de la cámara.
- **core/services/share_service.dart**: Servicio para compartir archivos.
- **core/utils/validators.dart**: Funciones de validación para formularios.
- **core/constants/app_constants.dart**: Constantes de la aplicación.

## Modelos de Datos

### Modelo de Reporte

```dart
class Report {
  final String id;
  final String supervisorName;
  final DateTime date;
  final String subject;
  final List<bool> activities; // [controlPerdidas, barrerasTecnicas, mantPreventivo, mantCorrectivo]
  final List<Supply> supplies;
  final List<String> conclusions;
  final List<String> recommendations;
  
  // Constructor, métodos toJson/fromJson, etc.
}
```

### Modelo de Suministro

```dart
class Supply {
  final String id;
  final String code; // 8 dígitos
  final List<Evidence> evidences;
  
  // Constructor, métodos toJson/fromJson, etc.
}
```

### Modelo de Evidencia

```dart
class Evidence {
  final String id;
  final String imagePath;
  final String voiceRecordingPath; // Grabación de voz obligatoria
  final String observation; // Transcripción del audio
  final DateTime createdAt;
  final Map<String, double> location; // Ubicación geográfica (latitud, longitud)
  final String locationMapPath; // Ruta a la imagen del mapa generada
  
  // Constructor, métodos toJson/fromJson, etc.
}
```

## Flujo de Datos

1. El usuario crea un nuevo reporte en `report_form_screen.dart`
2. Los datos del reporte se envían al `report_bloc.dart`
3. El usuario agrega suministros y evidencias en `supply_form_screen.dart` y `evidence_screen.dart`
4. Los datos de suministros y evidencias se gestionan a través de `supply_bloc.dart`
5. Al finalizar, el usuario genera un PDF a través de `pdf_bloc.dart`
6. El PDF se genera usando `pdf_service.dart` y se muestra en `pdf_preview_screen.dart`
7. El usuario puede compartir el PDF usando `share_service.dart`

## Almacenamiento Local

Los datos se almacenarán localmente usando Hive:

- **Boxes**:
  - `reports_box`: Almacena todos los reportes
  - `supplies_box`: Almacena todos los suministros
  - `evidences_box`: Almacena todas las evidencias
  - `settings_box`: Almacena configuraciones de la aplicación

Las imágenes se guardarán en el directorio de la aplicación y se referenciarán por ruta en los modelos de datos.