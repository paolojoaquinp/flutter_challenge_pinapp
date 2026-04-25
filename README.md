# flutter_challenge_pinapp

A production-ready Flutter movies application challenge.

## 🚀 Getting Started

To get the project running locally, follow these steps:

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (check `pubspec.yaml` for version)
- [Firebase CLI](https://firebase.google.com/docs/cli) (optional, if you want to modify Firebase)

### 2. Environment Configuration

This project uses `.env` files for TMDB API credentials.

1. Copy the example file:
   ```bash
   cp .env.example .env
   ```
2. Open `.env` and replace `your_v4_read_access_token_here` with your real Read Access Token from [TMDB Settings](https://www.themoviedb.org/settings/api).

### 3. Firebase Configuration

Firebase configuration files are included in the repository for a "clone and run" experience:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

> **Note:** These are public client configuration files. Access is further secured via API key restrictions in the Google Cloud Console.

### 4. Run the App

```bash
flutter pub get
flutter run
```

---

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
