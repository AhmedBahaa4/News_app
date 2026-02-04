# News App (Flutter + Node.js Backend)

A Flutter news app with Firebase Auth (email/Google/Facebook), bookmarks synced via a Node/Express REST backend + MongoDB, dark mode, onboarding, category search, reader mode, and TL;DR summaries.

## Project Structure

- `lib/` - Flutter app
- `backend/` - Node.js/Express backend (bookmarks/users)

## Flutter: Run (with local secrets)

1) Create `dart_defines.env` (NOT committed). You can copy the template:

```bash
cp dart_defines.example.env dart_defines.env
```

2) Run:

```bash
flutter run --dart-define-from-file=dart_defines.env
```

Build release APK:

```bash
flutter build apk --release --dart-define-from-file=dart_defines.env
```

### Notes

- `BACKEND_BASE_URL` differs by platform:
  - Android emulator: `http://10.0.2.2:5000/api`
  - Web/Windows/Mac/Linux: `http://localhost:5000/api`

## Backend: Run

```bash
cd backend
npm install
cp .env.example .env
npm run dev
```

Backend env:
- `MONGO_URI` (required)
- `PORT` (optional; default 5000)
- `FIREBASE_SERVICE_ACCOUNT` (recommended for deployment) or `FIREBASE_SERVICE_ACCOUNT_PATH` (local)

## Security

- Do NOT commit secrets (`dart_defines.env`, `.env`, Firebase Admin service account JSON).
- If you accidentally pushed a key, rotate it immediately.

