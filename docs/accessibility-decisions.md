# Accessibility Decisions Log (WCAG 2.1 Compliance)

This document tracks the non-obvious technical decisions made in VozClara to satisfy specific Web Content Accessibility Guidelines (WCAG) 2.1 AA criteria.

---

## 1. Perceivable

### Decision: TTS / Screen Reader Coexistence
- **Detail**: When a user triggers the "Speak" action, the app calls `SemanticsService.announce()` followed by a 500ms delay before the actual TTS audio starts.
- **Reasoning**: If TalkBack is active, it will announce the button press. Without the delay, the TalkBack utterance and the TTS phrase would overlap, making both unintelligible.
- **WCAG Mapping**: 
    - **1.4.2 Audio Control**: Provides a way to ensure audio doesn't conflict.
    - **4.1.3 Status Messages**: Uses a semantic announcement to signal the start of an asynchronous audio event.

### Decision: High Contrast Mode (Theme Swap)
- **Detail**: Implementation of a dedicated `HighContrastTheme` that uses pure black (#000000), pure white (#FFFFFF), and high-luminosity yellow (#FFFF00).
- **Reasoning**: Standard "Dark Mode" often uses shades of grey which may not provide enough contrast for users with significant visual impairments.
- **WCAG Mapping**: 
    - **1.4.3 Contrast (Minimum)**: Exceeds the 4.5:1 ratio, often reaching 21:1.
    - **1.4.11 Non-text Contrast**: Ensures UI components like borders and toggles are visible.

---

## 2. Operable

### Decision: 48dp Minimum Touch Targets
- **Detail**: All interactive elements (Category cards, Phrase cards, Switches) enforce a minimum height/width of 48 logical pixels, even if the visible element is smaller.
- **Reasoning**: Users with motor impairments (tremors, limited range of motion) require larger targets to prevent accidental activations.
- **WCAG Mapping**: 
    - **2.5.5 Target Size**: Ensures targets are large enough for comfortable touch interaction.

### Decision: Explicit Header Semantics
- **Detail**: The `_SectionHeader` in Settings and the title in `VozClaraAppBar` are wrapped in `Semantics(header: true)`.
- **Reasoning**: This allows screen reader users to navigate the app by "Headings," significantly speeding up their ability to skip sections.
- **WCAG Mapping**: 
    - **1.3.1 Info and Relationships**: Programmatically determines the structure of the page.
    - **2.4.1 Bypass Blocks**: Allows jumping between sections via heading navigation.

---

## 3. Understandable

### Decision: Semantic Value for Audio Speed
- **Detail**: The Voice Speed slider doesn't just announce a percentage; it maps to descriptive labels ("Lento", "Normal", "Rápido") in its semantic value.
- **Reasoning**: "50%" is abstract for speech rate. Qualitative labels are more understandable for the user's intent.
- **WCAG Mapping**: 
    - **3.3.2 Labels or Instructions**: Provides intuitive feedback for a control.
    - **4.1.2 Name, Role, Value**: Correctly communicates the "Value" of the slider.

### Decision: Character Threshold Announcements
- **Detail**: In the Message Composer, semantic announcements are triggered when the user approaches the character limit (e.g., "50 characters remaining").
- **Reasoning**: A visual counter is often missed by screen reader users. Periodic status updates provide necessary context without being spammy.
- **WCAG Mapping**: 
    - **4.1.3 Status Messages**: Keeps the user informed of their progress without moving focus.

---

## 4. Robust

### Decision: Custom Role Descriptions
- **Detail**: Phrase cards use `Semantics(roleDescription: 'frase comunicable')`.
- **Reasoning**: Standard buttons just say "Botón". Identifying the card as a "communicable phrase" tells the user exactly what will happen if they tap it.
- **WCAG Mapping**: 
    - **4.1.2 Name, Role, Value**: Provides a more accurate "Role" for custom UI components.

### Decision: Live Regions for Async Events
- **Detail**: The `MainShell` contains a `Semantics(liveRegion: true)` widget that listens to the `TtsCubit`.
- **Reasoning**: Ensures that when the system speaks or an error occurs behind the scenes, the screen reader user is notified regardless of where their current focus is.
- **WCAG Mapping**: 
    - **4.1.3 Status Messages**: Leverages live regions to communicate state changes programmatically.
