# Diseño UI/UX - App de Supervisión de Obras

Este documento describe el diseño de la interfaz de usuario y la experiencia de usuario para la aplicación de Supervisión de Obras.

## Flujo de Usuario

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │
│  Solicitud de   │     │  Pantalla de    │     │  Formulario de  │
│  Permisos       │────▶│  Inicio         │────▶│  Reporte        │
│  (Primera vez)  │     │                 │     │                 │
└─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                         │
                                                         ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │
│  Lista de       │     │  Registro de    │     │  Previsualizar  │
│  Suministros    │────▶│  Evidencias     │────▶│  PDF            │
│                 │     │                 │     │                 │
└────────┬────────┘     └─────────────────┘     └────────┬────────┘
         │                                               │
         ▼                                               ▼
┌─────────────────┐                             ┌─────────────────┐
│                 │                             │                 │
│  Compartir      │                             │  Compartir      │
│  PDF            │                             │  PDF            │
│                 │                             │                 │
└─────────────────┘                             └─────────────────┘
```

## Descripción de Pantallas

### 1. Diálogo de Solicitud de Permisos

**Descripción**: Diálogo que se muestra la primera vez que se inicia la aplicación para solicitar los permisos necesarios.

**Elementos UI**:
- Título informativo
- Texto explicativo de los permisos requeridos
- Lista de permisos con su justificación:
  - Cámara: para tomar fotos de evidencias
  - Micrófono: para grabar notas de voz
  - Ubicación: para registrar la ubicación de las evidencias
  - Almacenamiento: para guardar fotos y documentos
- Botones de "Cancelar" y "Continuar"

**Interacciones**:
- Al pulsar "Continuar", se solicitan los permisos del sistema
- Al pulsar "Cancelar", se cierra el diálogo pero la aplicación continúa funcionando con funcionalidad limitada
- Los permisos solo se solicitan la primera vez que se inicia la aplicación

### 2. Pantalla de Inicio

**Descripción**: Pantalla principal que muestra los reportes recientes y permite crear uno nuevo.

**Elementos UI**:
- Lista de reportes recientes (con fecha, hora y asunto)
- Botón flotante para crear nuevo reporte
- Menú de opciones (configuración, acerca de)

**Interacciones**:
- Pulsar en un reporte para ver detalles o continuar editando
- Pulsar botón flotante para crear nuevo reporte
- Deslizar un reporte para eliminarlo (con confirmación)

### 2. Formulario de Reporte

**Descripción**: Formulario para ingresar los datos básicos del reporte.

**Elementos UI**:
- Campo de texto para nombre del supervisor
- Selector de fecha
- Campo de texto para asunto
- Casillas de verificación para actividades realizadas
- Botón para continuar

**Interacciones**:
- Validación de campos obligatorios
- Guardar automáticamente como borrador
- Continuar al siguiente paso

### 3. Lista de Suministros

**Descripción**: Pantalla que muestra los suministros agregados al reporte y permite añadir nuevos.

**Elementos UI**:
- Lista de suministros agregados (código y número de evidencias)
- Botón para agregar nuevo suministro
- Botón para continuar a conclusiones
- Botón para generar PDF

**Interacciones**:
- Pulsar en un suministro para ver/editar sus evidencias
- Pulsar botón para agregar nuevo suministro
- Deslizar un suministro para eliminarlo

### 4. Registro de Evidencias

**Descripción**: Pantalla para agregar evidencias a un suministro específico.

**Elementos UI**:
- Campo de texto para código de suministro (8 dígitos)
- Botón para tomar foto
- Botón para grabar audio (se activa automáticamente después de tomar una foto)
- Galería de evidencias ya agregadas (formato grid)
- Botón para guardar

**Interacciones**:
- Validación del código de suministro
- Acceso a la cámara para tomar fotos
- Después de tomar una foto, se activa automáticamente la grabación de voz (obligatorio)
- Transcripción automática del audio a texto
- Visualización de evidencias en formato galería
- Al hacer clic en una evidencia, se expande para mostrar la imagen completa y su descripción transcrita

### 5. Conclusiones y Recomendaciones

**Descripción**: Pantalla para agregar conclusiones y recomendaciones al reporte.

**Elementos UI**:
- Campo de texto para agregar conclusiones
- Lista de conclusiones agregadas
- Casillas de verificación para recomendaciones predefinidas
- Campo de texto para recomendaciones personalizadas
- Botón para generar PDF

**Interacciones**:
- Agregar/eliminar conclusiones
- Seleccionar recomendaciones predefinidas
- Agregar recomendaciones personalizadas

### 6. Previsualizar PDF

**Descripción**: Pantalla que muestra una previsualización del PDF generado.

**Elementos UI**:
- Visor de PDF
- Botón para compartir
- Botón para volver a editar
- Botón para guardar localmente

**Interacciones**:
- Zoom en el PDF
- Desplazamiento por las páginas
- Compartir el PDF

### 7. Compartir PDF

**Descripción**: Diálogo para seleccionar el método de compartir el PDF.

**Elementos UI**:
- Opciones para compartir (WhatsApp, correo, Bluetooth)
- Opción para guardar en el dispositivo

**Interacciones**:
- Seleccionar método de compartir
- Integración con apps nativas

## Guías de Diseño

### Paleta de Colores

- **Color Primario**: #1565C0 (Azul)
- **Color Secundario**: #FFA000 (Ámbar)
- **Fondo**: #FFFFFF (Blanco)
- **Texto Principal**: #212121 (Negro)
- **Texto Secundario**: #757575 (Gris)
- **Acento/Éxito**: #4CAF50 (Verde)
- **Error**: #F44336 (Rojo)

### Tipografía

- **Familia de Fuente**: Roboto
- **Tamaños**:
  - Título: 20sp, Bold
  - Subtítulo: 16sp, Medium
  - Cuerpo: 14sp, Regular
  - Botones: 14sp, Medium
  - Etiquetas: 12sp, Regular

### Componentes UI

#### Botones

- **Botón Primario**:
  - Fondo: Color Primario
  - Texto: Blanco
  - Elevación: 2dp
  - Bordes redondeados: 4dp

- **Botón Secundario**:
  - Borde: Color Primario
  - Texto: Color Primario
  - Fondo: Transparente
  - Bordes redondeados: 4dp

- **Botón Flotante**:
  - Fondo: Color Secundario
  - Icono: Blanco
  - Elevación: 6dp

#### Campos de Texto

- Borde inferior: 1dp
- Color de borde: Gris claro
- Color de borde en foco: Color Primario
- Texto de ayuda: Gris
- Mensaje de error: Color Error

#### Tarjetas

- Fondo: Blanco
- Elevación: 1dp
- Bordes redondeados: 4dp
- Padding interno: 16dp

### Iconografía

- Usar iconos de Material Design
- Tamaño estándar: 24dp
- Color: Color Primario o Gris según contexto

## Consideraciones de Accesibilidad

- Contraste adecuado entre texto y fondo
- Tamaño mínimo de elementos táctiles: 48dp x 48dp
- Etiquetas para lectores de pantalla
- Soporte para texto escalable

## Mockups de Pantallas Principales

### Pantalla de Inicio
```
┌─────────────────────────────────┐
│ Supervisión de Obras      ⋮     │
├─────────────────────────────────┤
│                                 │
│  ┌─────────────────────────────────┐  │
│  │ Reporte #123 - 05/08/2025 14:30 │  │
│  │ Supervisión Zona Norte          │  │
│  └─────────────────────────────────┘  │
│                                 │
│  ┌─────────────────────────────────┐  │
│  │ Reporte #122 - 04/08/2025 09:15 │  │
│  │ Mantenimiento Preventivo        │  │
│  └─────────────────────────────────┘  │
│                                 │
│  ┌─────────────────────────────────┐  │
│  │ Reporte #121 - 03/08/2025 16:45 │  │
│  │ Control de Pérdidas             │  │
│  └─────────────────────────────────┘  │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│                  ┌─────┐        │
│                  │  +  │        │
│                  └─────┘        │
└─────────────────────────────────┘
```

### Formulario de Reporte
```
┌─────────────────────────────────┐
│ Nuevo Reporte            ⋮      │
├─────────────────────────────────┤
│                                 │
│  Nombre del Supervisor:         │
│  ┌───────────────────────────┐  │
│  │ Juan Pérez                │  │
│  └───────────────────────────┘  │
│                                 │
│  Asunto:                        │
│  ┌───────────────────────────┐  │
│  │ Supervisión Zona Este     │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │        CONTINUAR          │  │
│  └───────────────────────────┘  │
└─────────────────────────────────┘
```

### Detalles del Reporte
```
┌─────────────────────────────────┐
│ Detalles del Reporte      ⋮     │
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │ Información del Reporte   │  │
│  │ ─────────────────────────│  │
│  │ Supervisor: Juan Pérez    │  │
│  │ Asunto: Supervisión Zona  │  │
│  │ Fecha: 07/08/2025 14:30   │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ Actividades Realizadas    │  │
│  │ ─────────────────────────│  │
│  │ ☑ Control de pérdidas     │  │
│  │ ☑ Barreras técnicas       │  │
│  │ ☐ Mantenimiento preventivo│  │
│  │ ☐ Mantenimiento correctivo│  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ Suministros               │  │
│  │ ─────────────────────────│  │
│  │ Código: 12345678         │  │
│  │ Evidencias: 3            │  │
│  │                          │  │
│  │ Código: 87654321         │  │
│  │ Evidencias: 2            │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌─────────────┐ ┌─────────┐   │
│  │ AGREGAR     │ │ INFORMAR│   │
│  │ SUMINISTRO  │ │ (PDF)   │   │
│  └─────────────┘ └─────────┘   │
└─────────────────────────────────┘
```

### Registro de Evidencias
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
│  ┌───────────────────────────┐  │
│  │         GUARDAR           │  │
│  └───────────────────────────┘  │
└─────────────────────────────────┘
```

### Flujo de Captura de Evidencia
```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │     │                 │
│  Tomar Foto     │────▶│  Capturar       │────▶│  Grabar Voz     │────▶│  Transcripción  │
│  (Cámara)       │     │  Ubicación      │     │  (Obligatorio)  │     │  Automática     │
│                 │     │  (Automático)   │     │                 │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
```

### Vista Expandida de Evidencia
```
┌─────────────────────────────────┐
│ Evidencia                 ✕     │
├─────────────────────────────────┤
│                                 │
│  ┌───────────────────────────┐  │
│  │                           │  │
│  │                           │  │
│  │                           │  │
│  │       [IMAGEN            │  │
│  │        COMPLETA]         │  │
│  │                           │  │
│  │                           │  │
│  │                           │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │                           │  │
│  │                           │  │
│  │       [MAPA DE           │  │
│  │        UBICACIÓN]         │  │
│  │                           │  │
│  │                           │  │
│  └───────────────────────────┘  │
│                                 │
│  Descripción:                   │
│  ───────────────────────────    │
│  Se observa conexión irregular  │
│  en el medidor. Cables          │
│  expuestos y manipulación       │
│  evidente del precinto de       │
│  seguridad.                     │
│  ───────────────────────────    │
│                                 │
└─────────────────────────────────┘
```

## Responsive Design

La aplicación se adaptará a diferentes tamaños de pantalla de dispositivos Android:

- **Teléfonos pequeños** (4-5"): Diseño compacto, elementos apilados verticalmente
- **Teléfonos medianos** (5-6"): Diseño estándar como se muestra en los mockups
- **Teléfonos grandes y tablets** (>6"): Diseño de dos paneles para aprovechar el espacio adicional

## Animaciones y Transiciones

- Transiciones suaves entre pantallas (duración: 300ms)
- Animación de carga al generar PDF
- Efectos de ripple en elementos táctiles
- Animaciones sutiles para feedback de acciones (guardar, eliminar)