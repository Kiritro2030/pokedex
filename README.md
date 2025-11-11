# Pokedex

Aplicación móvil de Pokédex desarrollada con Flutter que permite consultar información detallada de Pokémon y gestionar favoritos.

## Características

- Listado paginado de Pokémon
- Información detallada de cada Pokémon (stats, tipos, habilidades)
- Sistema de favoritos con persistencia local
- Caché de imágenes
- Arquitectura Clean Architecture
- Gestión de estado con Provider
- Interfaz moderna y responsiva

## Arquitectura

El proyecto implementa Clean Architecture con la siguiente estructura:

```
lib/
├── core/
│   ├── error/
│   ├── extensions/
│   └── usecases/
└── features/
    └── pokemon/
        ├── data/
        │   └── datasources/
        ├── domain/
        │   ├── repositories/
        │   └── usecases/
        └── presentation/
            ├── providers/
            └── screens/
```

## Tecnologías y Dependencias

- **Flutter SDK**: ^3.9.2
- **State Management**: Provider ^6.1.5
- **HTTP**: ^1.5.0
- **Functional Programming**: Dartz ^0.10.1
- **Cache**: cached_network_image ^3.4.1
- **Local Storage**: shared_preferences ^2.5.3
- **UI**: Material Design 3

## Requisitos Previos

### Instalaciones Necesarias

1. **Flutter SDK**
   - Descargar desde: https://flutter.dev/docs/get-started/install
   - Versión mínima: 3.9.2

2. **Android Studio** (para desarrollo Android)
   - Descargar desde: https://developer.android.com/studio
   - Instalar Android SDK
   - Configurar variables de entorno

3. **Extensiones de Flutter para Android Studio**
   - Flutter Plugin
   - Dart Plugin

4. **Xcode** (para desarrollo iOS - solo macOS)
   - Descargar desde Mac App Store
   - Instalar Command Line Tools

### Verificar Instalación

Ejecutar el siguiente comando para verificar que todo está correctamente instalado:

```bash
flutter doctor
```

Resolver cualquier problema que indique el comando antes de continuar.

## Instalación

1. Clonar el repositorio:
```bash
git clone <url-del-repositorio>
cd pokedex
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Generar archivos de configuración (splash screen e iconos):
```bash
flutter pub run flutter_native_splash:create
flutter pub run flutter_launcher_icons
```

## Ejecución

### Modo Debug

1. Conectar un dispositivo físico o iniciar un emulador

2. Verificar dispositivos conectados:
```bash
flutter devices
```

3. Ejecutar la aplicación:
```bash
flutter run
```

### Seleccionar Dispositivo Específico

```bash
flutter run -d <device-id>
```

### Modo Release

```bash
flutter run --release
```

## Compilación

### Android (APK)

```bash
flutter build apk --release
```

El APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

### Android (App Bundle)

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Estructura del Proyecto

- **data/datasources**: Fuentes de datos (API, local storage)
- **domain/repositories**: Interfaces de repositorios
- **domain/usecases**: Casos de uso de la aplicación
- **presentation/providers**: Gestión de estado
- **presentation/screens**: Pantallas de la aplicación

## Configuración Adicional

### API

La aplicación consume la PokeAPI: https://pokeapi.co/

No requiere configuración adicional ni API keys.

### Persistencia Local

Los favoritos se almacenan localmente usando SharedPreferences, sin necesidad de configuración adicional.

## Comandos Útiles

```bash
# Limpiar proyecto
flutter clean

# Actualizar dependencias
flutter pub upgrade

# Analizar código
flutter analyze

# Ejecutar tests
flutter test

# Verificar versión de Flutter
flutter --version
```

## Solución de Problemas

### Error: "SDK not found"
Verificar que la variable de entorno FLUTTER_HOME esté configurada correctamente.

### Error de dependencias
Ejecutar:
```bash
flutter clean
flutter pub get
```

### Problemas con Android
Verificar Android SDK instalado y configurado en Android Studio.

### Problemas con iOS
Ejecutar:
```bash
cd ios
pod install
cd ..
```

## Licencia

Este proyecto es de código abierto.
