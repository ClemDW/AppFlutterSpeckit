# ⚠️ SETUP REQUIRED - Task 1 & 2 Configuration

## 🎯 Quick Setup (2 Steps)

### Step 1: Create Directory Structure
Run this in Command Prompt (cmd):
```cmd
cd C:\Users\cleme\Documents\AppFlutter
setup_project.bat
```

### Step 2: Install Dependencies
```cmd
flutter pub get
```

---

## 📋 Files Ready to Copy

After running `setup_project.bat`, copy these files into their directories:

### 1. Detection Model: `lib\models\detection.dart`
```dart
// Detection result model
// Represents a single detected object with bounding box and confidence
class Detection {
  final String label;
  final double confidence;
  final double x;
  final double y;
  final double width;
  final double height;

  Detection({
    required this.label,
    required this.confidence,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  // Convert to map for serialization (history storage)
  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'confidence': confidence,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    };
  }

  // Create from map for deserialization
  factory Detection.fromMap(Map<String, dynamic> map) {
    return Detection(
      label: map['label'] as String,
      confidence: map['confidence'] as double,
      x: map['x'] as double,
      y: map['y'] as double,
      width: map['width'] as double,
      height: map['height'] as double,
    );
  }
}
```

### 2. Detector Service: `lib\services\detector_service.dart`
**See DETECTOR_SERVICE_CODE.txt for the full implementation** (192 lines)

### 3. French Labels: `assets\labels\labels.txt`
**See LABELS_FR.txt for the complete list** (80 COCO classes in French)

---

## 📦 What's Already Configured

✅ `pubspec.yaml` - All dependencies added
✅ `l10n.yaml` - Localization config
✅ `lib\l10n\app_fr.arb` - French UI strings
✅ `setup_project.bat` - Directory creation script
✅ `TASK1_STATUS.md` - Task 1 documentation
✅ `TASK2_STATUS.md` - Task 2 documentation

---

## 🔄 Alternative: Manual Directory Creation

If the batch file doesn't work, create these manually:
```
AppFlutter\
├── lib\
│   ├── l10n\
│   ├── models\
│   ├── services\
│   ├── screens\
│   └── widgets\
├── assets\
│   ├── models\
│   └── labels\
├── android\
│   └── app\
│       └── src\
│           └── main\
└── ios\
    └── Runner\
```

---

## ⚠️ Model File Required

Download MobileNet SSD (≤10MB):
- **Source**: https://tfhub.dev/tensorflow/lite-model/ssd_mobilenet_v1/1/metadata/2
- **Save as**: `assets\models\detect.tflite`

---

## 🎯 Constitution Compliance Summary

✅ **French UI**: All labels, buttons, messages in French (ARB files)
✅ **English Code**: All code, comments, variables in English  
✅ **Simple Architecture**: 2 services (Detector + Camera planned)
✅ **Lightweight**: Minimal dependencies, 10MB model limit
✅ **Performance**: <2s detection target with 300x300 preprocessing
✅ **Offline-First**: Model and labels bundled in assets

---

**Next**: After setup completes, proceed to Task 3 (Camera Service)
