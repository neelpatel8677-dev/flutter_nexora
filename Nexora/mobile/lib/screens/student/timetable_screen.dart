import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  bool _loading = true;
  List<dynamic> _timetables = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiService.getTimetable();
      setState(() {
        _timetables = res['data'] ?? [];
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
        title: const Text('Timetable'),
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _timetables.isEmpty
              ? const Center(child: Text('No timetable available'))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _timetables.length,
                    itemBuilder: (ctx, i) {
                      final t = _timetables[i];
                      final periods = t['periods'] as List? ?? [];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          title: Text('${t['course']} - Sem ${t['semester']}'),
                          subtitle: Text(t['academicYear'] ?? ''),
                          children: periods.map((p) {
                            return ListTile(
                              title: Text(p['subject'] ?? ''),
                              subtitle: Text('${p['day']} • ${p['startTime']} - ${p['endTime']}'),
                              trailing: Text(p['room'] ?? ''),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
