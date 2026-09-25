# Nexora Backend

Student Management System API - Node.js + Express + MongoDB

## Features
- JWT Authentication
- Role-based access (Student / Faculty / Admin)
- Attendance (single + bulk + lecture-wise)
- Fees management
- Results upload & view
- Notes upload
- Timetable
- Activities / Progress
- AI Q&A endpoint (demo + ready for real AI)

## Setup

1. Install dependencies
```bash
cd backend
npm install
```

2. Create `.env` file
```bash
cp .env.example .env
```
Edit the values (especially `MONGODB_URI` and `JWT_SECRET`).

3. Make sure MongoDB is running locally (or use MongoDB Atlas URI).

4. Seed Admin account
```bash
npm run seed
```
Default Admin:
- Email: `admin@nexora.com`
- Password: `Admin@123`

5. Start server
```bash
npm run dev
```
Server runs on `http://localhost:5000`

## API Endpoints

### Auth
- `POST /api/auth/register` - Register (student/faculty only)
- `POST /api/auth/login` - Login
- `GET /api/auth/me` - Current user

### Users (Admin)
- `GET /api/users` - All users
- `GET /api/users/students` - Get students
- `PUT /api/users/:id` - Update
- `DELETE /api/users/:id` - Deactivate

### Attendance
- `GET /api/attendance` - List
- `GET /api/attendance/lecture-wise` - Lecture wise
- `POST /api/attendance` - Mark
- `POST /api/attendance/bulk` - Bulk mark

### Fees
- `GET /api/fees`
- `POST /api/fees`
- `PUT /api/fees/:id`

### Results
- `GET /api/results`
- `POST /api/results`
- `PUT /api/results/:id`

### Notes
- `GET /api/notes`
- `POST /api/notes`
- `PUT /api/notes/:id`
- `DELETE /api/notes/:id`

### Timetable
- `GET /api/timetable`
- `POST /api/timetable`
- `PUT /api/timetable/:id`

### Activities
- `GET /api/activities`
- `POST /api/activities`
- `PUT /api/activities/:id`

### AI
- `POST /api/ai/ask` - Ask AI (Student only)

## Headers
All protected routes need:
```
Authorization: Bearer <token>
```
