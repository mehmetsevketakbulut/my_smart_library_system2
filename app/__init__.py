from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_mail import Mail 
from itsdangerous import URLSafeTimedSerializer

db = SQLAlchemy()
mail = Mail()
s = None 

def create_app():
    global s
    app = Flask(__name__, template_folder="templates", static_folder="static")

    app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://root:Alya2019@localhost:3306/kutuphane_db"
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    
    app.config['MAIL_SERVER'] = 'smtp.gmail.com'
    app.config['MAIL_PORT'] = 587
    app.config['MAIL_USE_TLS'] = True
    app.config['MAIL_USERNAME'] = 'mehmetsevketakbulut@gmail.com'
    app.config['MAIL_PASSWORD'] = 'reqg bguj gtwk skej'
    app.config['SECRET_KEY'] = 'cok-gizli-anahtar'
    
    mail.init_app(app)
    db.init_app(app)
    
    s = URLSafeTimedSerializer(app.config['SECRET_KEY'])

    with app.app_context():
        db.create_all()
        from . import routes
    
    return app