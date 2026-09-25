import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'mark_attendance_screen.dart';
import 'manage_fees_screen.dart';
import 'upload_result_screen.dart';
import 'upload_notes_screen.dart';
import '../student/timetable_screen.dart';

class FacultyDashboard extends StatelessWidget {
  const FacultyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexora - Faculty'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF1565C0)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome, ${user.name}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${user.employeeId ?? ''} • ${user.department ?? ''}', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Manage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _menuTile(context, Icons.how_to_reg, 'Mark Attendance', Colors.green, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MarkAttendanceScreen()));
            }),
            _menuTile(context, Icons.account_balance_wallet, 'Manage Fees', Colors.orange, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageFeesScreen()));
            }),
            _menuTile(context, Icons.grade, 'Upload Results', Colors.purple, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadResultScreen()));
            }),
            _menuTile(context, Icons.note_add, 'Upload Notes', Colors.teal, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadNotesScreen()));
            }),
            _menuTile(context, Icons.schedule, 'View Timetable', Colors.indigo, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TimetableScreen()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.2), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
