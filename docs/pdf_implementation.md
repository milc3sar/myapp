# PDF Generation Implementation

## Overview

This implementation provides Phase 3 functionality for the Supervisor app: PDF generation with all collected data according to the GPC (Gestión de Pérdidas y Conexiones) format.

## Files Created/Modified

### New Files:
- `lib/services/pdf_service.dart` - Core PDF generation service
- `test/pdf_service_test.dart` - Unit tests for PDF service
- `example/pdf_generation_example.dart` - Usage example

### Modified Files:
- `lib/blocs/pdf/pdf_bloc.dart` - Updated to use the new PDF service instead of placeholder implementation
- `test/bloc_test.dart` - Updated to include PDF service dependency

## Features Implemented

### 1. PDF Service (`PdfService`)
- Generates PDFs according to the specified GPC format
- Filename format: `informe_gpc_yyyymmdd.pdf`
- Includes all required sections:
  - Header with date
  - To/From/Subject information
  - Objective section
  - Activities performed (from boolean array)
  - Results with photographic evidence
  - Conclusions
  - Recommendations (includes default recommendations)
  - Signature section

### 2. Updated PDF BLoC
- Removed placeholder implementation
- Integrated with `PdfService`
- Proper error handling
- Share functionality using `share_plus` package

### 3. PDF Format Structure

The generated PDF follows this exact structure:

```
INFORME GPC [FECHA]

Para:
Jefe de Gestión de Pérdidas y Conexiones (e)

De:
[Nombre del supervisor] – Técnico Electricista

Asunto:
Supervisión de actividades realizadas el [FECHA]

1. OBJETIVO:
Informar las actividades desarrolladas el día [FECHA].

2. ACCIONES REALIZADAS:
Se han supervisado las siguientes actividades:
1 Actividades de Control de Pérdidas
2 Actividades de Barreras Técnicas
3 Actividades de Mantenimiento Preventivo
4 Actividades de Mantenimiento Correctivo

3. RESULTADOS: TOMAS FOTOGRÁFICAS
3.1 Suministro: [Código de 8 dígitos]
Foto 1
[Placeholder for photo]
Mapa de ubicación 1
[Location coordinates]
...

4. CONCLUSIONES:
Se ha logrado evidenciar los siguientes incumplimientos:
4.1 [Conclusión 1]
...

5. RECOMENDACIONES:
5.1 [Recomendación personalizada]
5.2 La contratista debe ejecutar los correctivos y el levantamiento de las observaciones encontradas.
5.3 Actuar según contrato.

Firma:
[Nombre del supervisor]

Dpto. de Gestión de Pérdidas y Conexiones

Trujillo, [FECHA]
```

## Usage

### Basic Usage
```dart
final pdfService = PdfService();
final pdfPath = await pdfService.generatePdfReport(report);
```

### With BLoC
```dart
// Generate PDF for existing report
context.read<PdfBloc>().add(GeneratePdf(reportId));

// Generate PDF with report entity
context.read<PdfBloc>().add(GeneratePdfWithReport(report));

// Share generated PDF
context.read<PdfBloc>().add(SharePdf(
  pdfPath: pdfPath,
  shareMethod: 'whatsapp',
));
```

## Data Structure Requirements

The PDF service expects:
- `ReportEntity` with supervisor name, date, activities, supplies, conclusions, recommendations
- `SupplyEntity` with 8-digit code and evidences list
- `EvidenceEntity` with image path, observation text, and location coordinates

## File Output

PDFs are saved to `/storage/emulated/0/Download/` with the filename format `informe_gpc_yyyymmdd.pdf`.

## Features

### Date Formatting
- Display format: "15 de enero de 2024" (Spanish)
- Filename format: "20240115" (YYYYMMDD)

### Activity Mapping
The boolean array in `ReportEntity.activities` maps to:
1. Actividades de Control de Pérdidas
2. Actividades de Barreras Técnicas
3. Actividades de Mantenimiento Preventivo
4. Actividades de Mantenimiento Correctivo

### Evidence Handling
- Up to 3 photos per supply (as per format specification)
- Each photo includes location coordinates
- Observations are included in the PDF

### Default Recommendations
The service automatically includes these standard recommendations:
- "La contratista debe ejecutar los correctivos y el levantamiento de las observaciones encontradas."
- "Actuar según contrato."

## Testing

Run tests with:
```bash
flutter test test/pdf_service_test.dart
flutter test test/bloc_test.dart
```

## Dependencies

The implementation uses:
- `pdf: ^3.11.3` - For PDF generation
- `share_plus: ^11.0.0` - For sharing PDFs
- Existing entities and repositories from the domain layer

## Error Handling

The service includes proper error handling for:
- File system operations
- Invalid data
- Missing directories
- PDF generation failures

All errors are propagated through the BLoC state management system.