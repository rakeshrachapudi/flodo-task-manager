import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from .config import Config

db = SQLAlchemy()

def create_app():
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_object(Config)

    os.makedirs(app.instance_path, exist_ok=True)

    db.init_app(app)
    CORS(app)

    from .routes import task_bp
    app.register_blueprint(task_bp, url_prefix="/api")

    with app.app_context():
        db.create_all()

    return app