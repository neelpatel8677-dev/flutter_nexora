import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _students = 0;
  int _faculty = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final studentsRes = await ApiService.getUsers(role: 'student');
      final facultyRes = await ApiService.getUsers(role: 'faculty');
      setState(() {
        _students = studentsRes['count'] ?? 0;
        _faculty = facultyRes['count'] ?? 0;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexora - Admin'),
        backgroundColor: const Color(0xFFB71C1C),
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('System Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text('$_students', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue)),
                                const Text('Students'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          color: Colors.green.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text('$_faculty', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
                                const Text('Faculty'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Admin Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.people, color: Colors.blue),
                      title: const Text('Manage Students & Faculty'),
                      subtitle: const Text('View, edit, deactivate users'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Can expand to full user management screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Use API / Postman for full user management. Full UI can be extended.')),
                        );
                      },
                    ),
                  ),
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.settings, color: Colors.grey),
                      title: Text('System Settings'),
                      subtitle: Text('Admin is fixed. No public registration for admin.'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Default Admin Login:\nEmail: admin@nexora.com\nPassword: Admin@123\n\n(Change after first login in production)',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
    );
  }
}
