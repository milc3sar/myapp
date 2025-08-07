# Supervisor App

Aplicación móvil para supervisores técnicos de obras eléctricas que facilita la generación estructurada y automática de informes en formato PDF.

## Características Principales

- Creación de reportes diarios
- Registro de evidencias por suministro (fotos y observaciones)
- Transcripción de voz a texto para observaciones
- Conclusiones y recomendaciones
- Generación de PDF con formato oficial
- Compartir informes por diferentes medios

## Configuración del Proyecto

### Requisitos

- Flutter SDK ^3.8.1
- Dart SDK ^3.8.1
- Android Studio / VS Code

### Instalación

1. Clona el repositorio:
   ```
   git clone https://github.com/tu-usuario/supervisor.git
   ```

2. Navega al directorio del proyecto:
   ```
   cd supervisor
   ```

3. Instala las dependencias:
   ```
   flutter pub get
   ```

4. Genera el código necesario para freezed y json_serializable:
   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Arquitectura

La aplicación sigue el patrón de arquitectura BLoC (Business Logic Component), que separa la lógica de negocio de la interfaz de usuario.

### Estructura de Capas:
1. **Presentación**: Widgets de Flutter, pantallas y componentes UI
2. **BLoC**: Manejo de estados y lógica de negocio
3. **Repositorio**: Abstracción para acceso a datos
4. **Fuentes de Datos**: Implementaciones concretas para almacenamiento local

## Generación de Código

Este proyecto utiliza varias bibliotecas de generación de código:

### Freezed

Para generar modelos inmutables con implementaciones automáticas de:
- copyWith
- toString
- Operadores de igualdad (==, hashCode)
- Serialización JSON

### JSON Serializable

Para la serialización y deserialización automática de JSON.

### Hive Generators

Para la generación de adaptadores para el almacenamiento local con Hive.

### Comandos para Generación de Código

Para generar el código una vez:
```
flutter pub run build_runner build --delete-conflicting-outputs
```

Para generar el código continuamente durante el desarrollo:
```
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Licencia

Este proyecto está licenciado bajo [tu licencia aquí].