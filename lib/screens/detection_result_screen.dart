import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/detection.dart';
import '../widgets/bounding_box_painter.dart';

/// Screen displaying detection results with bounding boxes
/// Shows analyzed image with colored rectangles and French labels
class DetectionResultScreen extends StatefulWidget {
  final String imagePath;
  final List<Detection> detections;

  const DetectionResultScreen({
    Key? key,
    required this.imagePath,
    required this.detections,
  }) : super(key: key);

  @override
  State<DetectionResultScreen> createState() => _DetectionResultScreenState();
}

class _DetectionResultScreenState extends State<DetectionResultScreen> {
  ui.Image? _image;
  bool _isLoadingImage = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  /// Load image to get its dimensions for proper coordinate mapping
  Future<void> _loadImage() async {
    try {
      final imageFile = File(widget.imagePath);
      final bytes = await imageFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      
      setState(() {
        _image = frame.image;
        _isLoadingImage = false;
      });
    } catch (e) {
      print('Error loading image: $e');
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Résultats de détection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Save button (placeholder for future feature)
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () {
              // TODO: Implement save to history
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sauvegarde disponible prochainement')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Image with bounding boxes
          Expanded(
            child: Center(
              child: _isLoadingImage
                  ? const CircularProgressIndicator(color: Colors.white)
                  : widget.detections.isEmpty
                      ? _buildNoDetectionsView()
                      : _buildImageWithDetections(),
            ),
          ),

          // Detection list
          if (widget.detections.isNotEmpty) _buildDetectionsList(),
        ],
      ),
    );
  }

  /// Build view when no objects detected
  Widget _buildNoDetectionsView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          const Icon(
            Icons.search_off,
            color: Colors.white54,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'Aucun objet détecté',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Essayez avec une autre image',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Build image with detection overlays using CustomPaint
  Widget _buildImageWithDetections() {
    if (_image == null) {
      return Image.file(
        File(widget.imagePath),
        fit: BoxFit.contain,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Image with bounding boxes overlay
            CustomPaint(
              foregroundPainter: BoundingBoxPainter(
                detections: widget.detections,
                imageSize: Size(
                  _image!.width.toDouble(),
                  _image!.height.toDouble(),
                ),
              ),
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.contain,
              ),
            ),
            
            // Detection count badge
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.visibility,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.detections.length} objet${widget.detections.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build list of detected objects
  Widget _buildDetectionsList() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Objets détectés',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.detections.length} total',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: widget.detections.length,
              itemBuilder: (context, index) {
                final detection = widget.detections[index];
                return ListTile(
                  dense: true,
                  leading: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getColorForIndex(index),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                  ),
                  title: Text(
                    detection.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getColorForIndex(index).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(detection.confidence * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: _getColorForIndex(index),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Get unique color for each detection (matches BoundingBoxPainter)
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
}
