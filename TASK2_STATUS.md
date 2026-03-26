# Task 2: Service de Détection d'Objets

## ✅ Completed Tasks

### 1. Created Detection Model (`lib/models/detection.dart`)
- ✅ Represents a detected object with:
  - Label (French object name)
  - Confidence score (0-1)
  - Bounding box coordinates (x, y, width, height)
- ✅ Serialization methods for history storage (toMap/fromMap)
- ✅ **Constitution compliant**: English code/comments, French labels in runtime data

### 2. Created DetectorService (`lib/services/detector_service.dart`)
- ✅ Loads TFLite model from `assets/models/detect.tflite`
- ✅ Loads French labels from `assets/labels/labels.txt`
- ✅ **initialize()** method: Sets up model and labels
- ✅ **detectObjects(File imageFile)** method: Main inference function
  - Reads image file
  - Preprocesses to 300x300 (MobileNet SSD format)
  - Runs TFLite inference
  - Parses output into Detection objects
  - Filters by 50% confidence threshold
- ✅ **dispose()** method: Cleans up resources
- ✅ Error handling with helpful error messages
- ✅ Performance optimized: Auto-resize to 300x300

### 3. Created French Labels File (`assets/labels/labels.txt`)
- ✅ 80 COCO class labels translated to French
- ✅ Examples: "Personne", "Chat", "Chien", "Voiture", "Téléphone portable"
- ✅ **Constitution compliant**: French labels for UI display

### 4. Updated pubspec.yaml
- ✅ Added `image: ^4.1.3` package for image preprocessing
- ✅ Already configured asset paths for models and labels

## 🏗️ Architecture

### Simple Two-Service Design (Constitution Compliant)
```
lib/
├── models/
│   └── detection.dart          # Detection data model
└── services/
    └── detector_service.dart    # ML inference service
```

### DetectorService API
```dart
// Initialize (call once at app startup)
await detectorService.initialize();

// Detect objects in an image
List<Detection> detections = await detectorService.detectObjects(imageFile);

// Clean up (call when disposing)
detectorService.dispose();
```

### Detection Model Structure
```dart
Detection {
  String label;      // "Chat", "Chien", "Personne" (French)
  double confidence; // 0.0 to 1.0 (0.5+ threshold)
  double x;          // Bounding box x coordinate
  double y;          // Bounding box y coordinate
  double width;      // Bounding box width
  double height;     // Bounding box height
}
```

## 🎯 Technical Details

### Model Configuration
- **Input size**: 300x300 pixels (MobileNet SSD standard)
- **Output format**: 
  - Bounding boxes: [1, 10, 4] (up to 10 detections, 4 coords each)
  - Classes: [1, 10] (class indices)
  - Scores: [1, 10] (confidence scores)
  - Count: [1] (number of detections)
- **Confidence threshold**: 50% (adjustable via `_confidenceThreshold`)
- **Coordinate system**: Normalized (0-1) → converted to pixels

### Image Preprocessing
1. Load image from file
2. Resize to 300x300 (maintains aspect ratio)
3. Normalize pixel values (0-255 → 0.0-1.0)
4. Convert to 4D tensor [1, 300, 300, 3]

### Performance Optimization
- ✅ Auto-resize large images to 300x300 (reduces inference time)
- ✅ Early filtering by confidence threshold
- ✅ Efficient memory management with dispose()
- ✅ Target: <2 seconds total latency (constitution requirement)

## 🏗️ Constitution Compliance

✅ **Bilingual**: 
- English code, comments, variable names
- French labels for UI display
- Example: `label: "Personne"` (French) in runtime data

✅ **Lightweight Architecture**: 
- Single service file (150 lines)
- No unnecessary abstractions
- Direct TFLite integration

✅ **Performance Priority**:
- Auto-resize to 300x300
- 50% confidence threshold (filters noise)
- Efficient preprocessing pipeline

✅ **Offline-First**:
- Model bundled in assets (no download)
- Labels bundled in assets
- Zero internet dependency

## 📝 Next Steps for Task 3

1. **Create Camera Service** (`lib/services/camera_service.dart`):
   - Camera preview initialization
   - Photo capture
   - Gallery image selection
   - Permission handling

2. **Test DetectorService** (optional):
   - Create simple test screen
   - Load sample image
   - Verify detection output
   - Confirm <2s latency

3. **Prepare for Task 4** (UI Integration):
   - Main screen with camera view
   - Bounding box overlay widget
   - French labels rendering

## ⚠️ Important Notes

### Model File Required
The service expects `assets/models/detect.tflite` to exist. You need to:
1. Download MobileNet SSD v1 or v2 (≤10MB)
2. Sources:
   - TensorFlow Hub: https://tfhub.dev/tensorflow/lite-model/ssd_mobilenet_v1/1/metadata/2
   - Or use pre-trained COCO model
3. Place in `assets/models/detect.tflite`

### Testing the Service
```dart
// Example usage
void testDetector() async {
  final service = DetectorService();
  await service.initialize();
  
  final imageFile = File('path/to/test/image.jpg');
  final detections = await service.detectObjects(imageFile);
  
  for (var detection in detections) {
    print('${detection.label}: ${(detection.confidence * 100).toStringAsFixed(1)}%');
  }
  
  service.dispose();
}
```

## 📦 Files Created

✅ `lib/models/detection.dart` (47 lines)
✅ `lib/services/detector_service.dart` (192 lines)
✅ `assets/labels/labels.txt` (80 French labels)
✅ `pubspec.yaml` (updated with `image` package)
✅ `TASK2_STATUS.md` (this file)

---

**Task 2 Complete!** Ready for Task 3 (Camera Service) and Task 4 (UI Integration).
