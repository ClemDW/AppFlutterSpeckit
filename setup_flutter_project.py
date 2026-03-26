import os
import shutil

# Base directory
base_dir = os.path.dirname(os.path.abspath(__file__))

# Create directory structure
directories = [
    'android/app/src/main',
    'ios/Runner',
    'lib/l10n',
    'lib/services',
    'lib/models',
    'lib/screens',
    'lib/widgets',
    'assets/models',
    'assets/labels'
]

print("=" * 50)
print("Flutter Object Detection - Project Setup")
print("=" * 50)
print()
print("Creating directory structure...")

for directory in directories:
    dir_path = os.path.join(base_dir, directory)
    os.makedirs(dir_path, exist_ok=True)
    print(f"  ✓ {directory}/")

print()
print("Copying source files...")

# File mappings: source -> destination
file_mappings = {
    'MAIN_APP_CODE.txt': 'lib/main.dart',
    'DETECTOR_SERVICE_CODE.txt': 'lib/services/detector_service.dart',
    'CAMERA_VIEW_CODE.txt': 'lib/screens/camera_view.dart',
    'DETECTION_RESULT_SCREEN_V2_CODE.txt': 'lib/screens/detection_result_screen.dart',
    'BOUNDING_BOX_PAINTER_CODE.txt': 'lib/widgets/bounding_box_painter.dart',
    'LABELS_FR.txt': 'assets/labels/labels.txt'
}

for source, dest in file_mappings.items():
    source_path = os.path.join(base_dir, source)
    dest_path = os.path.join(base_dir, dest)
    
    if os.path.exists(source_path):
        shutil.copy2(source_path, dest_path)
        print(f"  ✓ {dest}")
    else:
        print(f"  ✗ {source} not found")

# Create detection.dart model
detection_dart = '''// Detection result model
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
'''

detection_path = os.path.join(base_dir, 'lib/models/detection.dart')
with open(detection_path, 'w', encoding='utf-8') as f:
    f.write(detection_dart)
print(f"  ✓ lib/models/detection.dart")

# Create French localization
arb_content = '''{
  "@@locale": "fr",
  "appTitle": "Détection d'Objets",
  "@appTitle": {
    "description": "Application title"
  },
  "cameraButton": "Caméra",
  "@cameraButton": {
    "description": "Button to open camera"
  },
  "galleryButton": "Galerie",
  "@galleryButton": {
    "description": "Button to open gallery"
  },
  "historyButton": "Historique",
  "@historyButton": {
    "description": "Button to view detection history"
  },
  "captureButton": "Capturer",
  "@captureButton": {
    "description": "Button to capture photo"
  },
  "noObjectsDetected": "Aucun objet détecté",
  "@noObjectsDetected": {
    "description": "Message when no objects are detected"
  }
}
'''

arb_path = os.path.join(base_dir, 'lib/l10n/app_fr.arb')
with open(arb_path, 'w', encoding='utf-8') as f:
    f.write(arb_content)
print(f"  ✓ lib/l10n/app_fr.arb")

print()
print("=" * 50)
print("Setup Complete!")
print("=" * 50)
print()
print("NEXT STEPS:")
print("1. Install dependencies:")
print("   flutter pub get")
print()
print("2. Download TensorFlow Lite model (MobileNet SSD <10MB):")
print("   https://tfhub.dev/tensorflow/lite-model/ssd_mobilenet_v1/1/metadata/2")
print()
print("3. Place model file:")
print("   assets/models/detect.tflite")
print()
print("4. Run the app:")
print("   flutter run")
print()
