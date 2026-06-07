# UniLife — Events & RSVP

A small **Events** feature: a Flutter mobile app backed by a lightweight HTTP API.
Users browse a list of campus events, open an event for details, and RSVP / cancel their
RSVP. Built against the spec in `[docs/PRD.md](docs/PRD.md)`.

## Stack


| Layer            | Choice                                                                                         |
| ---------------- | ---------------------------------------------------------------------------------------------- |
| Mobile app       | Flutter                                                                                        |
| State management | **Riverpod** (`flutter_riverpod` + `riverpod_annotation` codegen) — the PRD's preferred option |
| Navigation       | `go_router` (auth-gated redirect)                                                              |
| Networking       | `dio` via a shared `ApiClient`                                                                 |
| Auth             | Firebase Auth (email/password)                                                                 |
| Backend          | Firebase Functions + Express (TypeScript)                                                      |
| Storage          | In-memory (no database), per the PRD                                                           |


## API reference

The backend is a single Firebase callable HTTP function (`v1`) that mounts an Express app.
When running in the emulator the base URL is:

```
http://127.0.0.1:5001/uni-life-rsvp-exam/us-central1/v1
```


| Method | Endpoint           | Auth         | Description                                                           |
| ------ | ------------------ | ------------ | --------------------------------------------------------------------- |
| `GET`  | `/health`          | —            | Health check, returns `OK!`                                           |
| `GET`  | `/events`          | Bearer token | List all events (each annotated with `isRsvped` for the current user) |
| `GET`  | `/events/:id`      | —            | Fetch a single event with its attendees                               |
| `POST` | `/events/:id/rsvp` | —            | Set the current user's RSVP state for the event                       |


The RSVP endpoint takes an explicit desired state rather than a blind toggle:

```jsonc
// POST /events/:id/rsvp
{ "rsvp": true }   // confirm RSVP
{ "rsvp": false }  // cancel RSVP
```

The body is validated with Zod. The "current user" is a hardcoded user
(`user-1`, *Alice Tan*) defined in `functions/src/utils/constant.ts`, as the PRD allows a
fake/hardcoded user ID. RSVP add/remove updates `rsvpCount` accordingly and is idempotent —
sending the same desired state twice does not double-count.

> Note: each `events` endpoint deliberately delays ~2s to make the app's loading states
> easy to observe.

## Project structure

```
lib/
  core/            # api client, routing, theme, constants, extensions
    api/           # ApiClient (dio), endpoints, response/exception models
    routes/        # go_router config + auth redirect
  features/
    auth/          # Firebase Auth login / sign-up (data / domain / presentation)
    events/        # the main feature
      data/        # Event model (freezed)
      domain/      # EventRepository (interface) + EventRepositoryImpl
      presentation/# event list (home) + detail page + widgets
      providers/   # Riverpod providers (fetchEvents, fetchEvent, RsvpNotifier)
    home/          # event list screen + app user model
  presentation/    # shared "atom" widgets (buttons, cards, fields, ...)

functions/
  src/
    api.ts         # Express app
    index.ts       # onRequest -> exports `v1`
    middleware/    # requiredAuth (Firebase ID-token verification)
    events/        # /events and /events/:eventId routers + zod schema
    utils/         # in-memory DUMMY_EVENTS / CURRENT_USER

test/
  features/events/ # unit tests for RSVP toggle + count behavior
```

The API/repository layer (`core/api`, `features/events/domain/repository`) is kept fully
separate from the UI layer, per PRD §3.

## How to run the backend

Prerequisites: Node 24, the [Firebase CLI](https://firebase.google.com/docs/cli)
(`npm i -g firebase-tools`).

```bash
git clone <repo-url>
cd uni_life_rsvp_exam/functions
npm install
npm run serve        # builds TypeScript, then starts the Functions emulator
```

This serves the API at:

```
http://127.0.0.1:5001/uni-life-rsvp-exam/us-central1/v1
```

Verify it's up:

```bash
curl http://127.0.0.1:5001/uni-life-rsvp-exam/us-central1/v1/health
# -> OK!
```

Notes:

- `GET /events` is protected by `requiredAuth`, which verifies a Firebase ID token via the
Admin SDK. The app supplies this token automatically once a user is signed in. To call it
directly (e.g. with `curl`) you need a valid Bearer token; `GET /events/:id` and the RSVP
endpoint are open for easy manual testing.
- **Testing without auth:** to hit `GET /events` from `curl`/Postman without a token, remove
the `requiredAuth` middleware from the route in `functions/src/events/router.ts` (change
`eventsRouter.get("/", requiredAuth, ...)` to `eventsRouter.get("/", ...)`) and restart the
emulator. This disables security on that endpoint — only do it for local testing, never in
production.
- Token verification uses the project's Admin credentials. A service-account JSON is present
in the repo for convenience during this exercise — see *Trade-offs* for why that's not how
it should be done in production.

## How to run the Flutter app

Prerequisites: Flutter SDK, an iOS Simulator / Android emulator / Chrome / desktop target.
Start the backend first (above).

```bash
cd uni_life_rsvp_exam
flutter pub get
flutter run
```

Sign up or log in (Firebase Auth), then browse events and RSVP.

> **Android emulator note:** the app points at `127.0.0.1`, which resolves to the host on
> iOS Simulator, desktop, and web. On an Android emulator, `127.0.0.1` is the emulator
> itself — change the host in `lib/core/api/model/endpoints.dart` to `10.0.2.2` to reach the
> backend running on your machine.

### State management

Riverpod is used as preferred by the PRD, with code generation (`riverpod_annotation`).
Event fetching is exposed through `fetchEventsProvider` / `fetchEventProvider`, and RSVP
mutations go through `RsvpNotifier`, which invalidates the affected event provider so the UI
re-reads fresh state. No alternative justification is required.

## Tests

```bash
flutter test
```

Covers the core business logic from the PRD:

- **A user cannot RSVP to the same event twice** — toggling behavior
(`test/features/events/events_provider_test.dart`).
- **RSVP count updates correctly** when an RSVP is added then removed.

Tests use `mockito` to mock the repository and a Riverpod `ProviderContainer` with provider
overrides, so the business logic is exercised without hitting the network.

## Trade-offs

- **Authentication vs. the "fake user" requirement.** The app uses real Firebase Auth (and
`GET /events` verifies the caller's ID token), but the RSVP business logic still keys off a
single hardcoded `CURRENT_USER` server-side, as the PRD permits. The authenticated user's
UID is not yet threaded through to the RSVP write, so every RSVP is attributed to *Alice
Tan*. This kept the RSVP logic simple and spec-aligned while still demonstrating a real auth
flow.
- **In-memory storage.** Events live in an in-memory array (`DUMMY_EVENTS`); state resets when
the emulator restarts. No database, per the PRD.
- **Set-style RSVP, not a blind toggle.** `POST /rsvp` takes `{ "rsvp": true|false }` (the
desired state) rather than flipping server-side. This is idempotent and avoids the client
and server disagreeing about the current state after a dropped response.
- **Artificial latency.** A ~2s delay is left in the events endpoints so the loading states
are visible during review.
- **Rate limiting** middleware is wired up `functions/src/api.ts`.

## What I'd improve with more time

- **Security.** Thread the authenticated UID into the RSVP path instead of the hardcoded user;
add auth to the detail/RSVP endpoints; re-enable rate limiting; and remove the committed
Admin SDK service-account key from version control (use emulator/ADC or env-based secrets).
- **Richer RSVP business rules.** Enforce event capacity, handle waitlists, and define exactly
what "RSVP" means at the edges (e.g. RSVPing to a full or past event).
- **More screens & polish.** Profile, my-RSVPs, search/filter, and finer empty/error states.
- **More tests.** Widget tests for the list loading/error/empty states and the RSVP toggle
reflected in the UI, plus backend endpoint tests for the routers.
- **Persistent storage.** Move events and RSVPs to Firestore so state survives restarts and is
shared across users.
- **Build flavors (`dev` / `prod`).** The API base URL is currently hardcoded in
`lib/core/api/model/endpoints.dart` and there's a single `firebase_options.dart`, so there's
no environment separation. I'd add `dev` and `prod` flavors with per-flavor Firebase projects
/ `firebase_options`, per-flavor API base URLs (local emulator → dev backend → prod), and
distinct app IDs, names, and icons — run via
`flutter run --flavor dev -t lib/main_dev.dart` (and `--flavor prod -t lib/main_prod.dart`).

```

```

