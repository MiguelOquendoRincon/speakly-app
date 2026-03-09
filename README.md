# VozClara

> A free, offline-first AAC (Augmentative and Alternative Communication) companion app built with Flutter, designed for people with reduced or limited speech capacity.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)
![Accessibility](https://img.shields.io/badge/accessibility-WCAG%202.1%20AA-blue)
![CI/CD](https://img.shields.io/badge/CI-GitHub%20Actions-blueviolet?logo=github-actions)
![Test](https://img.shields.io/badge/tests-19%2B-brightgreen)

---

## What is VozClara?

VozClara helps people who have difficulty speaking — due to conditions like ALS, cerebral palsy, aphasia, stroke, or situational mutism — communicate clearly and quickly in everyday situations.

Users can select predefined phrases organized by category, compose custom messages, and have them spoken aloud via text-to-speech. The app works entirely offline and is built with accessibility as a first-class requirement, not an afterthought.

---

## Screenshots

> _Add screenshots here once the UI is complete._

| Home | Phrases | Composer | Settings |
|------|---------|----------|----------|
| _soon_ | _soon_ | _soon_ | _soon_ |

---

## Features

- **Category phrase board** — 6 real-life communication categories: Basic Needs, Health, Emotions, Mobility, Social, and Emergency
- **Quick phrases** — instant access to favorites and recently used phrases
- **Message composer** — free-text input with text-to-speech playback
- **Favorites** — persist preferred phrases across sessions
- **Recent history** — last 20 spoken phrases, always available
- **High contrast mode** — full theme swap for users with visual impairments
- **Reduce motion** — disables animations for users sensitive to movement
- **Voice speed control** — adjustable TTS speech rate
- **Fully offline** — no internet connection required, no API keys

---

## Accessibility

Accessibility is the core purpose of this project. Every screen was designed against explicit WCAG 2.1 AA criteria before implementation began.

### Standards applied

| Criterion | Description |
|-----------|-------------|
| 1.1.1 Non-text Content | All icons and images have semantic labels or are excluded from the accessibility tree if decorative |
| 1.3.1 Info and Relationships | Section headers, buttons, and interactive elements declare their roles explicitly |
| 1.4.1 Use of Color | State (favorites, active, emergency) is never conveyed by color alone — shape and weight changes accompany color |
| 1.4.3 Contrast Minimum | All color token pairs are documented with their contrast ratio (≥ 4.5:1 normal text, ≥ 3:1 large text) |
| 1.4.4 Resize Text | All text scales correctly up to 200% system font size without clipping or overflow |
| 2.4.3 Focus Order | Logical focus traversal is verified per screen with the Flutter Semantics Debugger |
| 2.5.5 Target Size | All interactive elements enforce a minimum 48×48dp touch target; primary navigation cards use 100dp+ |
| 3.3.2 Labels or Instructions | Text inputs use persistent visible labels, never placeholder text alone |
| 4.1.2 Name, Role, Value | Every interactive element declares its accessible name, role, and current state |

### Screen reader support

- **Android TalkBack** — fully tested. Focus order, labels, hints, and state announcements validated per screen.
- **iOS VoiceOver** — supported via Flutter's native semantics bridge.

### TalkBack / TTS coexistence

When TTS playback is triggered while TalkBack is active, VozClara uses `SemanticsService.announce()` before speaking to signal TalkBack to yield the audio channel. A short delay ensures TalkBack finishes its current utterance before TTS takes AudioFocus. This prevents audio overlap and ensures the spoken content is also delivered to screen reader users who may not hear the TTS output directly.

### Accessibility decisions log

All non-obvious accessibility decisions are documented with the WCAG criterion they satisfy in [`docs/accessibility-decisions.md`](docs/accessibility-decisions.md).

---

## Architecture

VozClara follows **Clean Architecture** with a feature-first folder structure.

```
lib/
├── app/              # App entry, router, service locator
├── core/             # Constants, theme, accessibility utilities
│   ├── accessibility/    # Semantic labels (centralized, testable)
│   ├── constants/        # Colors (with contrast ratios), dimensions, typography
│   └── theme/            # Default and high contrast themes
├── features/         # One folder per feature
│   ├── categories/       # Home grid
│   ├── phrases/          # Category detail + TTS cubit
│   ├── free_text/        # Message composer
│   ├── favorites/        # Quick phrases screen
│   └── settings/         # Accessibility preferences
└── shared/           # Reusable widgets and services
    ├── widgets/          # AccessibleButton, PhraseCard, SpeakButton
    └── services/         # TtsService
```

Each feature is divided into three layers:

- **Domain** — entities, repository contracts, use cases. No Flutter dependencies.
- **Data** — repository implementations, static data sources, Hive persistence.
- **Presentation** — Cubit + State, pages, widgets.

### State management

[Cubit](https://pub.dev/packages/flutter_bloc) (from the `flutter_bloc` package). Chosen over full Bloc because all state transitions here are discrete commands, not event streams.

| Cubit | Responsibility |
|-------|---------------|
| `SettingsCubit` | High contrast, reduce motion, TTS speech rate |
| `PhrasesCubit` | Phrase list for a category + favorite toggles |
| `TtsCubit` | App-wide TTS playback state (singleton) |
| `QuickPhrasesCubit` | Favorites + recent history aggregation |

`TtsCubit` is registered as a lazy singleton in GetIt because TTS is a device-level resource — only one instance should manage playback state across the entire app.

---

## Tech stack

| Dependency | Purpose |
|------------|---------|
| [flutter_bloc](https://pub.dev/packages/flutter_bloc) | State management (Cubit) |
| [get_it](https://pub.dev/packages/get_it) | Dependency injection |
| [go_router](https://pub.dev/packages/go_router) | Navigation |
| [hive_flutter](https://pub.dev/packages/hive_flutter) | Local persistence (favorites, history) |
| [flutter_tts](https://pub.dev/packages/flutter_tts) | Offline text-to-speech |
| [equatable](https://pub.dev/packages/equatable) | Value equality for Cubit states |

No network dependencies. No API keys required.

---

## Getting started

### Prerequisites

- Flutter 3.x
- Dart 3.x
- Android or iOS device/emulator with a TTS engine installed

> **Android emulator note:** The emulator ships without a TTS engine by default. Go to **Settings → General Management → Text-to-speech** and install Google Text-to-Speech before running the app, or test on a physical device.

### Run

```bash
git clone https://github.com/MiguelOquendoRincon/speakly-app.git
cd voz_clara
flutter pub get
flutter run
```

No `.env` file or API keys needed. See `.env.example` for future configuration placeholders.

---

## Testing

### Automated

Unit tests cover state managers (Cubits), repository logic, and data persistence:

```bash
# Run all tests
flutter test

# Run specific feature tests
flutter test test/features/phrases
flutter test test/features/settings
flutter test test/features/free_text
```

Widget tests cover semantic tree structure and touch target compliance using Flutter's built-in accessibility guidelines:

```dart
expect(tester, meetsGuideline(androidTapTargetGuideline));
expect(tester, meetsGuideline(labeledTapTargetGuideline));
expect(tester, meetsGuideline(textContrastGuideline));
```

### Continuous Integration

This project uses **GitHub Actions** for CI. Every push and pull request triggers a pipeline that performs:
- **Dependency Cache**: Speeds up runs by caching Flutter SDK and Pub packages.
- **Code Format**: Verifies strict adherence to Dart's style guide via `dart format`.
- **Static Analysis**: Detects errors and warnings using `flutter analyze`.
- **Test Suite**: Executing full unit and widget test suites.

Workflow configuration can be found in [`.github/workflows/ci.yml`](.github/workflows/ci.yml).

### Manual accessibility testing

See [`docs/testing-checklist.md`](docs/testing-checklist.md) for the full per-screen checklist covering:

- TalkBack and VoiceOver navigation
- Focus traversal order
- Semantic label and hint accuracy
- Touch target sizes
- Text scaling at 150% and 200%
- Color contrast
- High contrast mode

---

## Project structure reference

```
voz_clara/
├── .github/workflows/ # CI Pipeline definitions
├── lib/               # App code (Clean Architecture)
├── test/              # Test suites
│   ├── features/      # Unit and Widget tests per feature
│   └── shared/        # Shared component tests
├── docs/              # Detailed accessibility documentation
├── .env.example       # Environment configuration stub
└── README.md
```

---

## Roadmap

- [x] Phase 1 — Accessibility decisions & WCAG mapping
- [x] Phase 2 — Architecture base, theme system, DI
- [x] Phase 3 — Accessible UI (all screens)
- [x] Phase 4 — TTS integration, Cubit layer, phrase data
- [x] Phase 5 — Accessibility testing suite
- [x] Phase 6 — Documentation polish & public repo finalization
- [ ] Future — Custom phrase creation
- [ ] Future — Symbol/pictogram support
- [ ] Future — Multi-language support
- [ ] Future — Switch access (advanced motor accessibility)

---

## Acknowledgements

Built as a portfolio project to demonstrate deep accessibility knowledge in Flutter — specifically WCAG 2.1 implementation, semantic UI, screen reader compatibility, and accessibility testing. Designed to also be genuinely useful to the people it serves.

## License

This project is licensed under the **Apache License 2.0**.

See the LICENSE file for details.

---

## Author

Miguel Oquendo  
Senior Mobile | Cloud Engineer – Flutter

[LinkedIn](https://www.linkedin.com/in/miguel-angel-oquendo-rincon) - [GitHub](https://github.com/MiguelOquendoRincon)

---

## Disclaimer

This project is an educational and research initiative focused on building accessible Flutter applications and exploring inclusive design practices.