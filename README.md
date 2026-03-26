# Flutter Object Detection App

Application Flutter de détection d'objets utilisant la caméra et l'apprentissage automatique.

## Description

Cette application mobile permet de capturer des photos avec la caméra et de détecter automatiquement les objets présents dans l'image. L'interface utilisateur est en français pour une meilleure accessibilité.

## Principles de Développement

Ce projet suit une constitution technique stricte définie dans `.specify/memory/constitution.md`. Les principes fondamentaux incluent :

1. **Développement Bilingue** : Interface en français, code en anglais
2. **Architecture Légère** : Simplicité et dépendances minimales
3. **Priorité Performance** : Détection rapide (<2s) et UI réactive (60fps)
4. **Design Camera-First** : Flux utilisateur optimisé pour la capture photo
5. **Bonnes Pratiques Flutter** : Standards officiels Flutter/Dart

## Technologies

- **Framework**: Flutter 3.x (canal stable)
- **Language**: Dart 3.x
- **ML**: TensorFlow Lite (tflite_flutter)
- **Camera**: Plugin camera officiel
- **Plateformes**: Android 7.0+ et iOS 12+

## Structure du Projet

```
lib/
├── screens/       # Écrans UI
├── widgets/       # Widgets réutilisables
├── services/      # Logique métier, caméra, ML
├── models/        # Modèles de données
└── utils/         # Utilitaires, constantes

test/
├── widget_test/   # Tests de widgets
├── integration_test/  # Tests d'intégration
└── unit_test/     # Tests unitaires

assets/
├── models/        # Modèles ML (.tflite)
└── i18n/          # Fichiers de localisation (ARB)
```

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Run analysis
flutter analyze

# Format code
dart format .
```

## Constitution Compliance

All contributions must comply with the project constitution:

- ✅ French UI strings, English code/comments
- ✅ Minimal dependencies, justified abstractions
- ✅ Performance benchmarks met (<2s detection, 60fps UI)
- ✅ `flutter analyze` zero errors
- ✅ `dart format` applied

See `.specify/memory/constitution.md` for complete governance rules.

## License

[TODO: Add license]
