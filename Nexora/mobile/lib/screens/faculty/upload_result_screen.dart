import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class UploadResultScreen extends StatefulWidget {
  const UploadResultScreen({super.key});

  @override
  State<UploadResultScreen> createState() => _UploadResultScreenState();
}

class _UploadResultScreenState extends State<UploadResultScreen> {
  List<dynamic> _students = [];
  String? _selectedStudent;
  int _semester = 1;
  final _subjectController = TextEditingController();
  final _marksController = TextEditingController();
  final List<Map<String, dynamic>> _subjects = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ApiService.getStudents();
      setState(() {
        _students = res['data'] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _addSubject() {
    if (_subjectController.text.isEmpty || _marksController.text.isEmpty) return;
    setState(() {
      _subjects.add({
        'subject': _subjectController.text.trim(),
        'marksObtained': double.parse(_marksController.text),
        'maxMarks': 100,
      });
      _subjectController.clear();
      _marksController.clear();
    });
  }

  Future<void> _submit() async {
    if (_selectedStudent == null || _subjects.isEmpty) return;
    try {
      await ApiService.createResult({
        'student': _selectedStudent,
        'semester': _semester,
        'examType': 'final',
        'subjects': _subjects,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Result uploaded'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Result'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedStudent,
                    decoration: const InputDecoration(labelText: 'Student', border: OutlineInputBorder()),
                    items: _students
                        .map((s) => DropdownMenuItem(value: s['_id'] as String, child: Text('${s['name']} (${s['studentId']})')))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedStudent = v),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: _semester,
                    decoration: const InputDecoration(labelText: 'Semester', border: OutlineInputBorder()),
                    items: List.generate(8, (i) => DropdownMenuItem(value: i + 1, child: Text('Semester ${i + 1}'))),
                    onChanged: (v) => setState(() => _semester = v ?? 1),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _subjectController,
                          decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: _marksController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Marks', border: OutlineInputBorder()),
                        ),
                      ),
                      IconButton(onPressed: _addSubject, icon: const Icon(Icons.add_circle, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._subjects.map((s) => ListTile(
                        title: Text(s['subject']),
                        trailing: Text('${s['marksObtained']}/100'),
                      )),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1), foregroundColor: Colors.white),
                      child: const Text('Upload Result'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
