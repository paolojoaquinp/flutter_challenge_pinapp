# 🎬 PinApp The Movie DB

Aplicación Flutter que consume la API de **TMDB** y muestra películas populares, mejor puntuadas y próximas a estrenarse. Implementada con **Clean Architecture**, **Riverpod** y estrategia **Offline-First** con Hive.

---

## 🎥 Demo

![Demo de la aplicación](screenshots/video-pinapp-challenge.mov)

---

## 🚀 Quick Start

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Configurar API Key de TMDB
cp .env.example .env
# Editar .env y pegar tu token de https://www.themoviedb.org/settings/api

# 3. Generar código (Riverpod / Freezed / Hive)
dart run build_runner build --delete-conflicting-outputs

# 4. Ejecutar
flutter run
```

---

## 🧱 Tech Stack

| Capa | Tecnología |
|------|------------|
| State Management | Riverpod (`@riverpod` generator) |
| Networking | Dio + Interceptors |
| Persistencia | Hive + SharedPreferences |
| Remote Config | Firebase Remote Config |
| Modelos | Freezed + json_serializable |

---

## 📂 Estructura del Proyecto

```mermaid
graph TD
    A[lib/] --> B[core/]
    A --> C[features/movies/]
    A --> D[main.dart]

    B --> B1[network/]
    B --> B2[local_storage/]
    B --> B3[remote_config/]
    B --> B4[utils/]

    C --> E[presentation/]
    C --> F[domain/]
    C --> G[data/]

    E --> E1[screens/]
    E --> E2[widgets/]
    E --> E3[providers/]

    F --> F1[entities/]
    F --> F2[repositories/]
    F --> F3[usecases/]

    G --> G1[models/DTOs]
    G --> G2[datasources/]
    G --> G3[repositories_impl/]
```

### Tabla de capas

| Capa | Responsabilidad | Depende de |
|------|-----------------|-----------|
| **Presentation** | UI, Widgets, Riverpod Notifiers | Domain |
| **Domain** | Entidades, UseCases, Interfaces (Dart puro) | — |
| **Data** | DTOs, DataSources (Dio/Hive), Repo Impl | Domain |
| **Core** | Red, errores, config global | — |

---

## 🗺️ Diagrama C4 — Nivel 2 (Contenedores)

```mermaid
C4Container
    title Diagrama de Contenedores - PinApp The Movie DB

    Person(user, "Usuario", "Ve películas populares, detalles y recomendaciones")

    System_Boundary(app, "PinApp Mobile") {
        Container(ui, "Presentation Layer", "Flutter + Riverpod", "Pantallas, widgets y notifiers (AsyncValue)")
        Container(domain, "Domain Layer", "Dart puro", "Entities, UseCases e interfaces de repositorio")
        Container(data, "Data Layer", "Repositories Impl", "Orquesta remote/local y mapea DTOs a entidades")
        ContainerDb(hive, "Hive Cache", "NoSQL local", "Guarda listas de películas para modo offline")
        Container(dio, "Dio Client", "HTTP Client", "Interceptors de auth y conectividad")
    }

    System_Ext(tmdb, "TMDB API", "The Movie Database REST API")
    System_Ext(firebase, "Firebase Remote Config", "Flags y configuración remota")

    Rel(user, ui, "Interactúa con")
    Rel(ui, domain, "Invoca UseCases")
    Rel(domain, data, "Usa interfaces (DI)")
    Rel(data, dio, "Solicita datos remotos")
    Rel(data, hive, "Lee/escribe caché")
    Rel(dio, tmdb, "GET /movie/*", "HTTPS/JSON")
    Rel(ui, firebase, "Lee flags", "HTTPS")
```

---

## 📝 ADRs (Decisiones Arquitectónicas)

### ADR-001 · State Management: Riverpod Generator
- **Decisión:** Usar Riverpod con `@riverpod` en lugar de BLoC.
- **Por qué:** DI segura en compilación, `autoDispose` por defecto evita fugas de memoria y reduce boilerplate.
- **Trade-off:** Dependencia de `build_runner` para generar código.

### ADR-002 · Offline-First con Hive
- **Decisión:** Repositorio que consulta red; si no hay conexión, lee de Hive.
- **Por qué:** La app debe funcionar sin internet mostrando la última data cargada.
- **Regla:** Las entidades de dominio **no** llevan anotaciones de Hive — solo los DTOs en `data/`.

### ADR-003 · Separación DTO ↔ Entity (Mappers)
- **Decisión:** `MovieModel` (data) con `fromJson/toJson` + `toEntity()` hacia `Movie` (domain).
- **Por qué:** Si TMDB renombra campos, solo cambia el DTO. UI y UseCases no se tocan (OCP).

---

## 🧩 Implementación por capas (resumen)

- **Domain** → `Movie` como entidad inmutable con Freezed; `MovieRepository` como contrato abstracto; UseCases simples (ej. `GetPopularMovies`).
- **Data** → `MovieModel extends Movie` con `fromJson`; `MovieRemoteDataSource` (Dio) y `MovieLocalDataSource` (Hive); `MovieRepositoryImpl` resuelve la estrategia **Offline-First** de ADR-002 y mapea `DioException` → `Failure`.
- **Presentation** → `MoviesAsyncNotifier` con `@riverpod` exponiendo `AsyncValue<List<Movie>>`; widgets consumen estados `loading / data / error`.
- **Core** → `DioClient` con interceptores (auth token, logging), `ConnectivityChecker` y clases `Failure` (Network, Cache, Server).

---

## 🏅 Criterios de Calidad (QA Attributes)

| Atributo | Táctica Técnica | Ubicación en la Arquitectura |
|----------|----------------|------------------------------|
| **Explainability** | Typed Metadata Mapping | `domain/entities` + `data/models`: mapeo estricto y tipado de errores y reglas de negocio; la UI muestra mensajes exactos sobre el estado de la data. |
| **Safety** | Data Sanitization Interceptor | `data/repositories` + `core/network`: interceptor que valida inputs antes de procesarlos, previniendo envíos nulos o malformados. |
| **Latency (percibida)** | Riverpod AsyncValue (Offline-First) | `presentation/providers`: los Notifiers emiten `AsyncLoading` inicial y transicionan a `AsyncData` con cache local mientras actualizan en background. |
| **Cost / Resource Efficiency** | Hive-First Policy (TTL Caching) | `data/datasources/local`: el repositorio consulta Hive antes de llamar a la red; si el TTL es válido, ahorra la petición y consumo de batería. |

---

## 🧪 Testing

```bash
flutter test --coverage
```

Objetivo de cobertura: **>80%**.

---

## 🎯 Principios SOLID aplicados

- **S** — Repositorios separados por entidad.
- **D** — UseCases dependen de interfaces, no de implementaciones.
- **I** — DataSources independientes para remoto y local.

---

> Ver documentación extendida en [docs/requirements.md](docs/requirements.md) y [docs/design.md](docs/design.md).
