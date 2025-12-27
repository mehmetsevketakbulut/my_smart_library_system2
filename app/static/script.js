let currentUser = null; 

document.addEventListener("DOMContentLoaded", () => {
    const storedUser = localStorage.getItem("libraryUser");
    if (storedUser) {
        currentUser = JSON.parse(storedUser);
        initApp();
    }
});

function toggleAuth(type) {
    const loginForm = document.getElementById("login-form");
    const regForm = document.getElementById("register-form");
    const tabLogin = document.querySelector('a[onclick="toggleAuth(\'login\')"]');
    const tabReg = document.querySelector('a[onclick="toggleAuth(\'register\')"]');

    if (type === 'login') {
        loginForm.classList.remove("d-none");
        regForm.classList.add("d-none");
        tabLogin.classList.add("active");
        tabReg.classList.remove("active");
    } else {
        loginForm.classList.add("d-none");
        regForm.classList.remove("d-none");
        tabLogin.classList.remove("active");
        tabReg.classList.add("active");
    }
}

// KAYIT OLMA
document.getElementById("register-form").addEventListener("submit", async (e) => {
    e.preventDefault();
    const data = {
        isim: document.getElementById("reg-name").value,
        email: document.getElementById("reg-email").value,
        sifre: document.getElementById("reg-pass").value
    };

    const res = await fetch("/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    });
    
    const result = await res.json();
    if (res.ok) {
        showAlert("success", "Kayıt başarılı! Lütfen giriş yapın.");
        toggleAuth('login');
    } else {
        showAlert("danger", result.mesaj);
    }
});

// GİRİŞ YAPMA
document.getElementById("login-form").addEventListener("submit", async (e) => {
    e.preventDefault();
    const data = {
        email: document.getElementById("login-email").value,
        sifre: document.getElementById("login-pass").value
    };

    const res = await fetch("/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    });

    const result = await res.json();
    if (res.ok) {
        currentUser = result.kullanici;
        localStorage.setItem("libraryUser", JSON.stringify(currentUser));
        showAlert("success", "Giriş başarılı.");
        initApp();
    } else {
        showAlert("danger", result.mesaj);
    }
});

function logout() {
    currentUser = null;
    localStorage.removeItem("libraryUser");
    location.reload(); 
}

function initApp() {

    document.getElementById("auth-sec").style.display = "none";
    document.getElementById("main-content").style.display = "block";
    document.getElementById("main-nav").style.display = "flex";
    document.getElementById("logout-btn").style.display = "block";
    document.getElementById("user-display").innerText = `Hoşgeldin, ${currentUser.isim}`;

    const adminLink = document.getElementById("admin-link");
    const iadeLink = document.getElementById("iade-link-li"); 

    if (currentUser.role === "admin") {
        adminLink.style.display = "block"; 
        if(iadeLink) iadeLink.style.display = "none"; 
    } else {
        adminLink.style.display = "none"; 
        if(iadeLink) iadeLink.style.display = "block"; 
    }
    loadBooks(); 
}

function showSection(secId) {
    document.getElementById("kitaplar-sec").classList.add("d-none");
    document.getElementById("admin-sec").classList.add("d-none");
    document.getElementById("iade-odeme-sec").classList.add("d-none");
    
    document.getElementById(secId).classList.remove("d-none");
    
    document.querySelectorAll(".nav-link").forEach(l => l.classList.remove("active"));
    event.target.classList.add("active");

    if (secId === 'iade-odeme-sec') {
        loadMyBooks();
    }
}

// KİTAPLARI LİSTELEME
async function loadBooks(page = 1) {
    const query = document.getElementById("search-input").value;
    const url = `/kitaplar?page=${page}&q=${query}`;
    
    const res = await fetch(url);
    const data = await res.json();
    
    const container = document.getElementById("books-container");
    container.innerHTML = "";

    data.items.forEach(book => {
        let actionBtn = "";
        if (currentUser.role === "user") {
            actionBtn = `<button class="btn btn-sm btn-primary w-100 mt-2" onclick="borrowBook(${book.id})">Ödünç Al</button>`;
        } else if (currentUser.role === "admin") {
            actionBtn = `<div class="text-muted small mt-2 text-center">ID: ${book.id}</div>`;
        }

        const html = `
        <div class="col-md-3 mb-4">
            <div class="card h-100 book-card border-0 shadow-sm">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title text-primary">${book.ad}</h5>
                    <p class="card-text mb-1"><small class="text-muted"><i class="fas fa-user-pen"></i> ${book.yazar || 'Bilinmiyor'}</small></p>
                    <p class="card-text mb-1"><small class="text-muted"><i class="fas fa-bookmark"></i> ${book.kategori || 'Genel'}</small></p>
                    <p class="card-text"><small class="text-muted"><i class="fas fa-calendar"></i> ${book.yayin_yili || '-'}</small></p>
                    <div class="mt-auto">
                        ${actionBtn}
                    </div>
                </div>
            </div>
        </div>`;
        container.innerHTML += html;
    });
}

// ÖDÜNÇ ALMA
async function borrowBook(bookId) {
    if(!confirm("Bu kitabı ödünç almak istiyor musunuz?")) return;

    const res = await fetch("/oduncKitapAl", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ isim: currentUser.isim, kitap_id: bookId })
    });
    
    const result = await res.json();
    if(res.ok) {
        showAlert("success", result.mesaj);
    }
    else showAlert("warning", result.mesaj);
}

// KİTAP GETİRME
async function loadMyBooks() {
    if (!currentUser || currentUser.role !== "user") return;

    const tbody = document.getElementById("my-books-body");
    tbody.innerHTML = '<tr><td colspan="5" class="text-center">Yükleniyor...</td></tr>';

    try {
        const res = await fetch("/oduncKitaplarim", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ isim: currentUser.isim })
        });

        const result = await res.json();

        if (res.ok) {
            tbody.innerHTML = "";
            
            if (result.odunc_kitaplar.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted">Şu an ödünç aldığınız kitap bulunmuyor.</td></tr>';
                return;
            }

            result.odunc_kitaplar.forEach(item => {
                const tarih = new Date(item.alim_tarihi).toLocaleDateString("tr-TR");
                
                const row = `
                <tr>
                    <td><strong>${item.kitap_ad}</strong></td>
                    <td>${tarih}</td>
                    <td>${item.yayin_yili || '-'}</td>
                    <td><span class="badge bg-secondary">${item.odunc_id}</span></td>
                    <td class="text-end">
                        <button class="btn btn-sm btn-outline-warning" onclick="selectForReturn(${item.odunc_id})">
                            <i class="fas fa-check"></i> İade Et
                        </button>
                    </td>
                </tr>`;
                tbody.innerHTML += row;
            });
        } else {
            tbody.innerHTML = `<tr><td colspan="5" class="text-danger">Hata: ${result.mesaj}</td></tr>`;
        }
    } catch (error) {
        console.error(error);
        tbody.innerHTML = '<tr><td colspan="5" class="text-danger">Bağlantı hatası oluştu.</td></tr>';
    }
}

function selectForReturn(id) {
    document.getElementById("ret-odunc-id").value = id;
    showAlert("success", `ID: ${id} iade formuna seçildi. Butona basarak işlemi tamamlayın.`);
}

// İADE İŞLEMİ
document.getElementById("return-form").addEventListener("submit", async (e) => {
    e.preventDefault(); 
    
    const oduncId = document.getElementById("ret-odunc-id").value;

    if (!oduncId) {
        alert("Lütfen bir Ödünç ID girin veya listeden seçin.");
        return;
    }

    try {
        const res = await fetch("/iadeEt", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ 
                odunc_id: parseInt(oduncId)
            })
        });

        const result = await res.json();

        if (res.ok) {
            if (result.durum === 'cezali') {
                alert("⚠️ DİKKAT! GECİKME CEZASI!\n\n" + result.mesaj + "\n\nCeza Tutarı: " + result.ceza_miktari + " TL");
                document.getElementById("ceza-odunc-id").value = oduncId;
                checkFine(); 
            } 
            else {
                alert("✅ " + result.mesaj);
            }
            loadMyBooks();
            document.getElementById("return-form").reset();

        } else {
            alert("❌ HATA: " + result.mesaj);
        }

    } catch (error) {
        console.error(error);
        alert("Sistemsel bir bağlantı hatası oluştu!");
    }
});

// CEZA SORGULAMA
async function checkFine() {
    const oduncId = document.getElementById("ceza-odunc-id").value;
    if(!oduncId) return showAlert("warning", "Lütfen bir Ödünç ID girin");

    const res = await fetch("/gecikmeHesapla", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ odunc_id: parseInt(oduncId) })
    });

    const result = await res.json();
    const payArea = document.getElementById("payment-area");
    const noFineMsg = document.getElementById("no-fine-msg");

    if (res.ok && result.mesaj === "Gecikme mevcut" && !result.odendi) {
        payArea.classList.remove("d-none");
        noFineMsg.classList.add("d-none");
        document.getElementById("fine-amount").innerText = `${result.tutar} TL Ceza`;
        document.getElementById("hidden-ceza-id").value = result.ceza_id;
    } else {
        payArea.classList.add("d-none");
        noFineMsg.classList.remove("d-none");
        if(result.odendi) noFineMsg.innerText = "Bu ceza zaten ödenmiş.";
        else noFineMsg.innerText = result.mesaj;
    }
}

// CEZA ÖDEME
async function payFine() {
    const cezaId = document.getElementById("hidden-ceza-id").value;
    
    const res = await fetch("/odemeYap", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ceza_id: parseInt(cezaId) })
    });
    
    const result = await res.json();
    if(res.ok) {
        showAlert("success", "Ödeme Başarılı!");
        document.getElementById("payment-area").classList.add("d-none");
        document.getElementById("no-fine-msg").classList.remove("d-none");
        document.getElementById("no-fine-msg").innerText = "Ceza ödendi.";
    } else {
        showAlert("danger", result.mesaj);
    }
}

// KİTAP EKLEME İSLEMİ
document.getElementById("add-book-form").addEventListener("submit", async (e) => {
    e.preventDefault();
    const data = {
        isim: currentUser.isim,
        kitap_ad: document.getElementById("add-name").value,
        yazar_ad: document.getElementById("add-author").value,
        kategori_ad: document.getElementById("add-cat").value,
        yayin_yili: document.getElementById("add-year").value
    };

    const res = await fetch("/kitapEkle", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    });

    const result = await res.json();
    if(res.ok) {
        showAlert("success", "Kitap eklendi.");
        document.getElementById("add-book-form").reset();
        loadBooks();
    } else {
        showAlert("danger", result.mesaj);
    }
});

// KİTAP SİLME İSLEMİ
document.getElementById("del-book-form").addEventListener("submit", async (e) => {
    e.preventDefault();
    const kitapId = document.getElementById("del-id").value;
    
    if(!confirm("Kitabı silmek istediğinize emin misiniz?")) return;

    const res = await fetch("/kitapSil", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ isim: currentUser.isim, kitap_id: parseInt(kitapId) })
    });

    const result = await res.json();
    if(res.ok) {
        showAlert("success", "Kitap silindi.");
        loadBooks();
    } else {
        showAlert("danger", result.mesaj);
    }
});

// BİLDİRİMLER
function showAlert(type, message) {
    const alertBox = document.getElementById("alert-box");
    alertBox.className = `alert alert-${type}`;
    alertBox.innerText = message;
    alertBox.classList.remove("d-none");
    
    setTimeout(() => {
        alertBox.classList.add("d-none");
    }, 4000);
}

//Şifremi UNuttuum alanı
function showForgotForm(event) {
    event.preventDefault();
    const area = document.getElementById('forgot-password-area');
    area.classList.toggle('d-none');
}
async function sendResetLink() {
    const email = document.getElementById('forgot-email').value;
    
    if (!email) {
        alert("Lütfen e-posta adresinizi giriniz.");
        return;
    }

    try {
        const response = await fetch('/sifremi-unuttum', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: email })
        });

        const data = await response.json();
        
        if (response.ok) {
            alert("Başarılı: " + data.mesaj);
            document.getElementById('forgot-password-area').classList.add('d-none');
        } else {
            alert("Hata: " + data.mesaj);
        }
    } catch (error) {
        console.error("Hata:", error);
        alert("Bir sorun oluştu, lütfen tekrar deneyin.");
    }
}
// Gecikmiş kitap gosterme
async function gecikmeleriGetir() {
    const tbody = document.getElementById('gecikmeTablosuGovdesi');
    
    if (!tbody) return; 

    tbody.innerHTML = '<tr><td colspan="5" class="text-center py-3"><div class="spinner-border text-primary spinner-border-sm"></div> Veriler çekiliyor...</td></tr>';

    try {
        const res = await fetch('/api/gecikmisKitaplar');
        const data = await res.json();

        tbody.innerHTML = "";

        if (data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center alert alert-success m-0"><i class="fas fa-check-circle me-2"></i>Harika! Şu an gecikmede olan kitap yok.</td></tr>';
            return;
        }

        data.forEach(item => {
            const html = `
                <tr>
                    <td class="fw-bold">${item.kullanici}</td>
                    <td>${item.kitap}</td>
                    <td><span class="badge bg-secondary">${item.odunc_tarihi}</span></td>
                    <td><span class="badge bg-info text-dark">${item.beklenen_iade}</span></td>
                    <td class="text-danger fw-bold">
                        <i class="fas fa-exclamation-circle me-1"></i> ${item.gecikme_suresi} Dakika
                    </td>
                </tr>
            `;
            tbody.innerHTML += html;
        });

    } catch (error) {
        console.error(error);
        tbody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">Veri çekilirken hata oluştu!</td></tr>';
    }
}