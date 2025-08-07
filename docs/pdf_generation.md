# Funcionalidad de Generación de PDF

## Descripción

Este módulo implementa la funcionalidad de generación de informes PDF para la aplicación de Supervisión de Obras, siguiendo el formato oficial del área de Gestión de Pérdidas y Conexiones (GPC).

## Características Principales

### 1. Generación de PDF Profesional
- **Formato oficial GPC**: Cumple con los estándares requeridos
- **Estructura completa**: Incluye todas las secciones necesarias
- **Diseño profesional**: Layout limpio y organizado

### 2. Contenido del PDF
- **Encabezado**: Nombre del supervisor, fecha, hora y asunto
- **Actividades realizadas**: Lista con checkboxes de actividades completadas
- **Suministros y evidencias**: Detalles de cada suministro con sus evidencias
- **Evidencias detalladas**: Fotos, audios, observaciones y ubicaciones GPS
- **Conclusiones**: Lista numerada de conclusiones del informe
- **Recomendaciones**: Lista numerada de recomendaciones técnicas
- **Firma**: Área de firma del supervisor con información oficial

### 3. Funcionalidades Avanzadas
- **Compartir PDF**: Integración con WhatsApp, email, Bluetooth, etc.
- **Vista previa**: Posibilidad de preview antes de compartir
- **Gestión de archivos**: Almacenamiento automático en directorio apropiado
- **Nombres seguros**: Sanitización automática de nombres de archivo

## Uso del Sistema

### Generar PDF desde un Reporte

```dart
// Opción 1: Usando un ReportEntity existente
final pdfBloc = context.read<PdfBloc>();
pdfBloc.add(GeneratePdfWithReport(reportEntity));

// Opción 2: Usando el ID de un reporte guardado
pdfBloc.add(GeneratePdf(reportId));
```

### Escuchar Estados del PDF

```dart
BlocListener<PdfBloc, PdfState>(
  listener: (context, state) {
    if (state is PdfGenerated) {
      // PDF generado exitosamente
      final pdfPath = state.pdfPath;
      // Mostrar mensaje de éxito o navegar a compartir
    } else if (state is PdfOperationFailure) {
      // Error en la generación
      final error = state.message;
      // Mostrar mensaje de error
    }
  },
  child: YourWidget(),
)
```

### Compartir PDF

```dart
// Compartir PDF generado
pdfBloc.add(SharePdf(
  pdfPath: generatedPdfPath,
  shareMethod: 'general', // o 'whatsapp', 'email', etc.
));
```

## Estructura de Archivos

```
lib/
├── services/
│   ├── pdf_service.dart          # Servicio principal de generación PDF
│   ├── file_utils.dart           # Utilidades para manejo de archivos
│   └── sample_data_factory.dart  # Generador de datos de prueba
├── blocs/pdf/
│   ├── pdf_bloc.dart            # Lógica de negocio PDF
│   ├── pdf_event.dart           # Eventos del BLoC
│   └── pdf_state.dart           # Estados del BLoC
└── presentation/screens/
    └── pdf_demo_screen.dart     # Pantalla de demostración
```

## Servicios Principales

### PdfService
Servicio principal para la generación de PDFs:

```dart
final pdfService = PdfService();
final pdfPath = await pdfService.generateReportPdf(
  reportEntity,
  outputDirectory, // Opcional, usa directorio por defecto si no se especifica
);
```

### FileUtils
Utilidades para manejo de archivos:

```dart
// Obtener directorio por defecto para PDFs
final defaultDir = await FileUtils.getDefaultPdfDirectory();

// Sanitizar nombre de archivo
final safeName = FileUtils.sanitizeFilename('nombre con caracteres/especiales');

// Verificar si archivo es legible
final isReadable = await FileUtils.isFileReadable(filePath);
```

### SampleDataFactory
Generador de datos de prueba:

```dart
// Generar reporte básico
final minimalReport = SampleDataFactory.createMinimalReport();

// Generar reporte completo
final sampleReport = SampleDataFactory.createSampleReport();

// Generar reporte exhaustivo
final comprehensiveReport = SampleDataFactory.createComprehensiveReport();
```

## Pantalla de Demostración

La aplicación incluye `PdfDemoScreen` que permite:
- Generar diferentes tipos de informes PDF
- Probar la funcionalidad de compartir
- Ver estados en tiempo real del proceso
- Acceder a vista previa de PDFs

Para usar la pantalla de demo:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const PdfGenerationDemo()),
);
```

## Testing

### Pruebas Unitarias
- `pdf_service_test.dart`: Pruebas del servicio de PDF
- `pdf_bloc_test.dart`: Pruebas del BLoC de PDF
- `file_utils_test.dart`: Pruebas de utilidades de archivo

### Ejecutar Pruebas
```bash
flutter test test/pdf_service_test.dart
flutter test test/pdf_bloc_test.dart
flutter test test/file_utils_test.dart
```

## Dependencias

Las siguientes dependencias son requeridas:

```yaml
dependencies:
  pdf: ^3.11.3                    # Generación de PDF
  share_plus: ^11.0.0             # Compartir archivos
  path_provider: ^2.1.4           # Acceso a directorios del sistema
  flutter_bloc: ^9.1.1            # Gestión de estado
```

## Consideraciones Técnicas

### Permisos Android
Asegúrese de tener los permisos necesarios en `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### Directorio de Almacenamiento
- **Android**: `/storage/emulated/0/Download` (directorio de descargas)
- **Fallback**: Directorio de documentos de la aplicación

### Formato de Nombre de Archivo
Los archivos PDF se generan con el formato:
```
informe_supervision_[ID_REPORTE]_[FECHA]_[HORA].pdf
```

Ejemplo: `informe_supervision_report_001_20240115_1430.pdf`

## Limitaciones Conocidas

1. **Imágenes en PDF**: Actualmente se referencian los paths de las imágenes pero no se incrustan en el PDF
2. **Mapas de ubicación**: Se incluyen las coordenadas GPS pero no se generan mapas visuales
3. **Tamaño de archivo**: PDFs extensos pueden requerir tiempo de procesamiento

## Mejoras Futuras

- [ ] Incrustación de imágenes reales en el PDF
- [ ] Generación de mapas de ubicación como imágenes
- [ ] Compresión optimizada de PDFs
- [ ] Plantillas personalizables
- [ ] Firma digital
- [ ] Exportación en múltiples formatos