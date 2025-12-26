import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static Future<String> uploadImage(File image) async {
    const cloudName = "daz4h7pjt";
    const uploadPreset = "chat_app_preset";

    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        image.path,
      ));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    final data = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw Exception(data['error']['message']);
    }

    return data['secure_url'];
  }
}
