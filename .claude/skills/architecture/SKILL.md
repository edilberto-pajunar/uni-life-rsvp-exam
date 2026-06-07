---
description: "This rule provides the overall architecture and MUST follow when building the project"
alwaysApply: false
---

# Architecture Overview

This document provides a high-level overview of the Flutter application architecture. The project follows a modular, feature-first approach combined with Clean Architecture principles and Atomic Design for the UI layer.

## Core Philosophy

The architecture aims for:

- **Separation of Concerns:** Distinct layers for data, business logic, and UI.
- **Scalability:** Features are self-contained modules, making it easy to add new functionality without impacting existing code.
- **Reusability:** UI components are built using Atomic Design principles, promoting consistency and reducing code duplication.
- **Testability:** Logic is decoupled from the UI and external dependencies (API, database), making unit and widget testing straightforward.
- **Reactive by default:** Riverpod providers are the single source of truth. The UI observes providers; it never drives them imperatively.
- **Zero manual DI wiring:** Riverpod replaces GetIt entirely. Providers declare their own dependencies by reading other providers via `ref.watch` / `ref.read`. There is no service-locator registration step.

---

## High-Level Structure

```
lib/
├── core/               # Shared utilities, services, configuration, and base classes.
│   ├── api/            # HTTP client (Dio), interceptors, generated API code.
│   ├── routes/         # Navigation logic (AppRouter using GoRouter).
│   ├── services/       # Infrastructure services (storage, permissions, analytics).
│   ├── theme/          # App theming (AppColors, AppSizes, AppTextTheme).
│   └── utils/          # Helper functions and extensions.
├── features/           # Feature-specific code (providers, data, domain, UI).
├── data/               # Repository interfaces (abstract definitions).
├── domain/             # Global domain logic (cross-feature use cases).
├── presentation/       # Generic UI components (Atomic Design).
├── l10n/               # Localization ARB files.
└── main.dart           # App entry point — wraps the widget tree in ProviderScope.
```

> **Note:** `core/di/` is gone. Riverpod handles all dependency injection — no GetIt registration needed.

---

## Detailed Breakdown

### 1. Core (`lib/core`)

Contains application-wide utilities and infrastructure that are not feature-specific.

- **`api/`** — Network layer: Dio client, interceptors, OpenAPI generated code. The Dio instance is exposed as a top-level Riverpod provider so any feature can depend on it.
- **`routes/`** — Centralized navigation with GoRouter (`AppRouter`). Auth-guarded routes read an auth-state provider inside the router's `redirect` callback.
- **`services/`** — Infrastructure services (local storage, permissions, analytics). Each service is exposed as a top-level Riverpod `Provider` — no registration ceremony.
- **`theme/`** — Design tokens: `AppColors`, `AppSizes`, `AppTextTheme`, `AppTheme`.
- **`utils/`** — Pure helper functions and Dart extensions.

There is **no `di/` folder.** Provider definitions are the dependency graph.

---

### 2. Features (`lib/features`)

Each feature is a self-contained module:

```
features/<feature_name>/
├── data/               # Repository implementation (API calls, local storage).
├── domain/             # Feature-specific use cases.
├── providers/          # Riverpod providers and Notifier classes (replaces logic/).
└── presentation/
    ├── pages/          # Screens for this feature.
    └── widgets/        # Widgets specific to this feature.
```

#### `data/`
Implements the repository interface defined in `lib/data/repositories/`. Talks directly to the network (via the Dio provider) or local storage.

#### `domain/`
Feature-scoped use cases — plain Dart classes whose dependencies are injected through the constructor. The use case is then exposed via a Riverpod provider in `providers/`.

#### `providers/`
Replaces the old `logic/` (Cubits) folder. Contains:

- **Repository providers** — expose the feature's repository implementation.
- **Use-case providers** — expose use-case instances, watching the repository provider.
- **State providers / Notifiers** — manage UI-level async or mutable state using `AsyncNotifier` or `Notifier`.

All provider declarations are **top-level `final` variables**, never inside a class.

#### `presentation/`
Pages extend `ConsumerWidget` or `ConsumerStatefulWidget` so they can call `ref.watch` to observe providers reactively.

---

### 3. Data Layer (`lib/data`)

- **`repositories/`** — Abstract classes (interfaces) for each repository. Implementations live in `features/<name>/data/`. This separation allows providers to depend on the abstract type and swap real vs. fake implementations in tests via `ProviderScope` overrides.

---

### 4. Domain Layer (`lib/domain`)

- **`usecases/`** — Cross-feature business logic that does not belong to a single feature. Exposed via Riverpod providers.

---

### 5. Presentation Layer (`lib/presentation`)

Implements the **Atomic Design System** for globally reusable UI components:

- **`atoms/`** — Basic building blocks: `AppButton`, `AppText`, `AppField`, `AppLoader`.
- **`molecules/`** — Groups of atoms: form fields with labels, cards with actions.
- **`organisms/`** — Complex UI sections: headers, specialized list tiles.

These components are pure UI — they accept data via constructor parameters and emit callbacks. They do not read providers directly. Provider consumption happens at the page/screen level.

---

## Key Patterns & Technologies

### State Management & Dependency Injection — Riverpod

**Libraries:** `flutter_riverpod`, `riverpod_annotation`, `riverpod_lint`

Riverpod is the single solution for both state management and dependency injection. It replaces BLoC/Cubit and GetIt.

#### Non-negotiable rules (enforced by `riverpod_lint`)

| Rule | Rationale |
|---|---|
| All providers are **top-level `final` variables** | Providers inside classes leak memory and cannot be tracked by the lint tool. |
| Providers **self-initialize** — no external init trigger | A provider's `build` method is the only place data is fetched. No widget "starts" a provider. |
| **No side effects inside `build`** | `build` is a read path. Mutations go in Notifier methods called via `ref.read(provider.notifier).method()`. |
| Use **static provider refs** (`ref.watch/read/listen` on known providers) | Enables compile-time analysis by `riverpod_lint`. |
| **No `keepAlive: true` / persistent singletons** | Providers auto-dispose by default (`@riverpod` generates `autoDispose`). Keeping providers alive permanently defeats cache invalidation and automatic resource cleanup. Only use `ref.keepAlive()` inside `build` when there is a clear, justified reason — it is the exception, not the default. |
| Ephemeral UI state (animations, form controllers, selected items in a single widget) → **`StatefulWidget`** or **`flutter_hooks`**, NOT providers | Providers are for shared / cross-widget state. Storing ephemeral state in providers breaks navigation history. |

#### Provider type selection guide

| Situation | Provider type |
|---|---|
| Sync, read-only derived value | `Provider` |
| Sync, mutable state | `NotifierProvider` + `Notifier` |
| One-shot async fetch, read-only | `FutureProvider` |
| One-shot async fetch, with mutations | `AsyncNotifierProvider` + `AsyncNotifier` |
| Continuous stream, read-only | `StreamProvider` |
| Continuous stream, with mutations | `StreamNotifierProvider` + `StreamNotifier` |

#### Code generation

Use the `@riverpod` annotation from `riverpod_annotation` for all providers. Run `dart run build_runner build --delete-conflicting-outputs` to regenerate `.g.dart` files.

---

### Dependency Injection via `ref.watch`

There is no service locator. A provider declares its dependencies by calling `ref.watch(otherProvider)` inside its factory or `build` method. The dependency graph is statically visible and verifiable.

Typical layering:
1. Infrastructure (Dio client, Firebase) → `Provider` in `lib/core/`
2. Repository implementations → `Provider` in `features/<name>/providers/`
3. Use-case classes → `Provider` that reads the repository provider
4. State Notifiers → `AsyncNotifierProvider` that reads the use-case or repository provider

---

### Navigation — GoRouter

**Library:** `go_router`

`AppRouter` lives in `lib/core/routes/`. For auth-guarded routes, the router's `redirect` callback reads the auth state provider to handle redirects reactively.

---

### Localization — flutter_localizations

**Files:** `lib/l10n/` (ARB files). Unchanged from the original architecture.

---

## Example Provider Patterns

### Functional provider — async read-only

```dart
// features/events/providers/events_provider.dart
part 'events_provider.g.dart';

@riverpod
Future<List<Event>> events(Ref ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEvents();
}
```

### Repository provider — DI via ref.watch

```dart
// features/events/providers/event_repository_provider.dart
part 'event_repository_provider.g.dart';

@riverpod
EventRepository eventRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return EventRepositoryImpl(dio: dio);
}
```

### Class-based AsyncNotifier — mutable async state with mutations

```dart
// features/events/providers/event_detail_provider.dart
part 'event_detail_provider.g.dart';

@riverpod
class EventDetail extends _$EventDetail {
  @override
  Future<Event> build(String eventId) async {
    final repository = ref.watch(eventRepositoryProvider);
    return repository.getEvent(eventId);
  }

  Future<void> toggleRsvp() async {
    final previous = state;
    // Optimistic update
    state = previous.whenData(
      (event) => event.copyWith(isRsvped: !(event.isRsvped ?? false)),
    );
    try {
      final updated = await ref.read(eventRepositoryProvider).toggleRsvp(state.value!.id!);
      state = AsyncData(updated);
    } catch (e, st) {
      state = previous;
      state = AsyncError(e, st);
    }
  }
}
```

### ConsumerWidget consuming a provider

```dart
class EventsPage extends ConsumerWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return eventsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (events) => ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, i) => EventCard(event: events[i]),
      ),
    );
  }
}
```

### Calling a mutation — use `ref.read`, not `ref.watch`

```dart
ElevatedButton(
  onPressed: () {
    // ref.read for one-shot actions — never ref.watch in callbacks.
    ref.read(eventDetailProvider(event.id!).notifier).toggleRsvp();
  },
  child: const Text('RSVP'),
)
```

### Ephemeral state — keep it local

Form controllers, text fields, and single-widget selection state belong in `StatefulWidget`, not in a provider.

```dart
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>(); // ephemeral — correct
}
```

---

## App Entry Point

`main.dart` wraps the widget tree in `ProviderScope`. This is the only required bootstrap step — no service registration.

```dart
void main() {
  runApp(const ProviderScope(child: App()));
}
```

---

## Testing

### Unit testing providers with `ProviderContainer`

```dart
test('toggleRsvp updates state', () async {
  final container = ProviderContainer(
    overrides: [
      eventRepositoryProvider.overrideWith((ref) => FakeEventRepository()),
    ],
  );
  addTearDown(container.dispose);

  await container.read(eventDetailProvider('1').future);
  await container.read(eventDetailProvider('1').notifier).toggleRsvp();

  expect(container.read(eventDetailProvider('1')).value?.isRsvped, isTrue);
});
```

### Widget testing with `ProviderScope` overrides

```dart
testWidgets('shows event list', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        eventsProvider.overrideWith((ref) async => [fakeEvent]),
      ],
      child: const MaterialApp(home: EventsPage()),
    ),
  );

  await tester.pumpAndSettle();
  expect(find.byType(EventCard), findsOneWidget);
});
```

**Key principles:**
- Each `ProviderContainer` in a unit test is isolated — no shared state between tests.
- Always call `container.dispose()` in `addTearDown`.
- Override at the repository layer; business logic in the Notifier is tested for real.
- The abstract repository interface in `lib/data/repositories/` is the seam for fakes.

---

## riverpod_lint Setup

`pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^3.x.x
  riverpod_annotation: ^3.x.x

dev_dependencies:
  riverpod_lint: ^2.x.x
  riverpod_generator: ^2.x.x
  build_runner: ^2.x.x
  custom_lint: ^0.x.x
```

`analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  plugins:
    - custom_lint
```

Run: `dart run custom_lint`

`riverpod_lint` flags providers declared inside classes, `ref.watch` calls outside `build`, missing `@riverpod` annotations, and other common mistakes automatically.

---

## Migration Checklist (BLoC/GetIt → Riverpod)

When migrating an existing feature or adding a new one:

1. Delete `features/<name>/logic/` — remove all Cubit and BLoC files.
2. Remove any `GetIt.I.registerLazySingleton<...>` calls from `lib/core/di/`.
3. Create `features/<name>/providers/` with repository, use-case, and Notifier providers.
4. Change pages from `StatelessWidget` + `BlocBuilder` → `ConsumerWidget` + `ref.watch`.
5. Replace `context.read<MyCubit>().doSomething()` → `ref.read(myProvider.notifier).doSomething()`.
6. Wrap `main()` in `ProviderScope` (done once, globally).
7. Delete `lib/core/di/` entirely once all features are migrated.
