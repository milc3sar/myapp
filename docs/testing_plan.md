# Plan de Pruebas - App de Supervisión de Obras

Este documento describe la estrategia y el plan de pruebas para la aplicación de Supervisión de Obras, asegurando que cumpla con todos los requisitos funcionales y no funcionales.

## Objetivos de las Pruebas

- Verificar que todas las funcionalidades cumplen con los requisitos especificados
- Asegurar que la aplicación funciona correctamente en modo offline
- Validar la correcta generación de PDFs según el formato oficial
- Comprobar la usabilidad de la interfaz de usuario
- Verificar el rendimiento en diferentes dispositivos Android

## Tipos de Pruebas

### 1. Pruebas Unitarias

**Objetivo**: Verificar el correcto funcionamiento de componentes individuales.

**Herramientas**:
- Flutter test framework
- Mockito para mocks

**Componentes a probar**:
- BLoCs
- Repositorios
- Servicios
- Modelos de datos
- Utilidades y helpers

**Ejemplos de casos de prueba**:
- Validar que el modelo `Report` se serializa/deserializa correctamente
- Verificar que `ReportBloc` cambia de estado correctamente al recibir eventos
- Comprobar que el servicio de PDF genera documentos con el formato correcto

### 2. Pruebas de Integración

**Objetivo**: Verificar la interacción entre diferentes componentes de la aplicación.

**Herramientas**:
- Flutter integration_test
- flutter_driver

**Flujos a probar**:
- Creación completa de un reporte desde el inicio hasta la generación del PDF
- Flujo de captura de evidencias (foto + ubicación + transcripción de voz)
- Almacenamiento y recuperación de datos locales

**Ejemplos de casos de prueba**:
- Crear un reporte completo y verificar que se guarda correctamente
- Capturar una foto, verificar que se capture automáticamente la ubicación, verificar que se active automáticamente la grabación de voz (obligatoria), comprobar la transcripción y guardar la evidencia
- Verificar que no se pueda guardar una evidencia sin la grabación de voz correspondiente
- Verificar que la ubicación se captura correctamente y se almacena con la evidencia
- Comprobar que las evidencias se muestran correctamente en formato galería
- Verificar que al hacer clic en una evidencia se muestra la vista expandida con la imagen completa, el mapa de ubicación y su descripción transcrita
- Generar un PDF y verificar que contiene todos los datos del reporte, incluyendo las imágenes de mapas de ubicación

### 3. Pruebas de UI

**Objetivo**: Verificar la correcta implementación de la interfaz de usuario.

**Herramientas**:
- Flutter widget testing
- Golden tests para comparación visual

**Componentes a probar**:
- Widgets personalizados
- Pantallas completas
- Navegación entre pantallas
- Responsive design

**Ejemplos de casos de prueba**:
- Verificar que los formularios muestran errores de validación correctamente
- Comprobar que la lista de suministros se muestra y actualiza correctamente
- Verificar que la galería de evidencias muestra correctamente las imágenes en formato grid
- Comprobar que al hacer clic en una evidencia se abre la vista expandida con la imagen completa y su descripción
- Validar que la UI se adapta a diferentes tamaños de pantalla

### 4. Pruebas de Usabilidad

**Objetivo**: Evaluar la experiencia del usuario y la facilidad de uso.

**Metodología**:
- Pruebas con usuarios reales (supervisores técnicos)
- Escenarios de uso predefinidos
- Recopilación de feedback

**Aspectos a evaluar**:
- Facilidad para completar tareas comunes
- Tiempo necesario para crear un reporte completo
- Claridad de la interfaz y los flujos de navegación
- Satisfacción general del usuario

**Ejemplos de escenarios**:
- Crear un nuevo reporte con 3 suministros y 2 evidencias por suministro
- Navegar por la galería de evidencias y expandir varias imágenes para ver sus detalles
- Editar un reporte existente y agregar nuevas evidencias
- Generar y compartir un PDF por WhatsApp

### 5. Pruebas de Rendimiento

**Objetivo**: Evaluar el rendimiento de la aplicación en diferentes condiciones.

**Aspectos a evaluar**:
- Uso de memoria
- Tiempo de respuesta
- Consumo de batería
- Tamaño de la aplicación

**Escenarios de prueba**:
- Generación de PDFs con muchas imágenes
- Manejo de reportes con gran cantidad de suministros
- Funcionamiento en dispositivos de gama baja

**Herramientas**:
- Flutter DevTools
- Android Profiler

### 6. Pruebas de Compatibilidad

**Objetivo**: Verificar el funcionamiento en diferentes versiones de Android y tamaños de pantalla.

**Dispositivos y versiones**:
- Android 6.0 (API 23) hasta la versión más reciente
- Diferentes densidades de pantalla (ldpi, mdpi, hdpi, xhdpi, xxhdpi)
- Diferentes tamaños de pantalla (4" a 10")

**Aspectos a evaluar**:
- Renderizado correcto de la UI
- Funcionalidad de características específicas de plataforma
- Permisos y acceso a hardware (cámara, micrófono, almacenamiento)

## Matriz de Pruebas por Funcionalidad

| Funcionalidad | Pruebas Unitarias | Pruebas de Integración | Pruebas de UI | Pruebas de Usabilidad | Pruebas de Rendimiento |
|---------------|-------------------|------------------------|---------------|----------------------|------------------------|
| Creación de reporte | ✓ | ✓ | ✓ | ✓ | - |
| Registro de evidencias | ✓ | ✓ | ✓ | ✓ | ✓ |
| Captura de fotos | ✓ | ✓ | ✓ | ✓ | ✓ |
| Captura de ubicación | ✓ | ✓ | ✓ | ✓ | ✓ |
| Transcripción de voz | ✓ | ✓ | ✓ | ✓ | ✓ |
| Conclusiones y recomendaciones | ✓ | ✓ | ✓ | ✓ | - |
| Generación de PDF | ✓ | ✓ | - | ✓ | ✓ |
| Compartir informe | ✓ | ✓ | ✓ | ✓ | - |
| Almacenamiento local | ✓ | ✓ | - | - | ✓ |

## Entornos de Prueba

### Entorno de Desarrollo
- Emuladores Android con diferentes configuraciones
- Dispositivos físicos de desarrollo
- Datos de prueba predefinidos

### Entorno de Pruebas
- Conjunto más amplio de dispositivos físicos
- Datos que simulan casos de uso reales
- Condiciones variadas (baja memoria, baja batería, etc.)

### Entorno de Producción
- Pruebas beta con usuarios reales
- Monitoreo de errores y rendimiento

## Datos de Prueba

Se crearán conjuntos de datos de prueba que incluyan:

- Reportes con diferentes cantidades de suministros
- Suministros con diferentes cantidades de evidencias
- Imágenes de diferentes resoluciones y tamaños
- Grabaciones de voz de diferentes duraciones
- Textos de diferentes longitudes para observaciones y conclusiones

## Criterios de Aceptación

### Funcionales
- Todas las funcionalidades descritas en los requisitos funcionan correctamente
- La aplicación funciona en modo offline excepto para las funcionalidades que requieren conexión
- Los PDFs generados siguen exactamente el formato oficial

### No Funcionales
- La aplicación responde en menos de 2 segundos para operaciones comunes
- La generación de PDF toma menos de 5 segundos para reportes estándar
- El consumo de memoria no excede 200MB en uso normal
- La aplicación funciona correctamente en dispositivos con Android 6.0 o superior

## Proceso de Gestión de Defectos

1. **Identificación**: Detección del defecto durante las pruebas
2. **Documentación**: Registro detallado incluyendo pasos para reproducir, capturas de pantalla, logs
3. **Clasificación**: Categorización por severidad y prioridad
4. **Asignación**: Asignación al desarrollador responsable
5. **Resolución**: Corrección del defecto
6. **Verificación**: Comprobación de que el defecto ha sido corregido
7. **Cierre**: Documentación de la resolución

### Severidades de Defectos

- **Crítica**: Bloquea funcionalidades principales, crash de la aplicación
- **Alta**: Afecta significativamente la funcionalidad pero existe una solución alternativa
- **Media**: Afecta parcialmente la funcionalidad o la experiencia de usuario
- **Baja**: Problemas menores, cosméticos o de mejora

## Cronograma de Pruebas

| Fase | Tipo de Prueba | Duración | Entregables |
|------|----------------|----------|-------------|
| Desarrollo | Unitarias | Continuo | Informes de cobertura |
| Desarrollo | Integración | Semanal | Informes de pruebas |
| Alpha | UI/Usabilidad | 1 semana | Informe de problemas UI |
| Alpha | Rendimiento | 3 días | Métricas de rendimiento |
| Beta | Compatibilidad | 1 semana | Matriz de compatibilidad |
| Beta | Usabilidad con usuarios | 2 semanas | Feedback de usuarios |
| Pre-lanzamiento | Pruebas de regresión | 3 días | Informe final |

## Herramientas y Recursos

### Herramientas de Prueba
- Flutter test framework
- Mockito para mocks
- flutter_driver para pruebas de integración
- DevTools para análisis de rendimiento
- Firebase Crashlytics para monitoreo de errores (opcional)

### Recursos Necesarios
- Dispositivos Android de diferentes gamas y versiones
- Acceso a usuarios reales para pruebas de usabilidad
- Entorno de CI/CD para automatización de pruebas

## Riesgos y Mitigación

| Riesgo | Probabilidad | Impacto | Estrategia de Mitigación |
|--------|--------------|---------|--------------------------|
| Problemas de compatibilidad en versiones antiguas de Android | Media | Alto | Pruebas tempranas en múltiples versiones |
| Rendimiento deficiente en dispositivos de gama baja | Alta | Alto | Optimización continua y pruebas de rendimiento |
| Problemas con la transcripción de voz | Media | Medio | Implementar edición manual como alternativa |
| Resistencia de usuarios al flujo obligatorio de grabación de voz | Media | Alto | Proporcionar instrucciones claras y feedback sobre la importancia de las descripciones verbales |
| Fallos en la activación automática de grabación de voz tras tomar foto | Baja | Alto | Implementar mecanismo de respaldo para activación manual y pruebas exhaustivas |
| Problemas con la captura automática de ubicación | Media | Alto | Implementar opción para ingresar ubicación manualmente y mostrar indicadores claros del estado de la captura |
| Precisión insuficiente de la ubicación GPS | Media | Medio | Permitir refinar manualmente la ubicación y mostrar el nivel de precisión al usuario |
| Formato incorrecto en PDFs generados | Baja | Alto | Validación exhaustiva contra el formato oficial |
| Problemas de permisos en diferentes versiones de Android | Media | Medio | Manejo robusto de permisos y guías claras para el usuario |

## Conclusión

Este plan de pruebas proporciona un enfoque estructurado para garantizar la calidad de la aplicación de Supervisión de Obras. La combinación de diferentes tipos de pruebas y la atención a los aspectos funcionales y no funcionales asegurará que la aplicación cumpla con todos los requisitos y proporcione una experiencia de usuario satisfactoria.