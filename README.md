# Nexora

Student Management System with a Flutter mobile application and Node.js backend.

## Mobile App

The Flutter application is in [`Nexora/mobile`](Nexora/mobile).

```bash
cd Nexora/mobile
flutter pub get
flutter run
```

## Backend

The Node.js + Express + MongoDB API is in [`Nexora/backend`](Nexora/backend).

### Features

- JWT Authentication
- Role-based access (Student / Faculty / Admin)
- Attendance (single + bulk + lecture-wise)
- Fees management
- Results upload & view
- Notes upload
- Timetable
- Activities / Progress
- AI Q&A endpoint (demo + ready for real AI)

### Setup

1. Install dependencies:

   ```bash
   cd Nexora/backend
   npm install
   ```

2. Create `.env` from the template:

   ```bash
   cp .env.example .env
   ```

   Edit the values, especially `MONGODB_URI` and `JWT_SECRET`.

3. Make sure MongoDB is running locally or use a MongoDB Atlas URI.

4. Seed the admin account:

   ```bash
   npm run seed
   ```

   Default admin:
   - Email: `admin@nexora.com`
   - Password: `Admin@123`

5. Start the server:

   ```bash
   npm run dev
   ```

   The server runs at `http://localhost:5000`.

### API Endpoints

- `POST /api/auth/register` - Register (student/faculty only)
- `POST /api/auth/login` - Login
- `GET /api/auth/me` - Current user
- `GET /api/users` - All users
- `GET /api/users/students` - Get students
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Deactivate user
- `GET|POST /api/attendance` - Attendance
- `GET /api/attendance/lecture-wise` - Lecture-wise attendance
- `POST /api/attendance/bulk` - Bulk attendance
- `GET|POST|PUT /api/fees` - Fees
- `GET|POST|PUT /api/results` - Results
- `GET|POST|PUT|DELETE /api/notes` - Notes
- `GET|POST|PUT /api/timetable` - Timetable
- `GET|POST|PUT /api/activities` - Activities
- `POST /api/ai/ask` - Ask AI (student only)

All protected routes require:

```text
Authorization: Bearer <token>
```
