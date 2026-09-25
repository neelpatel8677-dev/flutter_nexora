import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ManageFeesScreen extends StatefulWidget {
  const ManageFeesScreen({super.key});

  @override
  State<ManageFeesScreen> createState() => _ManageFeesScreenState();
}

class _ManageFeesScreenState extends State<ManageFeesScreen> {
  List<dynamic> _students = [];
  final _amountController = TextEditingController();
  String? _selectedStudent;
  String _feeType = 'tuition';
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

  Future<void> _create() async {
    if (_selectedStudent == null || _amountController.text.isEmpty) return;

    try {
      await ApiService.createFee({
        'student': _selectedStudent,
        'amount': double.parse(_amountController.text),
        'feeType': _feeType,
        'dueDate': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fee created'), backgroundColor: Colors.green),
        );
        _amountController.clear();
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
        title: const Text('Manage Fees'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedStudent,
                    decoration: const InputDecoration(labelText: 'Select Student', border: OutlineInputBorder()),
                    items: _students
                        .map((s) => DropdownMenuItem(value: s['_id'] as String, child: Text('${s['name']} (${s['studentId']})')))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedStudent = v),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _feeType,
                    decoration: const InputDecoration(labelText: 'Fee Type', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'tuition', child: Text('Tuition')),
                      DropdownMenuItem(value: 'exam', child: Text('Exam')),
                      DropdownMenuItem(value: 'library', child: Text('Library')),
                      DropdownMenuItem(value: 'hostel', child: Text('Hostel')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: (v) => setState(() => _feeType = v!),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _create,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1), foregroundColor: Colors.white),
                      child: const Text('Create Fee Record'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
