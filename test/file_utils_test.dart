import 'package:flutter_test/flutter_test.dart';
import 'package:supervisor/services/file_utils.dart';
import 'dart:io';

void main() {
  group('FileUtils Tests', () {
    late Directory tempDir;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp('file_utils_test');
    });

    tearDownAll(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('should sanitize filename correctly', () {
      // Test various invalid characters
      expect(FileUtils.sanitizeFilename('file<name>'), equals('file_name_'));
      expect(FileUtils.sanitizeFilename('file:name'), equals('file_name'));
      expect(FileUtils.sanitizeFilename('file"name'), equals('file_name'));
      expect(FileUtils.sanitizeFilename('file/name'), equals('file_name'));
      expect(FileUtils.sanitizeFilename('file\\name'), equals('file_name'));
      expect(FileUtils.sanitizeFilename('file|name'), equals('file_name'));
      expect(FileUtils.sanitizeFilename('file?name'), equals('file_name'));
      expect(FileUtils.sanitizeFilename('file*name'), equals('file_name'));
      
      // Test spaces
      expect(FileUtils.sanitizeFilename('file name test'), equals('file_name_test'));
      expect(FileUtils.sanitizeFilename('  file   name  '), equals('__file___name__'));
      
      // Test uppercase conversion
      expect(FileUtils.sanitizeFilename('FileName'), equals('filename'));
      expect(FileUtils.sanitizeFilename('FILE_NAME'), equals('file_name'));
      
      // Test already valid filename
      expect(FileUtils.sanitizeFilename('valid_filename'), equals('valid_filename'));
      expect(FileUtils.sanitizeFilename('file123'), equals('file123'));
    });

    test('should ensure directory exists', () async {
      final testDir = '${tempDir.path}/test_subdir/nested';
      
      // Directory should not exist initially
      expect(await Directory(testDir).exists(), isFalse);
      
      // Create the directory
      await FileUtils.ensureDirectoryExists(testDir);
      
      // Directory should now exist
      expect(await Directory(testDir).exists(), isTrue);
    });

    test('should not fail when directory already exists', () async {
      final testDir = '${tempDir.path}/existing_dir';
      
      // Create directory first
      await Directory(testDir).create();
      expect(await Directory(testDir).exists(), isTrue);
      
      // Calling ensureDirectoryExists should not fail
      await FileUtils.ensureDirectoryExists(testDir);
      expect(await Directory(testDir).exists(), isTrue);
    });

    test('should check if file is readable', () async {
      // Test non-existent file
      final nonExistentFile = '${tempDir.path}/non_existent.txt';
      expect(await FileUtils.isFileReadable(nonExistentFile), isFalse);
      
      // Test empty file
      final emptyFile = File('${tempDir.path}/empty.txt');
      await emptyFile.create();
      expect(await FileUtils.isFileReadable(emptyFile.path), isFalse);
      
      // Test file with content
      final fileWithContent = File('${tempDir.path}/content.txt');
      await fileWithContent.writeAsString('test content');
      expect(await FileUtils.isFileReadable(fileWithContent.path), isTrue);
    });

    test('should handle file check errors gracefully', () async {
      // Test with invalid path (this should not throw but return false)
      expect(await FileUtils.isFileReadable(''), isFalse);
      expect(await FileUtils.isFileReadable('/invalid/path/that/does/not/exist'), isFalse);
    });
  });
}