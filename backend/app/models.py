from datetime import datetime
from . import db

class Task(db.Model):
    __tablename__ = "tasks"

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(120), nullable=False)
    description = db.Column(db.Text, nullable=False)
    due_date = db.Column(db.String(20), nullable=False)
    status = db.Column(db.String(20), nullable=False)  # To-Do, In Progress, Done
    blocked_by = db.Column(db.Integer, db.ForeignKey("tasks.id"), nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    blocker = db.relationship("Task", remote_side=[id], uselist=False)

    def to_dict(self):
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "dueDate": self.due_date,
            "status": self.status,
            "blockedBy": self.blocked_by,
            "isBlocked": self.is_blocked(),
        }

    def is_blocked(self):
        if not self.blocked_by:
            return False
        if not self.blocker:
            return False
        return self.blocker.status != "Done"