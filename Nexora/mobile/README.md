# Nexora Mobile App (Flutter)

## Prerequisites
- Flutter SDK (>=3.0)
- Android Studio / VS Code
- Backend running on port 5000

## Setup

1. Open terminal in `mobile` folder

2. Get packages
```bash
flutter pub get
```

3. **Important - Change API URL**

Edit `lib/utils/constants.dart`:

- **Android Emulator**: `http://10.0.2.2:5000/api` (already set)
- **Real Device**: Replace with your computer's local IP  
  Example: `http://192.168.1.5:5000/api`
- **iOS Simulator**: `http://localhost:5000/api`

4. Run the app
```bash
flutter run
```

## Features

### Student
- Login / Register
- Dashboard with quick access
- Attendance (overall % + records)
- Fees (summary + list)
- Results (semester-wise with grades)
- Notes
- Timetable
- AI Assistant chat
- Activities / Progress

### Faculty
- Mark attendance (bulk)
- Create fee records
- Upload results
- Upload notes
- View timetable

### Admin
- View system stats (students & faculty count)
- Fixed admin account (no public registration)

## Default Admin
- Email: `admin@nexora.com`
- Password: `Admin@123`

## Project Structure
```
lib/
├── main.dart
├── models/
├── providers/
├── services/
├── screens/
│   ├── auth/
│   ├── student/
│   ├── faculty/
│   └── admin/
├── utils/
└── widgets/
```
