import unittest
from urllib import response
from app import create_app

class TaskAPITestCase(unittest.TestCase):
    def setUp(self):
        self.app = create_app().test_client()
        self.app.testing = True

    def test_get_tasks(self):
        response = self.app.get('/api/tasks')
        self.assertEqual(response.status_code, 200)

    def test_create_task(self):
        response = self.app.post('/api/tasks', json={
            "title": "Test Task",
            "description": "Testing",
            "dueDate": "2026-04-25",
            "status": "To-Do",
            "isBlocked": False,
            "blockedBy": None
        })
        self.assertEqual(response.status_code, 201)

if __name__ == "__main__":
    unittest.main()