import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  List<dynamic> _students = [];
  final Map<String, String> _statusMap = {};
  final _subjectController = TextEditingController();
  bool _loading = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final res = await ApiService.getStudents();
      setState(() {
        _students = res['data'] ?? [];
        for (var s in _students) {
          _statusMap[s['_id']] = 'present';
        }
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    if (_subjectController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter subject')));
      return;
    }

    setState(() => _submitting = true);
    try {
      final records = _statusMap.entries
          .map((e) => {'studentId': e.key, 'status': e.value})
          .toList();

      await ApiService.bulkMarkAttendance({
        'subject': _subjectController.text.trim(),
        'records': records,
        'lectureNumber': 1,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance marked successfully'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colors.red));
      }
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _students.length,
                    itemBuilder: (ctx, i) {
                      final s = _students[i];
                      final id = s['_id'];
                      return ListTile(
                        title: Text(s['name'] ?? ''),
                        subtitle: Text(s['studentId'] ?? ''),
                        trailing: DropdownButton<String>(
                          value: _statusMap[id],
                          items: const [
                            DropdownMenuItem(value: 'present', child: Text('Present')),
                            DropdownMenuItem(value: 'absent', child: Text('Absent')),
                            DropdownMenuItem(value: 'late', child: Text('Late')),
                          ],
                          onChanged: (v) => setState(() => _statusMap[id] = v!),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                      ),
                      child: _submitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Submit Attendance'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
