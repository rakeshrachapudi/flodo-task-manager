# Flodo Task Manager
A full-stack task management application built with Flutter and Flask, featuring task dependency handling, search, and filtering. The backend is deployed on Render and connected via REST APIs.

## Tech Stack
- Flutter (Frontend)
- Flask + SQLite (Backend)
- REST APIs
- Render (Deployment)

## Features
- Create, read, update, delete tasks
- Status filtering
- Search functionality
- Task dependency (blocked tasks until prerequisite is completed)

## How to Run

### Backend
cd backend  
pip install -r requirements.txt  
python run.py  

### Flutter App
cd flutter_app  
flutter pub get  
flutter run

## Testing
Basic API tests are included using Python's unittest module to validate endpoints such as:
- GET /api/tasks
- POST /api/tasks

## Live API
https://flodo-task-manager-backend.onrender.com/api/tasks

![Screenshot_2026-04-01-12-41-31-52_f85c8a5b842e09dff77071c553e5936f](https://github.com/user-attachments/assets/d13f1f8d-140b-471c-a59d-9d6421caa8f2)
![Screenshot_2026-04-01-12-41-49-71_f85c8a5b842e09dff77071c553e5936f](https://github.com/user-attachments/assets/4d306b76-a601-4ad4-a9c7-9d510dca30bd)
![Screenshot_2026-04-01-12-42-12-49_f85c8a5b842e09dff77071c553e5936f](https://github.com/user-attachments/assets/c509e28c-ba40-491e-875c-0a3d189fc4e7)
![Screenshot_2026-04-01-12-40-25-54_f85c8a5b842e09dff77071c553e5936f](https://github.com/user-attachments/assets/0a69d0bd-40ea-477c-8eba-6b2e19066cdf)
![Screenshot_2026-04-01-12-41-25-75_f85c8a5b842e09dff77071c553e5936f](https://github.com/user-attachments/assets/1661d908-a1ed-4b72-82a7-dd38f7727a08)
![Screenshot_2026-04-01-05-40-33-86_f85c8a5b842e09dff77071c553e5936f](https://github.com/user-attachments/assets/fbbc8e21-aa1a-48db-9912-6aa9d9acbf92)

## Notes
- SQLite is on Render free tier so it may reset on restart
