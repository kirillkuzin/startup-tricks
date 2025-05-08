// This function downloads a file from a given URL using a POST request with custom headers and body.
// It returns an FFUploadedFile object containing the file's name and binary data.


import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Extracts the file extension from the given URL
String getFileExtension(String url) {
  final uri = Uri.parse(url);
  final segments = uri.pathSegments;
  final lastSegment = segments.isNotEmpty ? segments.last : '';
  final extension = lastSegment.contains('.') ? lastSegment.split('.').last : 'bin';
  return extension;
}

/// Generates a random filename with the given extension
String generateRandomFilename(String extension) {
  final uuid = Uuid().v4();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return '$uuid-$timestamp.$extension';
}

/// Downloads a file from the given URL using a POST request with custom headers and body
///
/// [url] - The file download URL
/// [headers] - Map of headers to include in the POST request
/// [body] - Request body data to be sent with the POST request
///
/// Returns an [FFUploadedFile] containing the downloaded file's name and bytes
Future<FFUploadedFile> downloadFile(
  String url,
  Map<String, String> headers,
  dynamic body,
) async {
  try {
    // Perform the POST request with the provided headers and body
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    // Check the response status code
    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    // Extract file extension from the URL
    final extension = getFileExtension(url);

    // Generate a random filename with the extracted extension
    final fileName = generateRandomFilename(extension);

    // Create an FFUploadedFile object with the received file bytes and filename
    final ffUploadedFile = FFUploadedFile(
      name: fileName,
      bytes: response.bodyBytes,
    );

    return ffUploadedFile;
  } catch (e) {
    // Handle any errors during the download process
    throw Exception('Download failed: $e');
  }
}
