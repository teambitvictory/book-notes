import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class BackendConnector {
  // FIXME Move this to a proxy server before distributing the app
  static final _apiKey = dotenv.env['OPENAI_API_KEY'];

  static Future<bool> _makeModerationRequest(String input) async {
    var url = Uri.https('api.openai.com', 'v1/moderations');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey'
      },
      body: jsonEncode(<String, String>{
        'input': input,
      }),
    );
    return json.decode(response.body)['results'][0]['flagged'];
  }

  static Future<String> makeGPTRequest(String input) async {
    if (await _makeModerationRequest(input)) {
      return 'BAD';
    }
    var url = Uri.https('api.openai.com', 'v1/completions');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey'
      },
      body: jsonEncode({
        'model': 'text-davinci-003',
        'prompt':
            'clean up and improve the following text and remove information about the book and page: $input',
        'temperature': 0.3,
        'max_tokens': 1024
      }),
    );
    return json.decode(response.body)['choices'][0]['text'];
  }

  static Future<String> makeWhisperRequest(String audioFilePath) async {
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        'http://10.0.2.2:9001/asr?language=en',
      ),
    );
    request.files.add(await http.MultipartFile.fromPath(
      'audio_file',
      '$audioFilePath/temp.m4a',
      contentType: MediaType('application', 'audio/mp4'),
    ));
    request.headers.addAll(headers);
    var response = await http.Response.fromStream(await request.send());
    return json.decode(response.body)['text'];
  }
}
