import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  // Change this if you want to test another parent
  final parentId = 'PAR_b847ca58';

  // Build the URL with query params
  final uri = Uri.parse('http://20.192.25.27:6969/get-parent-requests')
      .replace(queryParameters: {'parent_id': parentId});

  try {
    final resp = await http.get(uri, headers: {'Accept': 'application/json'});
    print('Status: ${resp.statusCode}');

    if (resp.statusCode == 200) {
      final dynamic body = jsonDecode(resp.body);
      final pretty = const JsonEncoder.withIndent('  ').convert(body);
      print('Body:\n$pretty');

      // Optional: quick peek at first request fields your Dart mapper uses
      if (body is Map && body['requests'] is List && (body['requests'] as List).isNotEmpty) {
        final first = (body['requests'] as List).first;
        if (first is Map) {
          print('First request: _id=${first['_id']}, type=${first['request_type']}, applied_from=${first['applied_from']}');
        }
      }
    } else {
      print('Error body: ${resp.body}');
    }
  } catch (e) {
    print('Request failed: $e');
  }
}
