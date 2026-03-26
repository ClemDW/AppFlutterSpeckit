import 'package:flutter/material.dart';
import '../models/detection.dart';

/// Custom painter for drawing bounding boxes over detected objects
/// Renders colored rectangles with labels and confidence scores
class BoundingBoxPainter extends CustomPainter {
  final List<Detection> detections;
  final Size imageSize;

  BoundingBoxPainter({
    required this.detections,
    required this.imageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (detections.isEmpty) return;

    // Calculate scaling factors to map detection coordinates to canvas
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    // Use the smaller scale to maintain aspect ratio
    final scale = scaleX < scaleY ? scaleX : scaleY;

    // Calculate offset to center the image
    final offsetX = (size.width - (imageSize.width * scale)) / 2;
    final offsetY = (size.height - (imageSize.height * scale)) / 2;

    for (int i = 0; i < detections.length; i++) {
      final detection = detections[i];
      final color = _getColorForIndex(i);

      // Scale and offset the bounding box coordinates
      final left = (detection.x * scale) + offsetX;
      final top = (detection.y * scale) + offsetY;
      final right = ((detection.x + detection.width) * scale) + offsetX;
      final bottom = ((detection.y + detection.height) * scale) + offsetY;

      // Draw bounding box rectangle
      _drawBoundingBox(canvas, left, top, right, bottom, color);

      // Draw label with confidence score
      _drawLabel(canvas, detection, left, top, color);
    }
  }

  /// Draw colored rectangle around detected object
  void _drawBoundingBox(
    Canvas canvas,
    double left,
    double top,
    double right,
    double bottom,
    Color color,
  ) {
    final rect = Rect.fromLTRB(left, top, right, bottom);

    // Draw filled semi-transparent background
    final fillPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, fillPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawRect(rect, borderPaint);
  }

  /// Draw label text with background
  void _drawLabel(
    Canvas canvas,
    Detection detection,
    double left,
    double top,
    Color color,
  ) {
    // Format confidence as percentage
    final confidenceText = '${(detection.confidence * 100).toStringAsFixed(0)}%';
    final labelText = '${detection.label} $confidenceText';

    // Create text painter
    final textPainter = TextPainter(
      text: TextSpan(
        text: labelText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Calculate label position (above bounding box)
    final labelWidth = textPainter.width + 12;
    final labelHeight = textPainter.height + 8;
    double labelTop = top - labelHeight - 4;

    // Keep label within canvas bounds
    if (labelTop < 0) {
      labelTop = top + 4; // Place inside box if no space above
    }

    // Draw label background
    final labelRect = Rect.fromLTWH(
      left,
      labelTop,
      labelWidth,
      labelHeight,
    );
    final backgroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
      backgroundPaint,
    );

    // Draw text
    textPainter.paint(
      canvas,
      Offset(left + 6, labelTop + 4),
    );
  }

  /// Get unique color for each detection index
  Color _getColorForIndex(int index) {
    final colors = [
      const Color(0xFFFF5252), // Red
      const Color(0xFF4CAF50), // Green
      const Color(0xFF2196F3), // Blue
      const Color(0xFFFFEB3B), // Yellow
      const Color(0xFF9C27B0), // Purple
      const Color(0xFFFF9800), // Orange
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFFE91E63), // Pink
      const Color(0xFFCDDC39), // Lime
      const Color(0xFF009688), // Teal
    ];
    return colors[index % colors.length];
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) {
    return oldDelegate.detections != detections ||
        oldDelegate.imageSize != imageSize;
  }
}
