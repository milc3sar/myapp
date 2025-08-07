# Plan de Desarrollo - App de Supervisión de Obras

## Resumen del Proyecto

La aplicación de Supervisión de Obras es una herramienta móvil desarrollada en Flutter para Android, diseñada específicamente para supervisores técnicos de obras eléctricas. Su propósito principal es facilitar la generación estructurada y automática de informes en formato PDF, siguiendo el formato oficial del área de Gestión de Pérdidas y Conexiones (GPC).

### Características Principales:
- Creación de reportes diarios
- Registro de evidencias por suministro (fotos y observaciones)
- Transcripción de voz a texto para observaciones
- Conclusiones y recomendaciones
- Generación de PDF con formato oficial
- Compartir informes por diferentes medios

### Restricciones Técnicas:
- Funcionamiento principalmente offline
- Sin uso de Firebase o servicios en la nube pagos
- Exclusivo para dispositivos Android

## Arquitectura

La aplicación seguirá el patrón de arquitectura BLoC (Business Logic Component), que separa la lógica de negocio de la interfaz de usuario, facilitando el testing y manteniendo un código limpio y organizado.

### Estructura de Capas:
1. **Presentación**: Widgets de Flutter, pantallas y componentes UI
2. **BLoC**: Manejo de estados y lógica de negocio
3. **Repositorio**: Abstracción para acceso a datos
4. **Fuentes de Datos**: Implementaciones concretas para almacenamiento local y servicios externos

### Diagrama Simplificado:
```
UI (Widgets) ↔ BLoC ↔ Repositorios ↔ Fuentes de Datos (Local/Remoto)
```

## Desglose de Funcionalidades

### 1. Creación de Reporte Diario
- **Pantalla de inicio de reporte**
  - Formulario para datos básicos (nombre del supervisor, fecha y hora, asunto)
  - Selección de acciones realizadas mediante checkboxes
  - Almacenamiento local de datos del reporte

### 2. Registro de Evidencias por Suministro
- **Pantalla de registro de suministro**
  - Ingreso de código de suministro (validación de 8 dígitos)
  - Captura de fotos desde la cámara
  - Captura automática de la ubicación geográfica donde se tomó la foto
  - Grabación de audio obligatoria después de cada foto para descripción verbal
  - Transcripción automática de la descripción verbal a texto
  - Visualización de evidencias en formato galería
  - Al hacer clic en una evidencia, se expande para mostrar la imagen completa, el mapa de ubicación y su descripción transcrita
  - Almacenamiento local de evidencias

### 3. Conclusiones y Recomendaciones
- **Pantalla de conclusiones**
  - Ingreso de conclusiones generales
  - Selección de recomendaciones predefinidas
  - Opción para agregar recomendaciones personalizadas

### 4. Generación de PDF
- **Servicio de generación de PDF**
  - Creación de documento siguiendo el formato oficial
  - Inclusión de encabezado, secciones numeradas, evidencias (fotos, mapas de ubicación y descripciones) y firma
  - Almacenamiento local del PDF generado

### 5. Envío del Informe
- **Opciones de compartir**
  - Integración con APIs nativas para compartir por WhatsApp, correo y Bluetooth
  - Previsualización del PDF antes de compartir

## Cronograma de Implementación

El desarrollo se dividirá en las siguientes fases:

### Fase 1: Configuración y Estructura Base (Semana 1)
- Configuración del proyecto Flutter
- Implementación de la arquitectura BLoC
- Diseño de modelos de datos
- Configuración de almacenamiento local

### Fase 2: Desarrollo de Funcionalidades Principales (Semanas 2-4)
- Implementación de creación de reportes
- Desarrollo del sistema de registro de evidencias
- Integración de la cámara
- Implementación de la transcripción de voz a texto

### Fase 3: Generación de PDF y Finalización (Semanas 5-6)
- Desarrollo del generador de PDF
- Implementación de opciones para compartir
- Pulido de la interfaz de usuario
- Optimización de rendimiento

### Fase 4: Pruebas y Correcciones (Semanas 7-8)
- Pruebas de integración
- Pruebas de usuario
- Corrección de errores
- Optimizaciones finales

## Estrategia de Pruebas

### Pruebas Unitarias
- Pruebas de lógica de negocio en BLoCs
- Pruebas de repositorios y servicios
- Pruebas de modelos de datos

### Pruebas de Integración
- Pruebas de flujo completo de creación de reportes
- Pruebas de generación de PDF
- Pruebas de almacenamiento y recuperación de datos

### Pruebas de Usuario
- Validación de la interfaz de usuario
- Pruebas de usabilidad con supervisores técnicos
- Verificación de que el formato del PDF cumple con los requisitos oficiales

### Pruebas de Rendimiento
- Evaluación del uso de memoria
- Pruebas de rendimiento en dispositivos de gama baja
- Optimización de operaciones pesadas como la generación de PDF