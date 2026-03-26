@echo off
echo ================================================
echo Flutter Object Detection - Project Setup
echo ================================================
echo.
echo Creating Flutter project directory structure...

mkdir android\app\src\main 2>nul
mkdir android\app 2>nul
mkdir ios\Runner 2>nul
mkdir lib\l10n 2>nul
mkdir lib\services 2>nul
mkdir lib\models 2>nul
mkdir lib\screens 2>nul
mkdir lib\widgets 2>nul
mkdir assets\models 2>nul
mkdir assets\labels 2>nul

echo.
echo Copying source files...

if exist MAIN_APP_CODE.txt (
    copy /Y MAIN_APP_CODE.txt lib\main.dart >nul
    echo   - lib\main.dart
)

if exist DETECTOR_SERVICE_CODE.txt (
    copy /Y DETECTOR_SERVICE_CODE.txt lib\services\detector_service.dart >nul
    echo   - lib\services\detector_service.dart
)

if exist CAMERA_VIEW_CODE.txt (
    copy /Y CAMERA_VIEW_CODE.txt lib\screens\camera_view.dart >nul
    echo   - lib\screens\camera_view.dart
)

if exist DETECTION_RESULT_SCREEN_V2_CODE.txt (
    copy /Y DETECTION_RESULT_SCREEN_V2_CODE.txt lib\screens\detection_result_screen.dart >nul
    echo   - lib\screens\detection_result_screen.dart
) else if exist DETECTION_RESULT_SCREEN_CODE.txt (
    copy /Y DETECTION_RESULT_SCREEN_CODE.txt lib\screens\detection_result_screen.dart >nul
    echo   - lib\screens\detection_result_screen.dart
)

if exist BOUNDING_BOX_PAINTER_CODE.txt (
    copy /Y BOUNDING_BOX_PAINTER_CODE.txt lib\widgets\bounding_box_painter.dart >nul
    echo   - lib\widgets\bounding_box_painter.dart
)

if exist LABELS_FR.txt (
    copy /Y LABELS_FR.txt assets\labels\labels.txt >nul
    echo   - assets\labels\labels.txt
)

echo.
echo Creating detection.dart model...
(
echo // Detection result model
echo // Represents a single detected object with bounding box and confidence
echo class Detection {
echo   final String label;
echo   final double confidence;
echo   final double x;
echo   final double y;
echo   final double width;
echo   final double height;
echo.
echo   Detection^(^{
echo     required this.label,
echo     required this.confidence,
echo     required this.x,
echo     required this.y,
echo     required this.width,
echo     required this.height,
echo   ^}^);
echo.
echo   // Convert to map for serialization ^(history storage^)
echo   Map^<String, dynamic^> toMap^(^) {
echo     return {
echo       'label': label,
echo       'confidence': confidence,
echo       'x': x,
echo       'y': y,
echo       'width': width,
echo       'height': height,
echo     };
echo   }
echo.
echo   // Create from map for deserialization
echo   factory Detection.fromMap^(Map^<String, dynamic^> map^) {
echo     return Detection^(
echo       label: map['label'] as String,
echo       confidence: map['confidence'] as double,
echo       x: map['x'] as double,
echo       y: map['y'] as double,
echo       width: map['width'] as double,
echo       height: map['height'] as double,
echo     ^);
echo   }
echo }
) > lib\models\detection.dart
echo   - lib\models\detection.dart

echo.
echo Creating French localization file...
(
echo {
echo   "@@locale": "fr",
echo   "appTitle": "Detection d'Objets",
echo   "cameraButton": "Camera",
echo   "galleryButton": "Galerie",
echo   "historyButton": "Historique",
echo   "captureButton": "Capturer",
echo   "noObjectsDetected": "Aucun objet detecte"
echo }
) > lib\l10n\app_fr.arb
echo   - lib\l10n\app_fr.arb

echo.
echo ================================================
echo Directory structure and files created!
echo ================================================
echo.
echo Created directories:
echo   - android/app/src/main/
echo   - ios/Runner/
echo   - lib/l10n/, lib/services/, lib/models/
echo   - lib/screens/, lib/widgets/
echo   - assets/models/, assets/labels/
echo.
echo ================================================
echo NEXT STEPS:
echo ================================================
echo.
echo 1. Install dependencies:
echo    flutter pub get
echo.
echo 2. Download TensorFlow Lite model (MobileNet SSD ^<10MB):
echo    URL: https://tfhub.dev/tensorflow/lite-model/ssd_mobilenet_v1/1/metadata/2
echo.
echo 3. Place model file:
echo    assets\models\detect.tflite
echo.
echo 4. Run the app:
echo    flutter run
echo.
echo ================================================
echo Setup Complete! Ready to build.
echo ================================================
echo.
pause
