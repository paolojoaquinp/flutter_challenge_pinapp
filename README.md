# 🎬 PinApp The Movie DB

Aplicación Flutter que consume la API de **TMDB** y muestra películas populares, mejor puntuadas y próximas a estrenarse. Implementada con **Clean Architecture**, **Riverpod** y estrategia **Offline-First** con Hive.

---

## 🎥 Demo

![Demo de la aplicación](screenshots/video-pinapp-challenge.gif)

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

![imgae structure](./screenshots/mermaid-table.png)

### Tabla de capas

| Capa | Responsabilidad | Depende de |
|------|-----------------|-----------|
| **Presentation** | UI, Widgets, Riverpod Notifiers | Domain |
| **Domain** | Entidades, UseCases, Interfaces (Dart puro) | — |
| **Data** | DTOs, DataSources (Dio/Hive), Repo Impl | Domain |
| **Core** | Red, errores, config global | — |

---

## 🗺️ Diagrama C4 — Nivel 2 (Contenedores)

![imgae structure](./screenshots/c4-diagram.png)
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
flutter test              # corre los 58 unit tests
./tool/coverage.sh        # tests + reporte lcov + gate ≥ 80 %
```

Cobertura actual: **90 %** (entities, models, datasources, repository, notifiers).

---

## 🎯 Principios SOLID aplicados

- **S** — Repositorios separados por entidad.
- **D** — UseCases dependen de interfaces, no de implementaciones.
- **I** — DataSources independientes para remoto y local.

