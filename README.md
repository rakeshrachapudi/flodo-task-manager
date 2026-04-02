# Flodo Task Manager
A full-stack task management application built with Flutter and Flask, featuring task dependency handling, search, and filtering. The backend is deployed on Render and connected via REST APIs.

## Tech Stack - (Trach - A)
- Flutter (Frontend)
- Flask + SQLite (Backend)
- REST APIs
- Render (Deployment)

## Features
- Create, read, update, delete tasks
- Status filtering
- Search functionality
- Task dependency (blocked tasks until prerequisite is completed)

## Stretch Goal
- Debounced autocomplete search functionality

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

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/d13f1f8d-140b-471c-a59d-9d6421caa8f2" width="120"/>
  <img src="https://github.com/user-attachments/assets/4d306b76-a601-4ad4-a9c7-9d510dca30bd" width="120"/>
  <img src="https://github.com/user-attachments/assets/c509e28c-ba40-491e-875c-0a3d189fc4e7" width="120"/>
  <img src="https://github.com/user-attachments/assets/0a69d0bd-40ea-477c-8eba-6b2e19066cdf" width="120"/>
  <img src="https://github.com/user-attachments/assets/1661d908-a1ed-4b72-82a7-dd38f7727a08" width="120"/>
  <img src="https://github.com/user-attachments/assets/fbbc8e21-aa1a-48db-9912-6aa9d9acbf92" width="120"/>
</p>

## Notes
- SQLite is on Render free tier so it may reset on restart

## AI Usage Report

### Tools Used
- ChatGPT (architecture guidance, debugging, deployment help)
- Perplexity AI (used for generating larger code blocks from structured prompts)

### How I Used AI
- Used ChatGPT to design the overall architecture (Flutter + Flask + SQLite)
- Generated structured prompts using ChatGPT and passed them to Perplexity to produce larger code implementations efficiently
- Used ChatGPT extensively for:
  - Debugging backend and API issues
  - Fixing Flutter UI bugs
  - Understanding deployment (Render, Gunicorn)
  - Validating design decisions

### Workflow Strategy
- ChatGPT → Used for thinking, debugging, and prompt engineering
- Perplexity → Used for bulk code generation based on refined prompts

This approach helped me move faster while still maintaining control over the code quality and structure.

### Challenges / AI Mistakes
- AI suggested an incorrect Flask import pattern (`from app import app`) which caused deployment issues
- Fixed by switching back to the application factory pattern (`create_app()`), which is required for production servers like Gunicorn

### What I Learned
- Structuring a full-stack Flutter + Flask application
- Handling async UI states with proper loading indicators
- Debugging API validation errors
- Deploying backend services properly using production-ready setups
- Using AI tools effectively by combining their strengths instead of relying on a single tool
