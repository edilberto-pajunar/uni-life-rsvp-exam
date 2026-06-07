# UniLife RSVP — Data Models & API Contract

This document defines the **data types** for the Events + RSVP feature. It is the single
source of truth shared between the **backend** and the **Flutter app**, and the foundation
the rest of the app is built on. See [`PRD.md`](./PRD.md) for the feature requirements.

> **Spec only** — no implementation code lives here. The Flutter models (Freezed) and the
> backend storage are written against this contract in later steps.

---

## 1. Conventions

- **JSON casing: `camelCase`** for every field (`startTime`, `rsvpCount`, `isRsvped`). This
  maps 1:1 to Dart field names, so `fromJson` / `toJson` need no key remapping.
- **Dates: ISO-8601 strings** in JSON (e.g. `"2026-06-20T18:30:00Z"`), parsed into Dart
  `DateTime`.
- **IDs: `String`**. Stable and opaque on both sides.
- **The contract is symmetric**: backend JSON ⇄ Flutter model must always match. If a field
  is added/renamed here, both sides change together.

---

## 2. Core Entities

### 2.1 `Event`

The central entity. The per-user fields (`rsvpCount`, `isRsvped`) are **resolved server-side
for the hardcoded user** and embedded directly on the event, so the Flutter UI can render
everything without a second lookup.

`Event` has **two variants of the same shape**:

- **List item** (`GET /events`) — all fields below **except** `attendees`. Lightweight, for
  the list screen.
- **Detail** (`GET /events/:id` and the RSVP toggle response) — all fields **plus**
  `attendees`, the users who have RSVPed, for the detail screen.

| Field         | Type         | Nullable | Description                                                        |
|---------------|--------------|----------|--------------------------------------------------------------------|
| `id`          | `String`     | no       | Unique event identifier.                                           |
| `title`       | `String`     | no       | Event name shown in the list and detail header.                    |
| `description` | `String`     | no       | Longer text shown on the detail screen.                           |
| `location`    | `String`     | no       | Where the event takes place.                                       |
| `startTime`   | `String`     | no       | ISO-8601 datetime. Parsed to `DateTime` in Dart.                  |
| `capacity`    | `int`        | **yes**  | Max attendees. `null` = unlimited.                                |
| `rsvpCount`   | `int`        | no       | Derived: number of users currently RSVPed. Updates on toggle.     |
| `isRsvped`    | `bool`       | no       | Derived: whether the **current (hardcoded) user** has RSVPed.     |
| `attendees`   | `List<User>` | no       | **Detail only.** The users who have RSVPed (see §2.2). Omitted / empty `[]` on list items. Length equals `rsvpCount`. |

**Example JSON — list item** (`GET /events`, no `attendees`)

```json
{
  "id": "evt-001",
  "title": "Welcome Mixer",
  "description": "Meet other students over snacks and music.",
  "location": "Student Union, Room 204",
  "startTime": "2026-06-20T18:30:00Z",
  "capacity": 100,
  "rsvpCount": 42,
  "isRsvped": true
}
```

**Example JSON — detail** (`GET /events/:id`, includes `attendees`)

```json
{
  "id": "evt-001",
  "title": "Welcome Mixer",
  "description": "Meet other students over snacks and music.",
  "location": "Student Union, Room 204",
  "startTime": "2026-06-20T18:30:00Z",
  "capacity": 100,
  "rsvpCount": 3,
  "isRsvped": true,
  "attendees": [
    { "id": "user-123", "name": "Alex Rivera", "email": "alex@uni.edu" },
    { "id": "user-456", "name": "Sam Cruz", "email": "sam@uni.edu" },
    { "id": "user-789", "name": "Jordan Lee", "email": "jordan@uni.edu" }
  ]
}
```

### 2.2 `User`

Represents a person who can RSVP. Auth is out of scope per the PRD: the **current user is a
single hardcoded ID** (e.g. `"user-123"`) the backend assumes on every request. But to show
*who* RSVPed on the detail screen, the backend also seeds a small set of other users so the
attendee list has distinct, realistic names and emails.

| Field   | Type     | Nullable | Description                                          |
|---------|----------|----------|------------------------------------------------------|
| `id`    | `String` | no       | Unique user identifier, e.g. `"user-123"`.          |
| `name`  | `String` | no       | Display name shown in the attendee list.            |
| `email` | `String` | no       | Contact email, also shown/usable in the attendee list.|

**Example JSON**

```json
{ "id": "user-123", "name": "Alex Rivera", "email": "alex@uni.edu" }
```

> The current user is never sent in requests in this exam — the backend assumes the
> hardcoded ID. `User` objects appear in the API only inside an event's `attendees` array.

### 2.3 `Rsvp` (backend record)

An internal backend record representing **one user RSVPed to one event**. It is *not*
returned directly by the API; it is the storage primitive from which `rsvpCount` and
`isRsvped` are derived. The pair `(eventId, userId)` is unique — its **presence means
RSVPed**, its absence means not.

| Field       | Type     | Nullable | Description                                  |
|-------------|----------|----------|----------------------------------------------|
| `eventId`   | `String` | no       | The event being RSVPed to.                   |
| `userId`    | `String` | no       | The user who RSVPed (hardcoded user).        |
| `createdAt` | `String` | yes      | ISO-8601 timestamp of when the RSVP was made.|

---

## 3. Backend Storage Shape

In-memory (or a JSON file) per the PRD — no database. Three collections:

| Collection | Shape                              | Purpose                                          |
|------------|------------------------------------|--------------------------------------------------|
| `events`   | `List<Event>` *without* the derived fields (`rsvpCount`, `isRsvped`, `attendees`) | The raw catalogue of events. |
| `users`    | `List<User>` (`id, name, email`)   | All known users, incl. the hardcoded current user. Looked up to build `attendees`. |
| `rsvps`    | Set/list of `{ eventId, userId }`  | Source of truth for who RSVPed to what.          |

**Derivation rules** (applied when serializing an event for the API):

- `rsvpCount(event)` = number of entries in `rsvps` where `entry.eventId == event.id`.
- `isRsvped(event)` = whether `rsvps` contains `{ event.id, currentUserId }`.
- `attendees(event)` *(detail only)* = for each `rsvp` with `rsvp.eventId == event.id`,
  the matching `User` from `users` by `rsvp.userId` — i.e. a **join of `rsvps` → `users`**.
  By construction `attendees.length == rsvpCount`.

Keeping RSVPs as a separate set (rather than a counter on the event) is what makes the
**toggle** correct and idempotent, and it directly supports the required unit tests
(no double RSVP, count updates correctly).

---

## 4. API Contract

Base: the backend host (e.g. `http://localhost:3000`). All responses are JSON.

### 4.1 `GET /events` — list all events

- **Response `200`**: array of `Event` objects, each with `rsvpCount` / `isRsvped` already
  resolved for the hardcoded user.

```json
[
  {
    "id": "evt-001",
    "title": "Welcome Mixer",
    "description": "Meet other students over snacks and music.",
    "location": "Student Union, Room 204",
    "startTime": "2026-06-20T18:30:00Z",
    "capacity": 100,
    "rsvpCount": 42,
    "isRsvped": true
  }
]
```

An empty catalogue returns `[]` (drives the app's **empty** state).

### 4.2 `GET /events/:id` — single event

- **Response `200`**: one **detail** `Event` object — the list-item fields **plus** the
  `attendees` array (the users who RSVPed, via the `rsvps → users` join).
- **Response `404`**: unknown id → error object (see §4.4).

```json
{
  "id": "evt-001",
  "title": "Welcome Mixer",
  "description": "Meet other students over snacks and music.",
  "location": "Student Union, Room 204",
  "startTime": "2026-06-20T18:30:00Z",
  "capacity": 100,
  "rsvpCount": 3,
  "isRsvped": true,
  "attendees": [
    { "id": "user-123", "name": "Alex Rivera", "email": "alex@uni.edu" },
    { "id": "user-456", "name": "Sam Cruz", "email": "sam@uni.edu" },
    { "id": "user-789", "name": "Jordan Lee", "email": "jordan@uni.edu" }
  ]
}
```

The detail screen renders this `attendees` array as the "Who's going" list. If no one has
RSVPed, `attendees` is `[]` and `rsvpCount` is `0`.

### 4.3 `POST /events/:id/rsvp` — toggle RSVP

Toggles the hardcoded user's RSVP for the event:

- If `{ eventId, userId }` exists in `rsvps` → **remove** it (un-RSVP).
- If it does not exist → **add** it (RSVP).

No request body is required (the user is the hardcoded ID).

- **Response `200`**: the **full updated detail `Event`** — same shape as `GET /events/:id`,
  with `isRsvped`, `rsvpCount`, and `attendees` all refreshed to reflect the toggle. The
  detail screen replaces its cached event directly, so the button **and** the attendee list
  update with no extra fetch.

```json
{
  "id": "evt-001",
  "title": "Welcome Mixer",
  "description": "Meet other students over snacks and music.",
  "location": "Student Union, Room 204",
  "startTime": "2026-06-20T18:30:00Z",
  "capacity": 100,
  "rsvpCount": 2,
  "isRsvped": false,
  "attendees": [
    { "id": "user-456", "name": "Sam Cruz", "email": "sam@uni.edu" },
    { "id": "user-789", "name": "Jordan Lee", "email": "jordan@uni.edu" }
  ]
}
```

*(Example shows the current user `user-123` having just toggled **off** — they're gone from
`attendees`, `isRsvped` is now `false`, and `rsvpCount` dropped from 3 to 2.)*

- **Response `404`**: unknown id → error object.

> **Fallback:** if you prefer a lighter response, return the minimal subset
> `{ "eventId", "isRsvped", "rsvpCount" }` instead — but then the detail screen must refetch
> `GET /events/:id` to refresh the attendee list. The full-event response avoids that.

### 4.4 Error shape

All error responses use:

```json
{ "error": "Event not found" }
```

| Status | When                                  |
|--------|---------------------------------------|
| `404`  | Event id does not exist.              |
| `400`  | Malformed request.                    |
| `500`  | Unexpected server error.              |

---

## 5. Flutter Domain Models

Models live under the events feature (e.g. `lib/features/events/...`) and are implemented as
**Freezed** classes with generated `fromJson` / `toJson` mirroring the JSON above.

- **`User`** — a Freezed model with `id`, `name`, `email`, used for attendee entries.
- **`Event`** — mirrors §2.1, with `rsvpCount` and `isRsvped` embedded plus an
  `attendees: List<User>` that **defaults to `[]`** (empty for list items, populated on
  detail). `startTime` is exposed as a `DateTime`; `capacity` is nullable. The single model
  serves both the list and detail variants — list items simply have an empty `attendees`.
- **Toggle response** — reuse the `Event` model directly (the backend returns the full
  updated detail event).

**Value equality matters.** Freezed (and Equatable) give value-based `==`, so an `Event`
with an updated `rsvpCount` / `isRsvped` is treated as a *different* value than the old one.
This is what lets the unit tests assert that toggling changed the count and the flag, and it
makes Riverpod state updates rebuild the UI correctly.

---

## 6. UI State Types

The PRD requires four states for the list (and analogous states for the detail screen):
**loading**, **error**, **empty**, **data**.

These map cleanly onto Riverpod's built-in **`AsyncValue<T>`**, so no custom sealed type is
needed:

| PRD state | Representation                                                        |
|-----------|----------------------------------------------------------------------|
| Loading   | `AsyncValue.loading()`                                                |
| Error     | `AsyncValue.error(err, stack)`                                        |
| Data      | `AsyncValue.data(value)`                                              |
| Empty     | `AsyncValue.data` where the list is empty (a sub-case of data) — the UI checks `events.isEmpty`. |

- **List screen** consumes `AsyncValue<List<Event>>`.
- **Detail screen** consumes `AsyncValue<Event>`; the RSVP button reflects `event.isRsvped`
  and shows `event.rsvpCount`, optimistically or after the toggle response.

---

## 7. Quick Reference

| Type            | Where it lives        | Key fields                                                    |
|-----------------|-----------------------|--------------------------------------------------------------|
| `Event`         | API + Flutter model   | `id, title, description, location, startTime, capacity, rsvpCount, isRsvped, attendees` (attendees detail-only) |
| `User`          | API (in `attendees`) + Flutter model | `id, name, email`                            |
| `Rsvp`          | Backend storage only  | `eventId, userId, createdAt?`                                |
| Toggle response | API                   | full detail `Event` (refreshed `isRsvped`, `rsvpCount`, `attendees`) |
| Error           | API                   | `{ error }`                                                  |
| UI state        | Flutter (Riverpod)    | `AsyncValue<List<Event>>`, `AsyncValue<Event>`              |
