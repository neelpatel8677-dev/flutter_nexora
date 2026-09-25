import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  bool _loading = true;
  List<dynamic> _activities = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiService.getActivities();
      setState(() {
        _activities = res['data'] ?? [];
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
        title: const Text('My Activities'),
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _activities.isEmpty
              ? const Center(child: Text('No activities yet'))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _activities.length,
                    itemBuilder: (ctx, i) {
                      final a = _activities[i];
                      final status = a['status'] ?? 'pending';
                      Color color = status == 'completed'
                          ? Colors.green
                          : status == 'in-progress'
                              ? Colors.orange
                              : Colors.grey;
                      return Card(
                        child: ListTile(
                          title: Text(a['title'] ?? ''),
                          subtitle: Text(a['description'] ?? a['type'] ?? ''),
                          trailing: Chip(
                            label: Text(status, style: const TextStyle(fontSize: 11, color: Colors.white)),
                            backgroundColor: color,
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
