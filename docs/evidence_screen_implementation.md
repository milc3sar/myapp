# Implementación de la Pantalla de Evidencias

## Descripción

Este documento describe la implementación de la pantalla de Evidencias para la aplicación de Supervisión de Obras. Esta pantalla permite visualizar las evidencias asociadas a un suministro específico y proporciona un botón para tomar nuevas fotos.

## Archivos Modificados

1. `lib/presentation/screens/evidence_screen.dart` (nuevo)
   - Implementación de la pantalla de Evidencias
   - Muestra el código del suministro
   - Muestra un botón para tomar fotos
   - Muestra una galería de evidencias existentes

2. `lib/router.dart`
   - Añadida nueva ruta para la pantalla de Evidencias
   - Ruta: `/report/:reportId/supply/:supplyId/evidences`
   - Nombre: `evidence_screen`

3. `lib/presentation/screens/report_detail_screen.dart`
   - Modificado el método `_buildSupplyItem` para navegar a la pantalla de Evidencias al hacer clic en un suministro

## Funcionalidades Implementadas

### Pantalla de Evidencias

- **Visualización del código de suministro**: Muestra el código de 8 dígitos del suministro seleccionado.
- **Botón "TOMAR FOTO"**: Botón que permitirá tomar fotos (funcionalidad a implementar en el futuro).
- **Galería de evidencias**: Muestra las evidencias existentes en formato de cuadrícula.
- **Mensaje cuando no hay evidencias**: Muestra un mensaje cuando no hay evidencias registradas.
- **Indicador de carga**: Muestra un indicador de carga mientras se cargan los datos.
- **Manejo de errores**: Muestra un mensaje de error y un botón para reintentar si ocurre un error.

### Navegación

- Al hacer clic en un suministro en la pantalla de Detalles del Reporte, se navega a la pantalla de Evidencias.
- La navegación utiliza el sistema de rutas de go_router.
- Se pasan los parámetros necesarios (reportId y supplyId) para cargar los datos correctos.

## Pendiente para Futuras Implementaciones

- **Funcionalidad de tomar fotos**: Implementar la captura de fotos y su almacenamiento.
- **Grabación de audio**: Implementar la grabación de audio después de tomar una foto.
- **Transcripción de audio**: Implementar la transcripción automática del audio a texto.
- **Visualización detallada de evidencias**: Implementar la vista expandida de una evidencia al hacer clic en ella.

## Capturas de Pantalla (Mockup)

```
┌─────────────────────────────────┐
│ Evidencias - Suministro   ⋮     │
├─────────────────────────────────┤
│                                 │
│  Código de Suministro:          │
│  ┌───────────────────────────┐  │
│  │ 12345678                  │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────┐      │
│  │ TOMAR FOTO            │      │
│  └───────────────────────┘      │
│                                 │
│  Evidencias (3):                │
│  ┌─────────┐  ┌─────────┐       │
│  │         │  │         │       │
│  │ Imagen 1│  │ Imagen 2│       │
│  │         │  │         │       │
│  └─────────┘  └─────────┘       │
│                                 │
│  ┌─────────┐                    │
│  │         │                    │
│  │ Imagen 3│                    │
│  │         │                    │
│  └─────────┘                    │
│                                 │
└─────────────────────────────────┘
```

## Conclusión

La implementación de la pantalla de Evidencias cumple con los requisitos especificados en el diseño UI/UX. La pantalla está lista para ser integrada con la funcionalidad de tomar fotos en futuras iteraciones.