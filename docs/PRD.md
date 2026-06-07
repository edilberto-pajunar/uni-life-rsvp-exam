# UniLife Flutter Code Test — Feature Specification

## Overview

Build a small **Events** feature consisting of:
1. A lightweight HTTP backend API
2. A Flutter mobile app connected to that backend

---

## 1. Backend API

### Stack
- Any stack is acceptable: Express (Node.js), Firebase Functions, Dart Shelf, etc.
- Storage: in-memory data or a JSON file (no database required)

### Required Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/events` | Return a list of all events |
| `GET` | `/events/:id` | Return a single event by its ID |
| `POST` | `/events/:id/rsvp` | Toggle or set RSVP status for a fake/hardcoded user ID |

### RSVP Logic
- RSVP is per-user per-event (use a fake/hardcoded user ID)
- Toggling means: if the user has already RSVPed, it removes the RSVP; if not, it adds it
- RSVP count must update correctly when RSVPs are added or removed

---

## 2. Flutter App

### Screens Required

#### Event List Screen
- Display all events fetched from `GET /events`
- Handle the following UI states:
  - **Loading** — while fetching data
  - **Error** — if the request fails
  - **Empty** — if no events are returned

#### Event Detail Screen
- Navigated to by tapping an event on the list screen
- Fetches or displays data from `GET /events/:id`
- Contains an **RSVP button** that calls `POST /events/:id/rsvp`
- Must reflect the current RSVP state (toggled on/off) in the UI

---

## 3. Architecture Requirements

- **API client / repository layer** must be kept separate from the UI layer
- **State management**: Use **Riverpod** (preferred)
  - If a different solution is used, document clearly why in the README

---

## 4. Tests

### Unit Tests (minimum 2)
Must cover business logic. Suggested cases:
- A user **cannot RSVP to the same event twice** (toggling behavior)
- **RSVP count updates correctly** when RSVPs are added or removed

### Widget Tests (minimum 1)
Must cover a meaningful UI state, such as:
- Loading state
- Error state
- RSVP toggle reflected in the UI

---

## 5. README

The README.md must include:

1. **How to run the backend** — step-by-step instructions
2. **How to run the Flutter app** — step-by-step instructions
3. **Trade-offs made** — explain decisions and shortcuts taken
4. **What you would improve with more time** — future improvements and known gaps

---

## 6. Submission

- Push to a **public GitHub repository**
- Share the repository link
- If private, invite the team as a collaborator

---

## Feature Checklist

### Backend
- [ ] `GET /events` returns event list
- [ ] `GET /events/:id` returns single event
- [ ] `POST /events/:id/rsvp` toggles RSVP for a fake user
- [ ] In-memory or JSON file storage

### Flutter App
- [ ] Event list screen
- [ ] Event detail screen (tap to navigate)
- [ ] RSVP button on detail screen
- [ ] Loading state handled
- [ ] Error state handled
- [ ] Empty state handled
- [ ] API client / repository layer separated from UI
- [ ] Riverpod used for state management (or alternative documented)

### Tests
- [ ] Unit test: user cannot RSVP same event twice
- [ ] Unit test: RSVP count updates correctly
- [ ] Widget test: meaningful UI state covered

### README
- [ ] Backend run instructions
- [ ] Flutter app run instructions
- [ ] Trade-offs documented
- [ ] Future improvements documented