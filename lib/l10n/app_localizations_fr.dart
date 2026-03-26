// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Detection d\'Objets';

  @override
  String get cameraButton => 'Camera';

  @override
  String get galleryButton => 'Galerie';

  @override
  String get historyButton => 'Historique';

  @override
  String get captureButton => 'Capturer';

  @override
  String get noObjectsDetected => 'Aucun objet detecte';
}
