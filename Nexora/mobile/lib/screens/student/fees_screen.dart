import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  bool _loading = true;
  Map<String, dynamic>? _summary;
  List<dynamic> _fees = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiService.getFees();
      setState(() {
        _summary = res['summary'];
        _fees = res['data'] ?? [];
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
        title: const Text('My Fees'),
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_summary != null)
                    Row(
                      children: [
                        Expanded(child: _summaryCard('Total', '₹${_summary!['total']}', Colors.blue)),
                        const SizedBox(width: 8),
                        Expanded(child: _summaryCard('Paid', '₹${_summary!['paid']}', Colors.green)),
                        const SizedBox(width: 8),
                        Expanded(child: _summaryCard('Pending', '₹${_summary!['pending']}', Colors.red)),
                      ],
                    ),
                  const SizedBox(height: 16),
                  ..._fees.map((f) {
                    final status = f['status'] ?? 'pending';
                    Color color = status == 'paid' ? Colors.green : status == 'overdue' ? Colors.red : Colors.orange;
                    return Card(
                      child: ListTile(
                        title: Text('${f['feeType']?.toString().toUpperCase() ?? 'FEE'} - ₹${f['amount']}'),
                        subtitle: Text('Due: ${f['dueDate']?.toString().substring(0, 10) ?? ''}'),
                        trailing: Chip(
                          label: Text(status.toUpperCase(), style: const TextStyle(fontSize: 11, color: Colors.white)),
                          backgroundColor: color,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
