from flask import current_app as app, jsonify, request
from . import db
from .models import Kitap, Kullanici, Yazar, Kategori, Odunc, User,Ceza
from flask import render_template
from datetime import datetime, date



@app.route("/home")
def home():
    return render_template("index.html")

@app.route("/register", methods=["POST"])
def register():
    data = request.get_json()

    if not data:
        return jsonify({"mesaj": "Veri gönderilmedi"}), 400

    isim = data.get("isim")
    email = data.get("email")
    sifre = data.get("sifre")

    if not isim or not email or not sifre:
        return jsonify({"mesaj": "Lütfen tüm alanları doldurun (isim, email, sifre)"}), 400

    mevcut_kullanici = Kullanici.query.filter_by(email=email).first()
    if mevcut_kullanici:
        return jsonify({"mesaj": "Bu email adresi zaten kayıtlı!"}), 409

    yeni_kullanici = User(isim=isim, email=email, sifre=sifre)
    
    yeni_kullanici.setsifre(sifre)

    try:
        db.session.add(yeni_kullanici)
        db.session.commit()
        return jsonify({"mesaj": "Kayıt başarılı", "kullanici_id": yeni_kullanici.id}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"mesaj": "Kayıt sırasında bir hata oluştu", "hata": str(e)}), 500
    
 

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    
    if not data:
        return jsonify({"mesaj": "Veri gönderilmedi"}), 400
        
    email = data.get("email")
    sifre = data.get("sifre")

    if not email or not sifre:
        return jsonify({"mesaj": "Email ve şifre zorunludur"}), 400

    kullanici = Kullanici.query.filter_by(email=email).first()

    if kullanici and kullanici.get_sifre() == sifre:
        return jsonify({
            "mesaj": "Giriş başarılı",
            "kullanici": {
                "id": kullanici.id,
                "isim": kullanici.isim,
                "role": kullanici.role
            }
        }), 200
    else:
        return jsonify({"mesaj": "Hatalı email veya şifre"}), 401

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
    
    return jsonify({"page": page, "page_size": page_size, "total": total,"items": [k.to_dict() for k in kitaplar]})


@app.route("/oduncKitapAl", methods=["POST"])
def oduncal():
    data = request.get_json()
    if not data:
        return jsonify({"mesaj": "Veri gönderilmedi"}), 400
    isim = data.get("isim")
    kitap_id = data.get("kitap_id")

    user = User.query.filter_by(isim=isim).first()
    if not user:
        return jsonify({"mesaj": "Kullanıcı bulunamadı"}), 404

    if user.role != "user":
        return jsonify({"mesaj": "Bu işlem sadece kullanıcılar içindir"}), 403

    kitap = Kitap.query.get(kitap_id)
    if not kitap:
        return jsonify({"mesaj": "Kitap bulunamadı"}), 404
    oduncte_mi = Odunc.query.filter_by(kitap_id=kitap_id, teslim_tarihi=None).first()
    if oduncte_mi:
        return jsonify({"mesaj": "Bu kitap zaten ödünçte"}), 400
    user.odunc_al(kitap_id)
    return jsonify({"mesaj": "Kitap ödünç alındı"}), 200
import random # Dosyanın en üstüne eklemeyi unutma

@app.route("/iadeEt", methods=["POST"])
def iadeet():
    data = request.get_json()
    odunc_id = data.get("odunc_id")
    
    odunc_kaydi = Odunc.query.get(odunc_id)
    if not odunc_kaydi:
        return jsonify({"mesaj": "Ödünç kaydı bulunamadı"}), 404

    # Kitabı iade edilmiş olarak işaretle
    odunc_kaydi.teslim_tarihi = datetime.now()

    # %50 Şansla ceza oluştur (0 gelirse temiz, 1 gelirse cezalı)
    ceza_ciksin_mi = random.choice([True, False])

    if ceza_ciksin_mi:
        # Rastgele 10 ile 40 TL arası bir ceza tutarı
        rastgele_tutar = random.randint(10, 40)
        
        yeni_ceza = Ceza(
            odunc_id=odunc_id,
            tutar=rastgele_tutar,
            odendi=False
        )
        db.session.add(yeni_ceza)
        db.session.commit()

        return jsonify({
            "mesaj": "Kitap iade edildi ancak GECİKME CEZASI oluştu!",
            "durum": "cezali",
            "ceza_miktari": rastgele_tutar,
            "ceza_id": yeni_ceza.id
        }), 200
    else:
        # Ceza oluşmayan durum
        db.session.commit()
        return jsonify({
            "mesaj": "Kitap başarıyla ve zamanında iade edildi.",
            "durum": "temiz"
        }), 200
@app.route("/kitapEkle", methods=["POST"])
def kitapekle():
    data = request.get_json()
    if not data:
        return jsonify({"mesaj": "Veri gönderilmedi"}), 400

    isim = data.get("isim")
    kitap_ad = data.get("kitap_ad")
    yazar_ad = data.get("yazar_ad")
    kategori_ad = data.get("kategori_ad")
    yayin_yili = data.get("yayin_yili")

    user = User.query.filter_by(isim=isim).first()
    if not user:
        return jsonify({"mesaj": "Kullanıcı bulunamadı"}), 404

    if user.role != "admin":
        return jsonify({"mesaj": "Bu işlem sadece adminler içindir"}), 403

    mevcut_kitap = Kitap.query.filter_by(ad=kitap_ad).first()
    if mevcut_kitap:
        return jsonify({"mesaj": "Bu kitap zaten kayıtlı!"}), 409

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

    yeni_kitap = Kitap(
        ad=kitap_ad,
        yazar_id=yazar.id,
        kategori_id=kategori.id,
        yayin_yili=yayin_yili
    )

    db.session.add(yeni_kitap)
    db.session.commit()

    return jsonify({"mesaj": "Kitap başarıyla eklendi"}), 201




@app.route("/kitapSil", methods=["POST"])
def kitapsil():
    data = request.get_json()
    if not data:
        return jsonify({"mesaj": "Veri gönderilmedi"}), 400
    isim = data.get("isim")
    kitap_id = data.get("kitap_id")
    user = User.query.filter_by(isim=isim).first()
    if not user:
        return jsonify({"mesaj": "Kullanıcı bulunamadı"}), 404
    if user.role != "admin":
        return jsonify({"mesaj": "Bu işlem sadece adminler içindir"}), 403
    kitap = Kitap.query.get(kitap_id)
    if not kitap:
        return jsonify({"mesaj": "Kitap bulunamadı"}), 404
    try:
        Odunc.query.filter_by(kitap_id=kitap_id).delete()
        db.session.delete(kitap)
        db.session.commit()
        return jsonify({"mesaj": "Kitap başarıyla silindi"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"mesaj": "Kitap silinirken bir hata oluştu", "hata": str(e)}), 500
    
@app.route("/gecikmeHesapla", methods=["POST"])
def gecikme_hesapla():
    data = request.get_json()
    odunc_id = data.get("odunc_id")

    odunc = Odunc.query.get(odunc_id)
    if not odunc:
        return jsonify({"mesaj": "Ödünç kaydı bulunamadı"}), 404

    ceza = Ceza.query.filter_by(odunc_id=odunc.id).first()

    if not ceza:
        return jsonify({"mesaj": "Herhangi bir gecikme yok"}), 200

    return jsonify({
        "mesaj": "Gecikme mevcut",
        "tutar": ceza.tutar,
        "odendi": ceza.odendi,
        "ceza_id": ceza.id
    })

@app.route("/odemeYap", methods=["POST"])
def odeme_yap():
    data = request.get_json()
    ceza_id = data.get("ceza_id")

    ceza = Ceza.query.get(ceza_id)
    if not ceza:
        return jsonify({"mesaj": "Ceza bulunamadı"}), 404

    if ceza.odendi:
        return jsonify({"mesaj": "Bu ceza zaten ödenmiş"}), 400
    ceza.odendi = True
    db.session.commit()

    return jsonify({"mesaj": f"{ceza.tutar} TL ödeme başarıyla alındı. Borcunuz yoktur."}), 200

@app.route("/oduncKitaplarim", methods=["POST"])
def odunc_kitaplarim():
    data = request.get_json()
    
    if not data:
        return jsonify({"mesaj": "Veri gönderilmedi"}), 400

    isim = data.get("isim")
    
    user = User.query.filter_by(isim=isim).first()
    if not user:
        return jsonify({"mesaj": "Kullanıcı bulunamadı"}), 404

    aktif_oduncler = db.session.query(Odunc, Kitap)\
        .join(Kitap, Odunc.kitap_id == Kitap.id)\
        .filter(Odunc.kullanici_id == user.id)\
        .filter(Odunc.teslim_tarihi == None)\
        .all()

    sonuc_listesi = []
    for odunc, kitap in aktif_oduncler:
        sonuc_listesi.append({
            "odunc_id": odunc.id,
            "kitap_id": kitap.id,
            "kitap_ad": kitap.ad,
            "alim_tarihi": odunc.odunc_tarihi,
            "yayin_yili": kitap.yayin_yili
        })

    return jsonify({
        "mesaj": "İşlem başarılı",
        "kullanici": user.isim,
        "odunc_kitaplar": sonuc_listesi,
        "toplam_kitap_sayisi": len(sonuc_listesi)
    }), 200

@app.route("/db-guncelle")
def db_guncelle():
    try:
        with app.app_context():
            db.create_all() 
        return "Veritabanı güncellendi! Ceza tablosu oluşturuldu. Şimdi iade yapabilirsiniz."
    except Exception as e:
        return f"Hata oluştu: {str(e)}"

