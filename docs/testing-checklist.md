# Manual Accessibility Testing Checklist

This checklist is designed to ensure that VozClara meets WCAG 2.1 AA standards and provides a premium experience for users of assistive technologies.

---

## Global Requirements

| Category | Requirement | Verified |
| :--- | :--- | :---: |
| **Touch Targets** | All interactive elements are at least 48x48dp. | [ ] |
| **Text Scaling** | Layout remains functional and readable at 150% and 200% system font size. | [ ] |
| **Contrast** | Standard text has 4.5:1 contrast; large text has 3:1. | [ ] |
| **Semantics** | Every interactive element has a unique, descriptive label. | [ ] |
| **Motion** | Animations are suppressed when the "Reduce Motion" setting is active. | [ ] |

---

## Per-Screen Checklist

### 1. Home Page (Categories)
- [ ] **TalkBack/VoiceOver**: Each category card is focusable as a single semantic unit (Icon + Text).
- [ ] **Focus Order**: Header "VozClara" -> Categories (Grid order) -> Navigation Bar.
- [ ] **Labels**: Emergency category is clearly identified semantically as a priority item.
- [ ] **High Contrast**: Icons and text are sharp and distinct on the high-contrast background.
- [ ] **Text Scaling**: Long category names wrap correctly without overlapping adjacent cards at 200%.

### 2. Phrases Page (Category Detail)
- [ ] **TalkBack/VoiceOver**: Clicking a phrase card announces: "[Phrase Text], [Favorite State]".
- [ ] **Focus Order**: Back button -> Category Title -> Phrase Cards -> Navigation Bar.
- [ ] **Hints**: Favorite star button has a hint: "Doble toque para cambiar favoritos".
- [ ] **Audio Focus**: TTS playback ducks system volume or pauses screen reader output.
- [ ] **Live Regions**: Screen reader announces "Reproduciendo..." when the speak action starts.

### 3. Message Composer (Free Text)
- [ ] **TalkBack/VoiceOver**: The text input field has a clearly announced label.
- [ ] **Focus Order**: Back button -> "Escribir" Title -> Text Input -> Clear Button -> Speak Button.
- [ ] **Status Announcements**: Character count (if displayed) is announced at meaningful intervals (e.g., every 50 chars).
- [ ] **Touch Targets**: The "Clear" (X) button inside the field is easy to hit (min 48dp target).
- [ ] **High Contrast**: Cursor and selection handles are clearly visible.

### 4. Favorites & History
- [ ] **TalkBack/VoiceOver**: Empty states are announced: "No tienes favoritos guardados aún".
- [ ] **Focus Order**: Tab Selection (Favorites/History) -> List items.
- [ ] **Labels**: History items announce the text and potentially the time/date spoken.
- [ ] **Scaling**: Long phrases in the list wrap to multiple lines without clipping.

### 5. Settings Page
- [ ] **TalkBack/VoiceOver**: Switches announce their state clearly: "Modo alto contraste, desactivado, interruptor".
- [ ] **Slider Control**: Voice Speed slider allows granular control via screen reader volume/swipe keys.
- [ ] **Focus Traversal**: Logical flow through Visual Preferences -> Audio Preferences.
- [ ] **Visual Feedback**: The "Test Voice" button provides both visual (color change) and audio feedback.
- [ ] **High Contrast**: Ensure the checkmarks/toggles are clearly distinguishable in High Contrast mode.

---

## Coexistence Rules (TalkBack + TTS)
- [ ] **Yielding**: The app calls `SemanticsService.announce()` before starting TTS to "warn" the screen reader.
- [ ] **Delay**: A 500ms delay is implemented to allow TalkBack to finish its announcement of the button press before the main TTS content begins.
- [ ] **Clearance**: Audio session is correctly released when playback stops.

---

## Testing Environment
- **Device**: ________________________
- **OS Version**: ____________________
- **Date**: __________________________
- **Tester**: ________________________
