# Nexora - Student Management System

Complete full-stack project with:

- **Backend**: Node.js + Express + MongoDB
- **Mobile App**: Flutter (Android + iOS)
- **Auth**: JWT with role-based access (Student / Faculty / Admin)

## Project Structure

```
Nexora/
├── backend/          # Node.js + Express API
│   ├── config/
│   ├── controllers/
│   ├── middleware/
│   ├── models/
│   ├── routes/
│   ├── utils/
│   ├── server.js
│   ├── package.json
│   └── README.md
├── mobile/           # Flutter App
│   ├── lib/
│   ├── pubspec.yaml
│   └── README.md
└── README.md
```

## Quick Start

### 1. Backend

```bash
cd backend
npm install
cp .env.example .env
# Edit .env if needed (MongoDB URI, JWT secret)
npm run seed          # Creates admin account
npm run dev           # Starts on http://localhost:5000
```

**Default Admin**
- Email: `admin@nexora.com`
- Password: `Admin@123`

### 2. Mobile App

```bash
cd mobile
flutter pub get
# Edit lib/utils/constants.dart → set correct baseUrl
flutter run
```

## Features Summary

| Feature              | Student | Faculty | Admin |
|----------------------|---------|---------|-------|
| Register             | ✅      | ✅      | ❌ (fixed) |
| Login                | ✅      | ✅      | ✅ |
| View Attendance      | ✅      | ✅      | ✅ |
| Mark Attendance      | ❌      | ✅      | ✅ |
| Fees                 | View    | Manage  | Manage |
| Results              | View    | Upload  | Manage |
| Notes                | View    | Upload  | Manage |
| Timetable            | View    | Manage  | Manage |
| Activities           | View    | Manage  | Manage |
| AI Assistant         | ✅      | ❌      | ❌ |
| Manage Users         | ❌      | ❌      | ✅ |

## API Base URL
`http://localhost:5000/api`

All protected routes require header:
```
Authorization: Bearer <token>
```

## Notes
- AI endpoint currently has smart demo responses. Replace with real OpenAI/Gemini/Grok API in `backend/controllers/aiController.js`.
- File upload for notes can be extended with Multer + Cloudinary/S3.
- Admin cannot be registered publicly.

Enjoy building with Nexora! 🚀
```
