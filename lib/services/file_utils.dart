import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Utility class for handling file operations and paths
class FileUtils {
  /// Gets the default directory for saving PDFs
  /// On Android, this will typically be the Downloads directory
  /// Falls back to Documents directory if Downloads is not available
  static Future<String> getDefaultPdfDirectory() async {
    try {
      // Try to get the Downloads directory (Android)
      if (Platform.isAndroid) {
        final directory = Directory('/storage/emulated/0/Download');
        if (await directory.exists()) {
          return directory.path;
        }
      }
      
      // Fall back to Documents directory
      final directory = await getApplicationDocumentsDirectory();
      final pdfDir = Directory('${directory.path}/pdfs');
      
      // Create the directory if it doesn't exist
      if (!await pdfDir.exists()) {
        await pdfDir.create(recursive: true);
      }
      
      return pdfDir.path;
    } catch (e) {
      // Final fallback to app documents directory
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  /// Ensures a directory exists, creating it if necessary
  static Future<void> ensureDirectoryExists(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  /// Generates a safe filename from a string by removing invalid characters
  static String sanitizeFilename(String filename) {
    // Remove or replace characters that are invalid in filenames
    return filename
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }

  /// Checks if a file exists and is readable
  static Future<bool> isFileReadable(String path) async {
    try {
      final file = File(path);
      return await file.exists() && await file.length() > 0;
    } catch (e) {
      return false;
    }
  }
}