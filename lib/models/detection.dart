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
