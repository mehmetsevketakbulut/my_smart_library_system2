
from flask import current_app as app, jsonify, request, render_template
from . import db
from .models import Kitap, Kullanici, Yazar, Kategori, Odunc


@app.route("/")
def home():
    return "Akıllı Kütüphane API - Çalışıyor"


@app.route("register",methods=["POST","GET"])
def register():
    if request.method=="POST":
        isim=request.form["isim"]
        email=request.form["email"]
        sifre = request.form["sifre"]

        yeni_kullanici = Kullanici(id=None,isim=isim,email=email,sifre=sifre,role="user")
        db.session.add(yeni_kullanici)
        db.session.commit()
        return redirect("/login")  
    return render_template("register.html")

@app.route("login",methods=["POST"])

    


@app.route("/kitaplar", methods=["GET"])
def kitaplari_getir():
    q = request.args.get("q", type=str)
    page = request.args.get("page", default=1, type=int)
    page_size = request.args.get("page_size", default=20, type=int)

    sorgu = Kitap.query.join(Yazar, isouter=True).join(Kategori, isouter=True)
    if q:
        sorgu = sorgu.filter(Kitap.ad.ilike(f"%{q}%"))
    total = sorgu.count()
    kitaplar = sorgu.order_by(Kitap.id).offset((page-1)*page_size).limit(page_size).all()
    return jsonify({"page":page, "page_size":page_size, "total":total, "items":[k.to_dict() for k in kitaplar]})

