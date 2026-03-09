# Accessibility Testing Checklist

This document provides a comprehensive checklist for manual accessibility testing of VozClara. Every release should be validated against these criteria to ensure compliance with WCAG 2.1 AA and a premium experience for assistive technology users.

---

## 1. Screen Reader Compatibility (TalkBack/VoiceOver)

### General Navigation
- [ ] **Linear Navigation**: Can you navigate through all interactive elements using swipe gestures?
- [ ] **Grouping**: Are related elements (like an icon and text within a card) grouped into a single focusable unit?
- [ ] **Exploration by Touch**: Does touching an element provide immediate and accurate audio feedback?
- [ ] **State Announcements**: Does the screen reader announce when a phrase is "Selected" or "Favorited"?
- [ ] **Live Regions**: When TTS playback starts or finishes, is an announcement made to the screen reader?

### Focus Traversal Order
- [ ] **Logical Flow**: Does the focus move from top-to-bottom and left-to-right?
- [ ] **Predictability**: After performing an action (like closing a category), does the focus return to a logical point?
- [ ] **Modal Handling**: When a dialog or drawer is open, is the focus trapped within the modal?
- [ ] **Skip Links**: (If applicable) Is there a way to skip repetitive navigation to reach main content?

---

## 2. Semantic Content

### Labels and Hints
- [ ] **Descriptive Labels**: Every button has a label that describes its *action* (e.g., "Reproducir frase" instead of just "Botón").
- [ ] **No Redundancy**: Labels do not include the word "botón" or "imagen" (TalkBack adds this automatically).
- [ ] **Hints**: Complex actions have hints (e.g., "Doble toque para eliminar de favoritos").
- [ ] **Value Declaration**: Sliders (like Voice Speed) announce their current percentage or value.

### Landmarks and Headers
- [ ] **Headers**: Heading elements (like category names) are explicitly marked as `header: true` in Semantics.
- [ ] **Empty States**: When a list is empty (e.g., History), is there a clear semantic announcement?

---

## 3. Visual and Touch Interactions

### Touch Target Sizes
- [ ] **48x48dp Minimum**: All interactive elements meet the minimum physical size of 48x48 logical pixels.
- [ ] **Spacing**: Interactive elements are sufficiently spaced to prevent accidental activations.
- [ ] **Expansion**: If a visual element is small, is its `hitTest` area expanded using `HitTestBehavior` or `Padding`?

### Text Scaling (Reflow)
- [ ] **150% Scale**: System font at 150% shows no text clipping or overlapping.
- [ ] **200% Scale**: System font at 200% correctly wraps text and expands containers without breaking the layout.
- [ ] **Icon Scaling**: Icons remain aligned and visible when text size increases.

---

## 4. Color and Contrast

### Standard Mode
- [ ] **Minimum Contrast**: Normal text has a contrast ratio of at least 4.5:1 against its background.
- [ ] **Large Text**: Large text (18pt+ or 14pt bold+) has a contrast ratio of at least 3:1.
- [ ] **UI Components**: Borders and dividers have at least 3:1 contrast to ensure visibility.

### High Contrast Mode
- [ ] **Theme Swap**: High Contrast mode correctly replaces the entire color palette.
- [ ] **Pure Colors**: Backgrounds use true black/white and primary actions use high-luminance colors (e.g., bright yellow/cyan).
- [ ] **Interactive States**: Focus indicators and active toggles are extremely distinct.

---

## 5. Per-Screen Specific Checks

### Home (Categories)
- [ ] Category cards announce as a single unit or have clear internal focus.
- [ ] "Emergency" category has a distinct semantic "Alert" or "Emergency" label accompaniment.

### Phrase Detail
- [ ] Tapping a phrase announces the text and its favorite state.
- [ ] The "Speak" button is the primary focal point.
- [ ] Back button in the app bar is correctly labeled.

### Message Composer (Free Text)
- [ ] Text field has a persistent visible label.
- [ ] Character count is announced correctly as the user types (if applicable).
- [ ] "Clear" button is accessible and confirms deletion semantically.

### Settings
- [ ] Voice Speed slider provides real-time value feedback to the screen reader.
- [ ] Toggles (Switch) clearly announce their "On/Off" or "Checked/Unchecked" state.
- [ ] "Test Voice" button announces when the test speech begins.

---

## 6. Audio Coexistence
- [ ] **Audio Focus**: When VozClara speaks, does it correctly duck or pause other media?
- [ ] **TalkBack yielding**: If TalkBack is speaking, does the app's TTS wait or send a clear announcement first?
- [ ] **Stop Action**: Does the "Stop" button immediately kill all audio output?
