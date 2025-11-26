from . import db
from datetime import date, datetime, timedelta


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

    __sifre = db.Column(db.String(255)) #şifreyi erişimle değiştirilmememsi için private olarak tanımladım
    role = db.Column(db.String(20))

    def setsifre(self,sifre):
        self.__sifre=sifre

    def get_sifre(self):
        return self.__sifre 

class User(Kullanici):
    gecikme_tutari=10
    def __init__(self,isim,email,sifre):
        super().__init__(isim=isim,email=email,sifre=sifre,role="user")
    
    def odunc_al(self, kitap_id):
        today = date.today()
        beklenen = today + timedelta(days=30) #30 günlük odunc veriyoruz
        yeni_odunc = Odunc(kitap_id=kitap_id,kullanici_id=self.id,odunc_tarihi=today,beklenen_iade=beklenen)
        db.session.add(yeni_odunc)
        db.session.commit()
    
    def iade_et(self,odunc_id,iade_tarihi):
        iade_tarihi = datetime.strptime(iade_tarihi, "%Y-%m-%d").date()
        odunc = Odunc.query.get(odunc_id)
        odunc.iade_tarihi = iade_tarihi
        if(iade_tarihi > odunc.beklenen_iade):
            geciken_gun=(iade_tarihi - odunc.beklenen_iade).day
            gecikentutar=geciken_gun * User.gecikme_tutari
            ceza = Ceza(odunc_id=odunc.id,tutar=gecikentutar,olusturma_tarihi=iade_tarihi)
            db.session.add(ceza)
        db.session.commit()


class Admin(Kullanici):
    def __init__(self,isim,email,sifre):
        super().__init__(isim=isim,email=email,sifre=sifre,role="admin")
    
    def kitap_ekle(self,kitap_ad, yazar_ad, kategori_ad, yayin_yili):
        if self.role!="admin":
            return("Bu işlemi yapamazsınız!")
        
        yazar = Yazar.query.filter_by(ad=yazar_ad).first()
        if not yazar:
            yazar = Yazar(ad=yazar_ad)
            db.session.add(yazar)
            db.session.commit() 
        
        kategori = Kategori.query.filter_by(isim=kategori_ad).first()
        if not kategori:
            kategori = Kategori(isim=kategori_ad)
            db.session.add(kategori)
            db.session.commit()
        
        kitap = Kitap(ad=kitap_ad, yazar_id=yazar.id, kategori_id=kategori.id, yayin_yili=yayin_yili)
        db.session.add(kitap)
        db.session.commit()

        return " Kitap eklendi!"
    
    def kitap_sil(self,kitap_id):
        odunctemi=Odunc.query.filter_by(Odunc.kitap_id==kitap_id,Odunc.iade_tarihi==None).first()
        if odunctemi: # eğer bu dongunun içine girerse demekki şuan kitap oduncte     
             print("Bu kitap halen ödünçte silemezsiniz.")
        else:
            kitap = Kitap.query.get(kitap_id)
            db.session.delete(kitap)
            db.session.commit()

class Odunc(db.Model):
    __tablename__ = "odunc"
    id = db.Column(db.Integer, primary_key=True)
    kitap_id = db.Column(db.Integer, db.ForeignKey("kitap.id"))
    kullanici_id = db.Column(db.Integer, db.ForeignKey("kullanici.id"))
    odunc_tarihi = db.Column(db.Date, nullable=False)
    beklenen_iade = db.Column(db.Date, nullable=False)
    iade_tarihi = db.Column(db.Date, nullable=True)

class Ceza(db.Model):
    __tablename__ = "ceza"

    id = db.Column(db.Integer, primary_key=True)
    odunc_id = db.Column(db.Integer, db.ForeignKey("odunc.id"), nullable=False)
    tutar = db.Column(db.Float, nullable=False)
    olusturma_tarihi = db.Column(db.DateTime, default=datetime.utcnow)
    odunc = db.relationship("Odunc", backref="cezalar")



