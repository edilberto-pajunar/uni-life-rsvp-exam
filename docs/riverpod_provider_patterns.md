# Riverpod Provider Patterns: Query vs. Command

In `events_provider.dart`, there are two fundamentally different patterns for working with state in Riverpod. Understanding the difference helps you know where to put new logic.

---

## Function Provider — `fetchEvents`

```dart
@riverpod
Future<List<Event>> fetchEvents(Ref ref) async {
  ref.keepAlive();
  return EventRepositoryImpl().getEvents();
}
```

This is a **top-level function** annotated with `@riverpod`. The generator emits `fetchEventsProvider`.

- The provider **is** the state. There is no class, no `build()`, no mutation.
- It exposes `AsyncValue<List<Event>>` — loading, error, or data.
- `ref.keepAlive()` prevents Riverpod from disposing it when no widget is watching.
- Widgets read it with `ref.watch(fetchEventsProvider)`.
- It re-runs automatically when invalidated: `ref.invalidate(fetchEventsProvider)`.

**When to use this pattern:** when you are modeling a **remote resource** — something you fetch and display. The provider's job is to represent that data, not to perform an action.

---

## Notifier Method — `toggleRsvp`

```dart
@riverpod
class RsvpNotifier extends _$RsvpNotifier {
  @override
  AsyncValue<Event?> build() => const AsyncData(null);

  Future<void> toggleRsvp(Event event, bool confirm) async {
    // 1. Optimistic update — reflect the change immediately in UI
    state = AsyncData(
      event.copyWith(
        isRsvped: confirm,
        rsvpCount: (event.rsvpCount ?? 0) + (confirm ? 1 : -1),
      ),
    );

    // 2. Call the API
    final result = await AsyncValue.guard(
      () => EventRepositoryImpl().toggleEventRsvp(event.id!, confirm),
    );

    if (!ref.mounted) return;

    // 3a. On success — invalidate the detail provider so it re-fetches fresh data
    if (result is AsyncData) {
      ref.invalidate(fetchEventProvider(event.id!));
    }
    // 3b. On failure — surface the error (UI can roll back or show message)
    else if (result is AsyncError) {
      state = AsyncError(result.error, result.stackTrace);
    }
  }
}
```

This is a **`@riverpod` class** (a Notifier). The generator emits `rsvpNotifierProvider`.

- The notifier **owns** mutable state (`AsyncValue<Event?>`). `build()` sets the initial value.
- `toggleRsvp` is a **method** the UI calls to trigger a side effect.
- It mutates `state` directly, so any widget watching the provider rebuilds immediately (optimistic update).
- On success, it invalidates `fetchEventProvider` to pull fresh server data into the detail screen.
- Widgets call it with `ref.read(rsvpNotifierProvider.notifier).toggleRsvp(event, true)`.

**When to use this pattern:** when you are modeling a **user action** (a command, a mutation). The notifier's job is to perform the action, manage in-flight state, and handle the outcome.

---

## Summary

| | `fetchEvents` | `toggleRsvp` |
|---|---|---|
| Location | Top-level function | Method on a Notifier class |
| Role | Query — read remote data | Command — perform a mutation |
| State ownership | Provider IS the state | Notifier holds state, method changes it |
| UI interaction | `ref.watch(fetchEventsProvider)` | `ref.read(rsvpNotifierProvider.notifier).toggleRsvp(...)` |
| Triggered by | Widget subscribing / invalidation | User action (button tap) |
| Side effects | None — pure fetch | API call + optimistic update + cache invalidation |

---

## Rule of Thumb

> If you are **reading** something, use a function provider.  
> If you are **doing** something, use a method on a Notifier.
