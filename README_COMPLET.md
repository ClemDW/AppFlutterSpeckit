# Application Flutter de Détection d'Objets 📸

Application mobile de détection d'objets en temps réel utilisant TensorFlow Lite. Interface en français, code en anglais.

## 🎯 Fonctionnalités

- ✅ **Vue caméra en temps réel** - Aperçu plein écran de la caméra
- ✅ **Capture photo** - Prendre une photo et analyser les objets
- ✅ **Upload galerie** - Sélectionner une photo existante
- ✅ **Détection d'objets** - Reconnaissance avec TensorFlow Lite (hors-ligne)
- ✅ **Rectangles colorés** - Bounding boxes autour des objets détectés
- ✅ **Labels français** - Noms d'objets et scores de confiance
- ✅ **Interface française** - Tous les boutons et messages en français

## 🚀 Installation Rapide

### Option 1: Script Python (Recommandé)
```cmd
python setup_flutter_project.py
flutter pub get
```

### Option 2: Script Batch
```cmd
setup_project.bat
flutter pub get
```

### Option 3: Manuel
```cmd
mkdir lib\models lib\services lib\screens lib\widgets lib\l10n
mkdir assets\models assets\labels

copy MAIN_APP_CODE.txt lib\main.dart
copy DETECTOR_SERVICE_CODE.txt lib\services\detector_service.dart
copy CAMERA_VIEW_CODE.txt lib\screens\camera_view.dart
copy DETECTION_RESULT_SCREEN_V2_CODE.txt lib\screens\detection_result_screen.dart
copy BOUNDING_BOX_PAINTER_CODE.txt lib\widgets\bounding_box_painter.dart
copy LABELS_FR.txt assets\labels\labels.txt

flutter pub get
```

## 📦 Modèle TensorFlow Lite Requis

**IMPORTANT**: Téléchargez un modèle MobileNet SSD (≤10MB):

1. **Source**: [TensorFlow Hub - MobileNet SSD](https://tfhub.dev/tensorflow/lite-model/ssd_mobilenet_v1/1/metadata/2)
2. **Sauvegarder sous**: `assets\models\detect.tflite`

Alternative: Utilisez `ssd_mobilenet_v2` ou `efficientdet-lite0`

## 🏗️ Architecture

### Structure Simple (2 Services)
```
lib/
├── main.dart                      # Point d'entrée
├── models/
│   └── detection.dart             # Modèle de données
├── services/
│   └── detector_service.dart      # Service ML (TFLite)
├── screens/
│   ├── camera_view.dart           # Vue caméra principale
│   └── detection_result_screen.dart  # Résultats avec boxes
└── widgets/
    └── bounding_box_painter.dart  # Painter pour rectangles
```

### Technologies
- **Flutter 3.x** - Framework mobile
- **TensorFlow Lite** - Inférence ML locale
- **Camera** - Aperçu et capture
- **Image Picker** - Sélection galerie

## 🎨 Interface Utilisateur

### Écran Principal (CameraView)
- Aperçu caméra plein écran
- Bouton "Analyser" (capture et détection)
- Bouton "Galerie" (sélection photo)
- Bouton "Historique" (à venir)

### Écran Résultats (DetectionResultScreen)
- Image avec rectangles colorés
- Labels français + scores de confiance
- Liste des objets détectés
- Badge de comptage

### Messages en Français
- "Chargement du modèle..."
- "Capture en cours..."
- "Analyse en cours..."
- "Aucun objet détecté"
- "Permission caméra requise"

## 📱 Utilisation

1. **Lancer l'application**
   ```cmd
   flutter run
   ```

2. **Accorder les permissions**
   - Permission caméra
   - Permission galerie (si nécessaire)

3. **Capturer une photo**
   - Pointer la caméra vers un objet
   - Appuyer sur "Analyser"

4. **Voir les résultats**
   - Rectangles colorés autour des objets
   - Noms en français + confiance %
   - Liste détaillée en bas

## 🎯 Constitution du Projet

### Principes Non-Négociables
1. **Bilingue**: Interface française, code anglais
2. **Architecture légère**: Structure simple, 2 services
3. **Performance**: Détection <2 secondes
4. **Hors-ligne**: Modèle local, zéro internet

### Contraintes Techniques
- Modèle TFLite ≤10MB
- Résolution 300x300 (MobileNet SSD)
- Seuil de confiance 50%+
- Android 7.0+ / iOS 12+

## 📊 Tâches Complétées

- ✅ **Tâche 1**: Configuration dépendances et permissions
- ✅ **Tâche 2**: Service de détection (DetectorService)
- ✅ **Tâche 3**: Interface caméra avec flux temps réel
- ✅ **Tâche 4**: Rectangles de détection (BoundingBoxPainter)

## 🔜 Fonctionnalités Futures

- 📋 Historique des détections (sauvegarde locale)
- 💾 Export des images annotées
- ⚙️ Paramètres (seuil de confiance ajustable)
- 🔄 Basculement caméra avant/arrière
- 🌐 Multilingue (anglais, espagnol)

## 🛠️ Développement

### Prérequis
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / Xcode
- Python 3.x (pour scripts setup)

### Dépendances Principales
```yaml
camera: ^0.10.5+5           # Capture photo
tflite_flutter: ^0.10.4     # Inférence ML
image_picker: ^1.0.5        # Sélection galerie
image: ^4.1.3               # Traitement image
permission_handler: ^11.0.1 # Gestion permissions
```

### Commandes Utiles
```cmd
# Installer dépendances
flutter pub get

# Analyser le code
flutter analyze

# Formater le code
dart format lib/

# Construire APK
flutter build apk

# Construire pour iOS
flutter build ios
```

## 📄 Documentation Détaillée

- `TASK1_STATUS.md` - Configuration initiale
- `TASK2_STATUS.md` - Service de détection
- `TASK3_STATUS.md` - Interface caméra
- `TASK4_STATUS.md` - Bounding boxes
- `SETUP_INSTRUCTIONS.md` - Guide d'installation complet

## 🐛 Résolution de Problèmes

### Modèle non trouvé
```
Error: Unable to load assets/models/detect.tflite
Solution: Télécharger MobileNet SSD et placer dans assets/models/
```

### Permission refusée
```
Error: Permission caméra requise
Solution: Aller dans Paramètres > Applications > Permissions
```

### Détection lente (>2s)
```
Problem: Temps de détection trop long
Solution: Utiliser un modèle plus léger (MobileNet v1 au lieu de v2)
```

## 📞 Support

Pour des questions ou problèmes:
1. Consulter la documentation dans `TASK*_STATUS.md`
2. Vérifier `SETUP_INSTRUCTIONS.md`
3. Examiner les fichiers `*_CODE.txt` pour référence

## 📝 Licence

Projet éducatif - Constitution définie dans `.specify/memory/constitution.md`

## 🎉 Statut du Projet

**Phase actuelle**: Pipeline complet de détection opérationnel ✅

- Capture photo ✅
- Détection objets ✅
- Visualisation boxes ✅
- Interface française ✅
- Fonctionnement hors-ligne ✅

**Prêt pour production de démonstration!**

---

Développé avec Flutter 🎯 | Détection locale avec TensorFlow Lite 🤖 | Interface en français 🇫🇷
