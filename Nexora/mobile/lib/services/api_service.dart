import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  static String? _token;

  static void setToken(String? token) {
    _token = token;
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // Auth
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/register'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> getMe() async {
    final res = await http.get(
      Uri.parse('${AppConstants.baseUrl}/auth/me'),
      headers: _headers,
    );
    return _handleResponse(res);
  }

  // Users
  static Future<Map<String, dynamic>> getUsers({String? role, String? search}) async {
    var url = '${AppConstants.baseUrl}/users';
    final params = <String>[];
    if (role != null) params.add('role=$role');
    if (search != null) params.add('search=$search');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final res = await http.get(Uri.parse(url), headers: _headers);
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> getStudents({String? course, int? semester}) async {
    var url = '${AppConstants.baseUrl}/users/students';
    final params = <String>[];
    if (course != null) params.add('course=$course');
    if (semester != null) params.add('semester=$semester');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final res = await http.get(Uri.parse(url), headers: _headers);
    return _handleResponse(res);
  }

  // Attendance
  static Future<Map<String, dynamic>> getAttendance({String? studentId, String? subject}) async {
    var url = '${AppConstants.baseUrl}/attendance';
    final params = <String>[];
    if (studentId != null) params.add('studentId=$studentId');
    if (subject != null) params.add('subject=$subject');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final res = await http.get(Uri.parse(url), headers: _headers);
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> getLectureWise({String? subject, String? studentId}) async {
    var url = '${AppConstants.baseUrl}/attendance/lecture-wise';
    final params = <String>[];
    if (subject != null) params.add('subject=$subject');
    if (studentId != null) params.add('studentId=$studentId');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final res = await http.get(Uri.parse(url), headers: _headers);
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> markAttendance(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/attendance'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> bulkMarkAttendance(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/attendance/bulk'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  // Fees
  static Future<Map<String, dynamic>> getFees({String? studentId, String? status}) async {
    var url = '${AppConstants.baseUrl}/fees';
    final params = <String>[];
    if (studentId != null) params.add('studentId=$studentId');
    if (status != null) params.add('status=$status');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final res = await http.get(Uri.parse(url), headers: _headers);
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> createFee(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/fees'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> updateFee(String id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('${AppConstants.baseUrl}/fees/$id'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  // Results
  static Future<Map<String, dynamic>> getResults({String? studentId, int? semester}) async {
    var url = '${AppConstants.baseUrl}/results';
    final params = <String>[];
    if (studentId != null) params.add('studentId=$studentId');
    if (semester != null) params.add('semester=$semester');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final res = await http.get(Uri.parse(url), headers: _headers);
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> createResult(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/results'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  // Notes
  static Future<Map<String, dynamic>> getNotes({String? subject, int? semester}) async {
    var url = '${AppConstants.baseUrl}/notes';
    final params = <String>[];
    if (subject != null) params.add('subject=$subject');
    if (semester != null) params.add('semester=$semester');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final res = await http.get(Uri.parse(url), headers: _headers);
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> createNote(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/notes'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  // Timetable
  static Future<Map<String, dynamic>> getTimetable({String? course, int? semester}) async {
    var url = '${AppConstants.baseUrl}/timetable';
    final params = <String>[];
    if (course != null) params.add('course=$course');
    if (semester != null) params.add('semester=$semester');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final res = await http.get(Uri.parse(url), headers: _headers);
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> createTimetable(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/timetable'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  // Activities
  static Future<Map<String, dynamic>> getActivities({String? studentId, String? status}) async {
    var url = '${AppConstants.baseUrl}/activities';
    final params = <String>[];
    if (studentId != null) params.add('studentId=$studentId');
    if (status != null) params.add('status=$status');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final res = await http.get(Uri.parse(url), headers: _headers);
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> createActivity(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/activities'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  // AI
  static Future<Map<String, dynamic>> askAI(String question) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/ai/ask'),
      headers: _headers,
      body: jsonEncode({'question': question}),
    );
    return _handleResponse(res);
  }

  static Map<String, dynamic> _handleResponse(http.Response res) {
    final body = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return body;
    } else {
      throw Exception(body['message'] ?? 'Something went wrong');
    }
  }
}
