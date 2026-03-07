# VozClara

A free, offline-capable AAC (Augmentative and Alternative Communication)
companion app built with Flutter. Designed for people with reduced speech
capacity who need a fast, dignified way to communicate.

## Accessibility First

This project is built with WCAG 2.1 AA compliance as a primary requirement,
not an afterthought. Every screen has a documented semantic structure,
and all accessibility decisions are logged in `docs/accessibility-decisions.md`.

## Tech Stack

- Flutter 3.x / Dart 3.x
- Clean Architecture
- Cubit (flutter_bloc)
- GetIt (dependency injection)
- Hive (local persistence)
- flutter_tts (offline text-to-speech)
- GoRouter (navigation)

## Getting Started
```bash
flutter pub get
flutter run
```

No API keys or secrets are required to run this project.
See `.env.example` for future configuration placeholders.

## Project Structure

See `docs/architecture.md` for the full architecture diagram and decisions.

## Accessibility Testing

See `docs/testing-checklist.md` for per-screen accessibility validation results.

## License

This project is licensed under the **Apache License 2.0**.

See the LICENSE file for details.

---

## Author

Miguel Oquendo  
Senior Mobile Engineer – Flutter

LinkedIn:  
https://www.linkedin.com/in/miguel-angel-oquendo-rincon

GitHub:  
https://github.com/MiguelOquendoRincon

---

## Disclaimer

This project is an educational and research initiative focused on building accessible Flutter applications and exploring inclusive design practices.