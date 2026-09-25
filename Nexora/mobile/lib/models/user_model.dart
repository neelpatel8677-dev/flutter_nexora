class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? studentId;
  final String? employeeId;
  final String? course;
  final int? semester;
  final String? batch;
  final String? department;
  final List<String>? subjects;
  final bool isActive;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.studentId,
    this.employeeId,
    this.course,
    this.semester,
    this.batch,
    this.department,
    this.subjects,
    this.isActive = true,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'],
      studentId: json['studentId'],
      employeeId: json['employeeId'],
      course: json['course'],
      semester: json['semester'],
      batch: json['batch'],
      department: json['department'],
      subjects: json['subjects'] != null
          ? List<String>.from(json['subjects'])
          : null,
      isActive: json['isActive'] ?? true,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'studentId': studentId,
      'employeeId': employeeId,
      'course': course,
      'semester': semester,
      'batch': batch,
      'department': department,
      'subjects': subjects,
      'isActive': isActive,
      'token': token,
    };
  }

  bool get isStudent => role == 'student';
  bool get isFaculty => role == 'faculty';
  bool get isAdmin => role == 'admin';
}
