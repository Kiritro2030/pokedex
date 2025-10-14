# Flujo de Clean Architecture para Obtener Pokémon

## 📋 Resumen
Este documento describe paso a paso cómo implementar la funcionalidad de obtener los primeros 20 Pokémon desde la PokéAPI usando Clean Architecture en Flutter.

---

## 🏗️ Estructura de Carpetas Propuesta

```
lib/
├── main.dart
├── core/                          # Utilidades compartidas
│   ├── error/
│   │   ├── failures.dart          # Clases de errores abstractas
│   │   └── exceptions.dart        # Excepciones concretas
│   └── usecases/
│       └── usecase.dart           # Clase base para casos de uso
│
├── features/
│   └── pokemon/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── pokemon_remote_datasource.dart
│       │   ├── models/
│       │   │   └── pokemon_model.dart          # DTO (convierte JSON ↔ Entity)
│       │   └── repositories/
│       │       └── pokemon_repository_impl.dart # Implementación concreta
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── pokemon.dart                 # Clase pura de negocio
│       │   ├── repositories/
│       │   │   └── pokemon_repository.dart      # Contrato (interfaz)
│       │   └── usecases/
│       │       └── get_pokemons.dart            # Lógica de negocio
│       │
│       └── presentation/
│           ├── provider/
│           │   └── pokemon_provider.dart        # Gestión de estado
│           ├── screens/
│           │   └── pokemon_list_screen.dart
│           └── widgets/
│               └── pokemon_card.dart
│
└── injection_container.dart       # Configuración de dependencias
```

---

## 🔄 Flujo de Datos Completo

```
┌─────────────────────────────────────────────────────────────────────┐
│                        1. PRESENTATION LAYER                        │
├─────────────────────────────────────────────────────────────────────┤
│  PokemonListScreen                                                  │
│    ↓                                                                │
│  PokemonProvider (ChangeNotifier/Riverpod/BLoC)                    │
│    - Estado: loading, success, error                               │
│    - Llama al UseCase                                              │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│                        2. DOMAIN LAYER                              │
├─────────────────────────────────────────────────────────────────────┤
│  GetPokemons (UseCase)                                              │
│    - Parámetro: limit = 20                                         │
│    - Ejecuta: repository.getPokemons(20)                           │
│    - Retorna: Either<Failure, List<Pokemon>>                       │
│                                                                     │
│  PokemonRepository (Interface)                                      │
│    - Define el contrato: Future<Either<Failure, List<Pokemon>>>   │
│                                                                     │
│  Pokemon (Entity)                                                   │
│    - Clase pura de Dart sin dependencias de JSON                   │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│                        3. DATA LAYER                                │
├─────────────────────────────────────────────────────────────────────┤
│  PokemonRepositoryImpl                                              │
│    - Implementa la interfaz del dominio                            │
│    - Maneja errores y los convierte en Failures                    │
│    - Llama al RemoteDataSource                                     │
│                                                                     │
│  PokemonRemoteDataSource                                            │
│    - Hace la petición HTTP a:                                      │
│      https://pokeapi.co/api/v2/pokemon?limit=20                    │
│    - Parsea el JSON                                                │
│    - Convierte JSON → PokemonModel                                 │
│                                                                     │
│  PokemonModel (DTO)                                                 │
│    - Extiende Pokemon Entity                                       │
│    - Tiene métodos: fromJson() y toJson()                          │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────────┐
│                        4. API RESPONSE                              │
├─────────────────────────────────────────────────────────────────────┤
│  {                                                                  │
│    "count": 1292,                                                   │
│    "results": [                                                     │
│      {                                                              │
│        "name": "bulbasaur",                                         │
│        "url": "https://pokeapi.co/api/v2/pokemon/1/"               │
│      },                                                             │
│      ...                                                            │
│    ]                                                                │
│  }                                                                  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📝 PASOS DE IMPLEMENTACIÓN

### **PASO 1: Configurar dependencias**
- Instalar paquetes necesarios: `http`, `dartz`, `provider` (o el state manager que prefieras)

### **PASO 2: Crear las entidades del dominio**
- Crear `Pokemon` (Entity) → Clase pura de Dart

### **PASO 3: Crear el repositorio del dominio**
- Crear `PokemonRepository` (Interface) → Define el contrato

### **PASO 4: Crear el UseCase**
- Crear `GetPokemons` → Lógica de negocio que llama al repositorio

### **PASO 5: Crear el DataSource remoto**
- Crear `PokemonRemoteDataSource` → Se conecta a la API

### **PASO 6: Crear el Modelo (DTO)**
- Crear `PokemonModel` → Convierte JSON ↔ Entity

### **PASO 7: Implementar el repositorio**
- Crear `PokemonRepositoryImpl` → Implementación concreta que usa el DataSource

### **PASO 8: Crear clases de error**
- Crear `Failures` y `Exceptions` → Manejo de errores

### **PASO 9: Configurar el Provider/State Management**
- Crear `PokemonProvider` → Gestiona el estado de la UI

### **PASO 10: Conectar la UI**
- Actualizar `PokemonListScreen` → Mostrar los datos

### **PASO 11: Configurar inyección de dependencias**
- Crear `injection_container.dart` → Registrar todas las dependencias

---

## 🎯 ¿Por qué este flujo?

✅ **Separación de responsabilidades**: Cada capa tiene un propósito específico
✅ **Testeable**: Puedes testear cada capa de forma independiente
✅ **Escalable**: Fácil agregar nuevas features sin romper el código existente
✅ **Mantenible**: El código es limpio y fácil de entender
✅ **Independiente de frameworks**: El dominio no sabe nada de Flutter o HTTP

---

## 📌 Notas Importantes

1. **Either**: Usamos `Either<Failure, Success>` del paquete `dartz` para manejar errores de forma funcional
2. **Entity vs Model**: 
   - Entity = Objeto de dominio puro (sin JSON)
   - Model = DTO que convierte JSON ↔ Entity
3. **Repository Pattern**: Abstrae el origen de datos (API, DB, caché)
4. **UseCase**: Cada acción del usuario es un caso de uso independiente

---

## 🚀 ¿Listo para empezar?

Responde **"PASO 1"** cuando estés listo para comenzar con la configuración de dependencias.
