// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the event repository through Riverpod so it can be overridden with a
/// mock in tests. Defaults to the real [EventRepositoryImpl] in production.

@ProviderFor(eventRepository)
final eventRepositoryProvider = EventRepositoryProvider._();

/// Exposes the event repository through Riverpod so it can be overridden with a
/// mock in tests. Defaults to the real [EventRepositoryImpl] in production.

final class EventRepositoryProvider
    extends
        $FunctionalProvider<EventRepository, EventRepository, EventRepository>
    with $Provider<EventRepository> {
  /// Exposes the event repository through Riverpod so it can be overridden with a
  /// mock in tests. Defaults to the real [EventRepositoryImpl] in production.
  EventRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventRepositoryHash();

  @$internal
  @override
  $ProviderElement<EventRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EventRepository create(Ref ref) {
    return eventRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventRepository>(value),
    );
  }
}

String _$eventRepositoryHash() => r'a595c8b4ada08ed5c087fce92a4964ef4cfd50e5';

@ProviderFor(EventsNotifier)
final eventsProvider = EventsNotifierProvider._();

final class EventsNotifierProvider
    extends $NotifierProvider<EventsNotifier, Set<Event>> {
  EventsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventsNotifierHash();

  @$internal
  @override
  EventsNotifier create() => EventsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<Event> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<Event>>(value),
    );
  }
}

String _$eventsNotifierHash() => r'3c96906da42267777ae970334ab606befc6482e8';

abstract class _$EventsNotifier extends $Notifier<Set<Event>> {
  Set<Event> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<Event>, Set<Event>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<Event>, Set<Event>>,
              Set<Event>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(RsvpNotifier)
final rsvpProvider = RsvpNotifierProvider._();

final class RsvpNotifierProvider
    extends $NotifierProvider<RsvpNotifier, AsyncValue<Event?>> {
  RsvpNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rsvpProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rsvpNotifierHash();

  @$internal
  @override
  RsvpNotifier create() => RsvpNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Event?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Event?>>(value),
    );
  }
}

String _$rsvpNotifierHash() => r'9e12978895af7716e668fba774ff4a2a3bc319eb';

abstract class _$RsvpNotifier extends $Notifier<AsyncValue<Event?>> {
  AsyncValue<Event?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Event?>, AsyncValue<Event?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Event?>, AsyncValue<Event?>>,
              AsyncValue<Event?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(fetchEvents)
final fetchEventsProvider = FetchEventsProvider._();

final class FetchEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Event>>,
          List<Event>,
          FutureOr<List<Event>>
        >
    with $FutureModifier<List<Event>>, $FutureProvider<List<Event>> {
  FetchEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fetchEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fetchEventsHash();

  @$internal
  @override
  $FutureProviderElement<List<Event>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Event>> create(Ref ref) {
    return fetchEvents(ref);
  }
}

String _$fetchEventsHash() => r'a26f959abf3f3c1a8e5e6401cccf967d35a913bd';

@ProviderFor(fetchEvent)
final fetchEventProvider = FetchEventFamily._();

final class FetchEventProvider
    extends $FunctionalProvider<AsyncValue<Event>, Event, FutureOr<Event>>
    with $FutureModifier<Event>, $FutureProvider<Event> {
  FetchEventProvider._({
    required FetchEventFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fetchEventProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchEventHash();

  @override
  String toString() {
    return r'fetchEventProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Event> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Event> create(Ref ref) {
    final argument = this.argument as String;
    return fetchEvent(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEventProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchEventHash() => r'30838dfbcbfa521ffab8ce189f98e436ab1be4d7';

final class FetchEventFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Event>, String> {
  FetchEventFamily._()
    : super(
        retry: null,
        name: r'fetchEventProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FetchEventProvider call(String id) =>
      FetchEventProvider._(argument: id, from: this);

  @override
  String toString() => r'fetchEventProvider';
}
