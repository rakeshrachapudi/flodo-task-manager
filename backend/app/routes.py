import time
from flask import Blueprint, request, jsonify
from . import db
from .models import Task

task_bp = Blueprint("tasks", __name__)

VALID_STATUSES = ["To-Do", "In Progress", "Done"]

def validate_task_payload(data, editing_task_id=None):
    errors = {}

    title = (data.get("title") or "").strip()
    description = (data.get("description") or "").strip()
    due_date = (data.get("dueDate") or "").strip()
    status = (data.get("status") or "").strip()
    blocked_by = data.get("blockedBy")

    if not title:
        errors["title"] = "Title is required."
    if not description:
        errors["description"] = "Description is required."
    if not due_date:
        errors["dueDate"] = "Due date is required."
    if status not in VALID_STATUSES:
        errors["status"] = "Invalid status."

    if blocked_by is not None:
        blocker = Task.query.get(blocked_by)
        if not blocker:
            errors["blockedBy"] = "Selected blocker task does not exist."
        elif editing_task_id is not None and blocked_by == editing_task_id:
            errors["blockedBy"] = "A task cannot block itself."

    return errors

@task_bp.route("/health", methods=["GET"])
def health():
    return jsonify({"message": "API is running"})

@task_bp.route("/tasks", methods=["GET"])
def get_tasks():
    search = request.args.get("search", "").strip().lower()
    status = request.args.get("status", "").strip()

    query = Task.query.order_by(Task.created_at.desc())

    if search:
        query = query.filter(Task.title.ilike(f"%{search}%"))
    if status and status != "All":
        query = query.filter(Task.status == status)

    tasks = query.all()
    return jsonify([task.to_dict() for task in tasks])

@task_bp.route("/tasks/<int:task_id>", methods=["GET"])
def get_task(task_id):
    task = Task.query.get_or_404(task_id)
    return jsonify(task.to_dict())

@task_bp.route("/tasks", methods=["POST"])
def create_task():
    data = request.get_json() or {}
    errors = validate_task_payload(data)

    if errors:
        return jsonify({"errors": errors}), 400

    time.sleep(2)

    task = Task(
        title=data["title"].strip(),
        description=data["description"].strip(),
        due_date=data["dueDate"].strip(),
        status=data["status"].strip(),
        blocked_by=data.get("blockedBy"),
    )

    db.session.add(task)
    db.session.commit()
    return jsonify(task.to_dict()), 201

@task_bp.route("/tasks/<int:task_id>", methods=["PUT"])
def update_task(task_id):
    task = Task.query.get_or_404(task_id)
    data = request.get_json() or {}
    errors = validate_task_payload(data, editing_task_id=task_id)

    if errors:
        return jsonify({"errors": errors}), 400

    time.sleep(2)

    task.title = data["title"].strip()
    task.description = data["description"].strip()
    task.due_date = data["dueDate"].strip()
    task.status = data["status"].strip()
    task.blocked_by = data.get("blockedBy")

    db.session.commit()
    return jsonify(task.to_dict())

@task_bp.route("/tasks/<int:task_id>", methods=["DELETE"])
def delete_task(task_id):
    task = Task.query.get_or_404(task_id)

    dependent_tasks = Task.query.filter_by(blocked_by=task.id).all()
    for dependent in dependent_tasks:
        dependent.blocked_by = None

    db.session.delete(task)
    db.session.commit()

    return jsonify({"message": "Task deleted successfully"})