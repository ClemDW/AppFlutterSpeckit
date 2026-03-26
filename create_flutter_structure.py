#!/usr/bin/env python3
"""
Flutter Project Structure Creator
Reads code from *_CODE.txt files and creates the complete Flutter application structure
"""

import os
import shutil
from pathlib import Path

# Base directory
BASE_DIR = Path(__file__).parent

# Define all directories to create
DIRECTORIES = [
    "lib",
    "lib/models",
    "lib/services",
    "lib/screens",
    "lib/widgets",
    "lib/l10n",
    "assets",
    "assets/models",
    "assets/labels",
]

# File mappings: source_file -> destination_path
FILE_MAPPINGS = {
    "MAIN_APP_CODE.txt": "lib/main.dart",
    "DETECTOR_SERVICE_CODE.txt": "lib/services/detector_service.dart",
    "CAMERA_VIEW_CODE.txt": "lib/screens/camera_view.dart",
    "DETECTION_RESULT_SCREEN_V2_CODE.txt": "lib/screens/detection_result_screen.dart",
    "BOUNDING_BOX_PAINTER_CODE.txt": "lib/widgets/bounding_box_painter.dart",
    "LABELS_FR.txt": "assets/labels/labels.txt",
}


def create_directories():
    """Create all necessary directories"""
    print("📁 Creating directories...")
    for directory in DIRECTORIES:
        dir_path = BASE_DIR / directory
        dir_path.mkdir(parents=True, exist_ok=True)
        print(f"  ✓ Created: {directory}")


def copy_code_files():
    """Copy content from *_CODE.txt files to their destinations"""
    print("\n📄 Copying code files...")
    for source_file, dest_path in FILE_MAPPINGS.items():
        source_path = BASE_DIR / source_file
        destination = BASE_DIR / dest_path
        
        if not source_path.exists():
            print(f"  ⚠ Warning: {source_file} not found, skipping...")
            continue
        
        # Read source content
        with open(source_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Write to destination
        with open(destination, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"  ✓ Copied: {source_file} -> {dest_path}")


def create_detection_model():
    """Create the Detection model class"""
    print("\n🔧 Creating Detection model...")
    
    detection_code = """/// Detection model representing a detected object
/// Contains label, confidence score, and bounding box coordinates
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

  /// Create Detection from JSON
  factory Detection.fromJson(Map<String, dynamic> json) {
    return Detection(
      label: json['label'] as String,
      confidence: json['confidence'] as double,
      x: json['x'] as double,
      y: json['y'] as double,
      width: json['width'] as double,
      height: json['height'] as double,
    );
  }

  /// Convert Detection to JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'confidence': confidence,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    };
  }

  @override
  String toString() {
    return 'Detection(label: $label, confidence: ${(confidence * 100).toStringAsFixed(1)}%, '
        'box: [${x.toStringAsFixed(1)}, ${y.toStringAsFixed(1)}, '
        '${width.toStringAsFixed(1)}, ${height.toStringAsFixed(1)}])';
  }
}
"""
    
    detection_path = BASE_DIR / "lib" / "models" / "detection.dart"
    with open(detection_path, 'w', encoding='utf-8') as f:
        f.write(detection_code)
    
    print(f"  ✓ Created: lib/models/detection.dart")


def create_localization_file():
    """Create French localization file (app_fr.arb)"""
    print("\n🌍 Creating localization file...")
    
    arb_content = """{
  "@@locale": "fr",
  "appTitle": "Détection d'Objets",
  "@appTitle": {
    "description": "The title of the application"
  },
  "cameraView": "Vue Caméra",
  "@cameraView": {
    "description": "Camera view screen title"
  },
  "loadingModel": "Chargement du modèle...",
  "@loadingModel": {
    "description": "Message shown while loading the ML model"
  },
  "cameraPermissionRequired": "Permission caméra requise",
  "@cameraPermissionRequired": {
    "description": "Message when camera permission is needed"
  },
  "noCameraAvailable": "Aucune caméra disponible",
  "@noCameraAvailable": {
    "description": "Message when no camera is found"
  },
  "analyzing": "Analyse en cours...",
  "@analyzing": {
    "description": "Message during image analysis"
  },
  "capture": "Capturer",
  "@capture": {
    "description": "Button to capture photo"
  },
  "gallery": "Galerie",
  "@gallery": {
    "description": "Button to open gallery"
  },
  "history": "Historique",
  "@history": {
    "description": "Button to view history"
  },
  "detectionResults": "Résultats de détection",
  "@detectionResults": {
    "description": "Title for detection results screen"
  },
  "noObjectsDetected": "Aucun objet détecté",
  "@noObjectsDetected": {
    "description": "Message when no objects are found"
  },
  "tryAnotherImage": "Essayez avec une autre image",
  "@tryAnotherImage": {
    "description": "Suggestion to try with a different image"
  },
  "objectsDetected": "Objets détectés",
  "@objectsDetected": {
    "description": "Label for list of detected objects"
  },
  "retry": "Réessayer",
  "@retry": {
    "description": "Button to retry an action"
  }
}
"""
    
    arb_path = BASE_DIR / "lib" / "l10n" / "app_fr.arb"
    with open(arb_path, 'w', encoding='utf-8') as f:
        f.write(arb_content)
    
    print(f"  ✓ Created: lib/l10n/app_fr.arb")


def verify_structure():
    """Verify all files and directories were created"""
    print("\n✅ Verifying project structure...")
    
    # Check directories
    missing_dirs = []
    for directory in DIRECTORIES:
        dir_path = BASE_DIR / directory
        if not dir_path.exists():
            missing_dirs.append(directory)
    
    if missing_dirs:
        print(f"  ⚠ Missing directories: {', '.join(missing_dirs)}")
    else:
        print(f"  ✓ All {len(DIRECTORIES)} directories created")
    
    # Check files
    expected_files = list(FILE_MAPPINGS.values()) + [
        "lib/models/detection.dart",
        "lib/l10n/app_fr.arb",
    ]
    
    missing_files = []
    for file_path in expected_files:
        full_path = BASE_DIR / file_path
        if not full_path.exists():
            missing_files.append(file_path)
    
    if missing_files:
        print(f"  ⚠ Missing files: {', '.join(missing_files)}")
    else:
        print(f"  ✓ All {len(expected_files)} files created")
    
    return len(missing_dirs) == 0 and len(missing_files) == 0


def print_summary():
    """Print summary of created structure"""
    print("\n" + "="*60)
    print("📦 Flutter Application Structure Created Successfully!")
    print("="*60)
    
    print("\n📂 Directory Structure:")
    print("  lib/")
    print("  ├── models/        (Detection model)")
    print("  ├── services/      (DetectorService)")
    print("  ├── screens/       (CameraView, DetectionResultScreen)")
    print("  ├── widgets/       (BoundingBoxPainter)")
    print("  └── l10n/          (French localization)")
    print("  assets/")
    print("  ├── models/        (TFLite model - TO BE ADDED)")
    print("  └── labels/        (French labels)")
    
    print("\n📝 Created Files:")
    print("  ✓ lib/main.dart")
    print("  ✓ lib/models/detection.dart")
    print("  ✓ lib/services/detector_service.dart")
    print("  ✓ lib/screens/camera_view.dart")
    print("  ✓ lib/screens/detection_result_screen.dart")
    print("  ✓ lib/widgets/bounding_box_painter.dart")
    print("  ✓ lib/l10n/app_fr.arb")
    print("  ✓ assets/labels/labels.txt")
    
    print("\n⚠ Next Steps:")
    print("  1. Download TFLite model (detect.tflite)")
    print("  2. Place model in: assets/models/detect.tflite")
    print("  3. Run: flutter pub get")
    print("  4. Run: flutter run")
    
    print("\n" + "="*60)


def main():
    """Main execution function"""
    print("🚀 Starting Flutter Project Structure Creation")
    print("="*60)
    
    try:
        # Step 1: Create directories
        create_directories()
        
        # Step 2: Copy code files
        copy_code_files()
        
        # Step 3: Create Detection model
        create_detection_model()
        
        # Step 4: Create localization file
        create_localization_file()
        
        # Step 5: Verify everything
        success = verify_structure()
        
        # Step 6: Print summary
        if success:
            print_summary()
        else:
            print("\n⚠ Warning: Some files or directories are missing!")
            print("Please check the output above for details.")
        
        return 0 if success else 1
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    exit(main())
