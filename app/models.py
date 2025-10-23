from . import db

class Yazar(db.Model):
    __tablename__ = "yazar"
    id = db.Column(db.Integer, primary_key=True)
    ad = db.Column(db.String(120), nullable=False)

class Kategori(db.Model):
    __tablename__ = "kategori"
    id = db.Column(db.Integer, primary_key=True)
    isim = db.Column(db.String(80), nullable=False)

class Kitap(db.Model):
    __tablename__ = "kitap"
    id = db.Column(db.Integer, primary_key=True)
    ad = db.Column(db.String(255), nullable=False)
    yazar_id = db.Column(db.Integer, db.ForeignKey('yazar.id'))
    kategori_id = db.Column(db.Integer, db.ForeignKey('kategori.id'))
    yayin_yili = db.Column(db.Integer)
    yazar = db.relationship('Yazar', lazy='joined')
    kategori = db.relationship('Kategori', lazy='joined')

    def to_dict(self):
        return {
            "id": self.id, "ad": self.ad,
            "yazar": self.yazar.ad if self.yazar else None,
            "kategori": self.kategori.isim if self.kategori else None,
            "yayin_yili": self.yayin_yili
        }

class Kullanici(db.Model):
    __tablename__ = "kullanici"
    id = db.Column(db.Integer, primary_key=True)
    isim = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(150), unique=True)
    sifre = db.Column(db.String(255))
    role = db.Column(db.String(20))
