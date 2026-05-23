import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/cloudinary_config.dart';

class CloudinaryService {
  /// Uploads an image to Cloudinary and returns the secure URL
  static Future<String> uploadAadhaar(File imageFile) async {
    final String cloudName = CloudinaryConfig.cloudName;
    final String uploadPreset = CloudinaryConfig.uploadPreset;
    
    final Uri url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
    
    final http.MultipartRequest request = http.MultipartRequest("POST", url);
    request.fields['upload_preset'] = uploadPreset;
    
    // Attach the file
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );
    
    try {
      final http.StreamedResponse response = await request.send();
      final String responseString = await response.stream.bytesToString();
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(responseString);
        final String? secureUrl = responseData['secure_url'];
        if (secureUrl != null) {
          return secureUrl;
        }
        throw Exception("secure_url not found in Cloudinary response");
      } else {
        final Map<String, dynamic> errorData = jsonDecode(responseString);
        final String errorMsg = errorData['error']?['message'] ?? "Unknown Cloudinary error";
        throw Exception("Cloudinary upload failed (${response.statusCode}): $errorMsg");
      }
    } catch (e) {
      throw Exception("Failed to upload image to Cloudinary: $e");
    }
  }
}
