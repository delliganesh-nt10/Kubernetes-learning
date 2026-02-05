import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from dotenv import load_dotenv

db = SQLAlchemy()

def create_app():
    # Load .env ONLY for local development
    load_dotenv()

    app = Flask(__name__)

    # ------------------------
    # App configuration
    # ------------------------
    app.config['SECRET_KEY'] = os.getenv("SECRET_KEY", "dev-secret")

    # ------------------------
    # Database configuration
    # ------------------------
    db_user = os.getenv("DB_USER")
    db_password = os.getenv("DB_PASSWORD")
    db_host = os.getenv("DB_HOST")
    db_name = os.getenv("DB_NAME")
    db_port = os.getenv("DB_PORT", "3306")  # Safe default for MySQL

    app.config['SQLALCHEMY_DATABASE_URI'] = (
        f"mysql+mysqlconnector://"
        f"{db_user}:{db_password}"
        f"@{db_host}:{db_port}/{db_name}"
    )

    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    # Initialize database
    db.init_app(app)

    # ------------------------
    # Blueprints
    # ------------------------
    from .views import views
    from .auth import auth
    app.register_blueprint(views, url_prefix='/')
    app.register_blueprint(auth, url_prefix='/')

    # ------------------------
    # Models
    # ------------------------
    from .models import User, Note

    # ------------------------
    # Login manager
    # ------------------------
    login_manager = LoginManager()
    login_manager.login_view = 'auth.login'
    login_manager.init_app(app)

    @login_manager.user_loader
    def load_user(id):
        return User.query.get(int(id))

    # ------------------------
    # Controlled DB initialization
    # ------------------------
    # IMPORTANT:
    # Enable ONLY once (prevents Gunicorn / EKS race conditions)
    if os.getenv("RUN_DB_MIGRATIONS") == "true":
        with app.app_context():
            db.create_all()

    return app
