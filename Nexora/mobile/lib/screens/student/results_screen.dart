import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _loading = true;
  List<dynamic> _results = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiService.getResults();
      setState(() {
        _results = res['data'] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Results'),
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text('No results uploaded yet'))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _results.length,
                    itemBuilder: (ctx, i) {
                      final r = _results[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          title: Text('Semester ${r['semester']} - ${r['examType'] ?? 'Exam'}'),
                          subtitle: Text('Percentage: ${r['percentage']}% | CGPA: ${r['cgpa']}'),
                          children: [
                            ...(r['subjects'] as List? ?? []).map((s) {
                              return ListTile(
                                title: Text(s['subject'] ?? ''),
                                trailing: Text('${s['marksObtained']}/${s['maxMarks'] ?? 100} (${s['grade'] ?? ''})'),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
