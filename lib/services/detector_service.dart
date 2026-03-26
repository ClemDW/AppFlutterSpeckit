import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import '../models/detection.dart';

/// Service for object detection using TensorFlow Lite
/// Loads model from assets and performs inference on images
class DetectorService {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isInitialized = false;

  // Model configuration constants
  static const String _modelAssetPath = 'assets/models/detect.tflite';
  static const String _labelsPath = 'assets/labels/labels.txt';
  static const int _inputSize = 300; // MobileNet SSD input size
  static const double _confidenceThreshold = 0.5; // 50% minimum confidence
  static const int _maxImageSize = 640; // Maximum image dimension for processing

  /// Check if service is ready
  bool get isInitialized => _isInitialized;

  /// Initialize the detector by loading model and labels
  Future<void> initialize() async {
    try {
      print('Loading TFLite model from assets...');
      
      // Load labels from text file
      await _loadLabels();
      print('Labels loaded: ${_labels.length} classes');

      // Load TFLite model from assets
      _interpreter = await Interpreter.fromAsset(_modelAssetPath);
      
      // Get input and output tensor info
      print('Model loaded successfully');
      print('Input shape: ${_interpreter!.getInputTensor(0).shape}');
      print('Input type: ${_interpreter!.getInputTensor(0).type}');
      print('Output tensors: ${_interpreter!.getOutputTensors().length}');
      for (var i = 0; i < _interpreter!.getOutputTensors().length; i++) {
        print('Output $i shape: ${_interpreter!.getOutputTensor(i).shape}');
        print('Output $i type: ${_interpreter!.getOutputTensor(i).type}');
      }

      _isInitialized = true;
    } catch (e) {
      print('Error initializing detector: $e');
      print('Stack trace: ${StackTrace.current}');
      _isInitialized = false;
      rethrow;
    }
  }

  /// Load label names from assets
  Future<void> _loadLabels() async {
    try {
      final labelsData = await rootBundle.loadString(_labelsPath);
      _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();
    } catch (e) {
      print('Error loading labels: $e');
      throw Exception('Failed to load labels from $_labelsPath');
    }
  }

  /// Detect objects in an image file
  /// Returns list of detections with bounding boxes and confidence scores
  Future<List<Detection>> detectObjects(File imageFile) async {
    if (!_isInitialized || _interpreter == null) {
      throw Exception('Detector not initialized. Call initialize() first.');
    }

    try {
      print('Starting object detection on ${imageFile.path}');
      
      // Read and decode image
      final imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      print('Original image size: ${image.width}x${image.height}');
      
      // Store original dimensions for coordinate scaling
      final originalWidth = image.width;
      final originalHeight = image.height;

      // Preprocess image for model input
      final inputTensor = _preprocessImage(image);
      print('Image preprocessed, input shape: ${inputTensor.shape}');

      // Prepare output buffers for MobileNet SSD
      // Output format: [1, 10, 4] for boxes, [1, 10] for classes, [1, 10] for scores, [1] for count
      final outputLocations = List.generate(1, (_) => List<double>.filled(10 * 4, 0.0));
      final outputClasses = List.generate(1, (_) => List<double>.filled(10, 0.0));
      final outputScores = List.generate(1, (_) => List<double>.filled(10, 0.0));
      final numDetections = List<double>.filled(1, 0.0);

      // Create outputs map
      final outputs = {
        0: outputLocations,
        1: outputClasses,
        2: outputScores,
        3: numDetections,
      };

      // Run inference
      print('Running inference...');
      _interpreter!.runForMultipleInputs([inputTensor.buffer], outputs);
      print('Inference complete, detections: ${numDetections[0].toInt()}');

      // Parse results into Detection objects
      final detections = _parseDetections(
        outputLocations[0],
        outputClasses[0],
        outputScores[0],
        numDetections[0].toInt(),
        originalWidth,
        originalHeight,
      );
      
      print('Returning ${detections.length} detections after filtering');
      return detections;
    } catch (e) {
      print('Error during object detection: $e');
      print('Stack trace: ${StackTrace.current}');
      return [];
    }
  }

  /// Preprocess image to model input format using TensorImage
  /// Resize to 300x300 and normalize pixel values
  TensorImage _preprocessImage(img.Image image) {
    // Create TensorImage from image
    final tensorImage = TensorImage.fromImage(image);
    
    // Create image processor with resize and normalization
    final imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(_inputSize, _inputSize, ResizeMethod.bilinear))
        .add(NormalizeOp(0, 255)) // Normalize to [0, 1]
        .build();
    
    // Process the image
    imageProcessor.process(tensorImage);
    
    return tensorImage;
  }

  /// Parse model output into Detection objects
  /// Filter by confidence threshold and convert coordinates
  List<Detection> _parseDetections(
    List<double> locations,
    List<double> classes,
    List<double> scores,
    int numDetections,
    int imageWidth,
    int imageHeight,
  ) {
    List<Detection> detections = [];
    
    print('Parsing $numDetections detections...');

    for (int i = 0; i < numDetections && i < 10; i++) {
      final score = scores[i];
      
      print('Detection $i: score=$score, class=${classes[i].toInt()}');

      // Filter out low confidence detections
      if (score < _confidenceThreshold) {
        print('  Filtered out (score < $_confidenceThreshold)');
        continue;
      }

      // Get bounding box coordinates (normalized 0-1)
      final ymin = locations[i * 4];
      final xmin = locations[i * 4 + 1];
      final ymax = locations[i * 4 + 2];
      final xmax = locations[i * 4 + 3];

      // Convert normalized coordinates to pixel coordinates
      final x = xmin * imageWidth;
      final y = ymin * imageHeight;
      final width = (xmax - xmin) * imageWidth;
      final height = (ymax - ymin) * imageHeight;

      // Get label name
      final classIndex = classes[i].toInt();
      final label = (classIndex >= 0 && classIndex < _labels.length)
          ? _labels[classIndex]
          : 'Inconnu';

      print('  Detection: $label (${(score * 100).toStringAsFixed(1)}%) at ($x, $y, $width, $height)');

      detections.add(Detection(
        label: label,
        confidence: score,
        x: x,
        y: y,
        width: width,
        height: height,
      ));
    }

    return detections;
  }

  /// Clean up resources
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }
}
