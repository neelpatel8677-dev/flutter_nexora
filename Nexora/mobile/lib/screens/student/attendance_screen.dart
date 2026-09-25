import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _loading = true;
  Map<String, dynamic>? _summary;
  List<dynamic> _records = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await ApiService.getAttendance();
      setState(() {
        _summary = res['summary'];
        _records = res['data'] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Attendance'),
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (_summary != null)
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  '${_summary!['percentage']}%',
                                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1A73E8)),
                                ),
                                const Text('Overall Attendance'),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _stat('Present', '${_summary!['present']}', Colors.green),
                                    _stat('Absent', '${_summary!['absent']}', Colors.red),
                                    _stat('Late', '${_summary!['late']}', Colors.orange),
                                    _stat('Total', '${_summary!['total']}', Colors.blue),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      const Text('Recent Records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ..._records.map((r) {
                        final status = r['status'] ?? '';
                        Color color = status == 'present'
                            ? Colors.green
                            : status == 'absent'
                                ? Colors.red
                                : Colors.orange;
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color.withValues(alpha: 0.2),
                              child: Icon(
                                status == 'present' ? Icons.check : status == 'absent' ? Icons.close : Icons.access_time,
                                color: color,
                              ),
                            ),
                            title: Text(r['subject'] ?? ''),
                            subtitle: Text('Lecture ${r['lectureNumber']} • ${r['date']?.toString().substring(0, 10) ?? ''}'),
                            trailing: Text(status.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
