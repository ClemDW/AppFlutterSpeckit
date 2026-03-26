# Task 1: Configuration des dépendances et permissions caméra

## ✅ Completed Tasks

### 1. Created pubspec.yaml with dependencies
- ✅ camera: ^0.10.5+5 (photo capture)
- ✅ tflite_flutter: ^0.10.4 (ML inference)
- ✅ image_picker: ^1.0.5 (gallery selection)
- ✅ permission_handler: ^11.0.1 (permission management)
- ✅ path_provider: ^2.1.1 (local storage)
- ✅ intl: ^0.18.1 (French localization)
- ✅ shared_preferences: ^2.2.2 (app settings)

### 2. Created localization configuration
- ✅ l10n.yaml with ARB file configuration
- ✅ lib/l10n/app_fr.arb with French UI strings
- ✅ pubspec.yaml configured with `generate: true`

### 3. Prepared Android permissions (AndroidManifest.xml template)
- ✅ CAMERA permission
- ✅ READ_EXTERNAL_STORAGE permission
- ✅ WRITE_EXTERNAL_STORAGE permission (Android ≤12)
- ✅ READ_MEDIA_IMAGES permission (Android 13+)
- ✅ Camera hardware features declaration
- ✅ Min SDK set to 24 (Android 7.0+)

### 4. Prepared iOS permissions (Info.plist template)
- ✅ NSCameraUsageDescription (French message)
- ✅ NSPhotoLibraryUsageDescription (French message)
- ✅ NSPhotoLibraryAddUsageDescription (French message)

### 5. Configured Android build.gradle template
- ✅ Min SDK 24 (Android 7.0+)
- ✅ Target SDK 34
- ✅ TensorFlow Lite NDK filters (armeabi-v7a, arm64-v8a, x86_64)
- ✅ ProGuard optimization enabled for release builds

## 📋 Setup Instructions (Manual - PowerShell 6+ Required)

**⚠️ IMPORTANT**: Your system requires PowerShell 6+ for automated Flutter commands.

### Option 1: Install PowerShell 7 (Recommended)
1. Download from: https://aka.ms/powershell
2. Install PowerShell 7
3. Restart your terminal
4. Then run: `flutter pub get`

### Option 2: Use Command Prompt (Immediate)
Run the provided batch file to create directories:

```cmd
setup_project.bat
```

This will create:
- android/app/src/main/
- ios/Runner/
- lib/l10n/
- lib/services/
- lib/models/
- lib/screens/
- lib/widgets/
- assets/models/
- assets/labels/

Then manually place the configuration files in their directories.

## 📁 Files Created

✅ pubspec.yaml
✅ l10n.yaml
✅ lib/l10n/app_fr.arb (French UI strings)
✅ setup_project.bat (directory setup script)

## 📁 Files Ready (Templates Created)

📄 android/app/src/main/AndroidManifest.xml (needs directory)
📄 ios/Runner/Info.plist (needs directory)
📄 android/app/build.gradle (needs directory)

## 🎯 Next Steps

1. **Run setup script**: `setup_project.bat`
2. **Install dependencies**: `flutter pub get`
3. **Download TFLite model**: Get MobileNet SSD (≤10MB) from TensorFlow Hub
4. **Place model**: Save as `assets/models/detect.tflite`
5. **Create labels file**: Create `assets/labels/labels.txt` with COCO class names in French

## 🏗️ Constitution Compliance

✅ **Bilingual**: French UI strings in ARB, English code/comments
✅ **Lightweight**: Minimal dependencies (only essentials)
✅ **Performance**: TFLite with NDK optimization
✅ **Offline-first**: All dependencies work without internet
✅ **Simple architecture**: Flat structure, 2 services planned
