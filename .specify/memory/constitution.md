<!--
  ============================================================================
  SYNC IMPACT REPORT - Constitution Update
  ============================================================================
  
  Version Change: [Template] → 1.0.0 (Initial ratification)
  
  Principles Defined:
  - I. Bilingual Development (NEW) - French UI, English code/comments
  - II. Lightweight Architecture (NEW) - Simple, minimal dependencies
  - III. Performance Priority (NEW) - Fast detection speed mandatory
  - IV. Camera-First Design (NEW) - Photo capture workflow
  - V. Flutter Best Practices (NEW) - Cross-platform mobile standards
  
  Templates Requiring Updates:
  - ✅ .specify/templates/plan-template.md - Updated Technical Context
  - ✅ .specify/templates/spec-template.md - Added French UI requirement notes
  - ✅ .specify/templates/tasks-template.md - Added performance validation tasks
  
  Follow-up TODOs: None
  
  ============================================================================
-->

# Flutter Object Detection Constitution

## Core Principles

### I. Bilingual Development (NON-NEGOTIABLE)

**Rule**: All user-facing text, labels, messages, and UI elements MUST be in French. All code identifiers (variables, functions, classes, files), comments, documentation, and commit messages MUST be in English.

**Rationale**: This ensures accessibility for French-speaking end users while maintaining international collaboration standards in the codebase. Code readability and maintainability benefit from English consistency with the global developer community and Flutter/Dart ecosystem.

**Application**:
- Widget labels, buttons, error messages, tooltips → French
- Variable names, function names, class names → English
- Code comments and README documentation → English
- User-facing help text and instructions → French

### II. Lightweight Architecture (NON-NEGOTIABLE)

**Rule**: The application MUST maintain a simple, flat architecture with minimal abstraction layers. Dependencies MUST be justified and kept to the absolute minimum required for core functionality (camera, ML model, UI).

**Rationale**: Lightweight architecture reduces APK/IPA size, decreases build times, minimizes memory footprint, and accelerates both development velocity and runtime performance. Complexity is the enemy of speed.

**Application**:
- Avoid over-engineered patterns (no unnecessary repositories, factories, or dependency injection frameworks)
- Direct service calls over multi-layer architectures
- Minimal third-party packages - each dependency must justify its inclusion
- Flat directory structure: `lib/screens/`, `lib/services/`, `lib/models/`

### III. Performance Priority (NON-NEGOTIABLE)

**Rule**: Object detection speed is the primary quality attribute. Detection latency MUST be <2 seconds from photo capture to results display. UI MUST remain responsive during detection (60fps).

**Rationale**: Real-time responsiveness is critical for user experience in computer vision applications. Users expect instant feedback when capturing and analyzing images.

**Application**:
- Use async/await with proper isolates for ML inference to prevent UI blocking
- Optimize image preprocessing (resize, format conversion) before detection
- Benchmark detection latency in integration tests
- Profile memory usage to prevent leaks during repeated detections
- Lazy-load ML models to reduce startup time

### IV. Camera-First Design

**Rule**: The camera capture workflow MUST be the primary user interaction path. The app MUST request camera permissions on first launch and guide users through the capture → detect → results flow with clear French instructions.

**Rationale**: The core value proposition is real-time object detection from photos. The UX must optimize for this primary use case with minimal friction.

**Application**:
- Camera screen as default home screen or primary action
- Single-tap capture with immediate detection trigger
- Clear visual feedback during capture and processing states
- Handle permission denials gracefully with French guidance
- Support photo preview before detection confirmation

### V. Flutter Best Practices

**Rule**: Code MUST follow official Flutter and Dart guidelines including effective-dart style, widget composition over inheritance, stateless widgets by default, and proper state management (Provider or Riverpod for complexity).

**Rationale**: Consistency with Flutter conventions ensures maintainability, eases onboarding, and leverages ecosystem tooling (linters, formatters, IDEs).

**Application**:
- Run `dart format` and `flutter analyze` before commits
- Prefer composition: small, focused widgets over monolithic widget trees
- Use `const` constructors wherever possible for performance
- Immutable state models with copyWith patterns
- Proper null-safety throughout

## Technology Constraints

**Platform**: Flutter 3.x (stable channel) targeting Android 7.0+ and iOS 12+

**Object Detection**: Use TensorFlow Lite Flutter plugin (`tflite_flutter`) with a pre-trained lightweight model (e.g., MobileNet SSD, EfficientDet-Lite). Model size MUST NOT exceed 10MB.

**Camera**: Use `camera` plugin (official Flutter package). Fallback to `image_picker` for devices with camera issues.

**Localization**: French strings managed via ARB files (`intl` package) even if only one language currently supported (enables future expansion).

**Testing**: Widget tests for UI, integration tests for camera → detection flow. Unit tests for image preprocessing and result parsing logic.

## Development Workflow

**Branching**: Feature branches from `main`. Branch naming: `feature/[description-in-english]`

**Commits**: Conventional commits format in English (e.g., `feat: add camera capture screen`, `fix: detection timeout handling`)

**Code Review**: All changes require:
- Verification against bilingual principle (French UI / English code)
- Performance check: No blocking operations on UI thread
- Architecture simplicity check: No unnecessary abstractions added

**Quality Gates**:
- `flutter analyze` with zero errors
- `dart format` applied
- All tests passing
- Detection latency <2s verified manually or via benchmark

## Governance

**Authority**: This constitution supersedes all other coding practices and style preferences. When conflicts arise between developer preference and constitutional principles, the constitution wins.

**Amendment Process**:
1. Propose amendment with rationale in a GitHub issue or team discussion
2. Document impact on existing code and templates
3. Increment version according to semantic versioning (MAJOR for breaking governance changes, MINOR for new principles, PATCH for clarifications)
4. Update dependent templates in `.specify/templates/` to reflect changes
5. Commit with message: `docs: amend constitution to vX.Y.Z ([summary])`

**Compliance Review**: During code reviews, explicitly verify:
- [ ] Bilingual principle (French UI, English code)
- [ ] No unnecessary dependencies or abstractions added
- [ ] Performance impact assessed (detection latency, UI responsiveness)
- [ ] Camera workflow clarity maintained

**Versioning Policy**: Constitution version follows semantic versioning:
- **MAJOR**: Backward-incompatible changes to core principles (e.g., removing a principle, changing architectural paradigm)
- **MINOR**: Adding new principles or materially expanding guidance
- **PATCH**: Clarifications, wording improvements, typo fixes

**Version**: 1.0.0 | **Ratified**: 2025-01-21 | **Last Amended**: 2025-01-21
