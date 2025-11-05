# Türkiye Senin API

Modern FastAPI tabanlı bir belediye platformu backend'i. Etkinlikler, burslar, kullanıcı kayıtları ve rol bazlı yetkilendirme (Admin, Council, User) içerir. Semantik arama için FAISS + SentenceTransformer entegrasyonu vardır.

- Base URL: http://127.0.0.1:8080
- API Docs (Swagger): http://127.0.0.1:8080/docs
- API Docs (ReDoc): http://127.0.0.1:8080/redoc

## Teknolojiler
- FastAPI, Uvicorn
- SQLAlchemy, PostgreSQL (Docker)
- Pydantic v2, pydantic-settings
- JWT (python-jose), passlib[bcrypt]
- FAISS, sentence-transformers (all-MiniLM-L6-v2)

---

## Kurulum (Windows / PowerShell)

### 1) Önkoşullar
- Python 3.10+
- Docker Desktop (PostgreSQL için)
- PowerShell 5+

### 2) Sanal ortam ve bağımlılıklar
```powershell
# Proje kökü
cd c:\Users\hp\OneDrive\Desktop\turkiye_senin

# Sanal ortam (ör: env_undp)
python -m venv env_undp
.\env_undp\Scripts\Activate.ps1

# Backend bağımlılıklarını yükle
cd backend
pip install -r requirements.txt
```

### 3) Ortam değişkenleri
```powershell
# backend dizininde .env yoksa .env.example'dan kopyalayın
copy .env.example .env
```

`.env` içeriği (varsayılan):
```
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=turkiye_db
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432

SECRET_KEY=your-secret-key-here-change-this-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
DEBUG=True
```

### 4) PostgreSQL ve API'yi başlatma
```powershell
# Hâlihazırda backend klasöründe olun
.\start.ps1
```
Betik şunları yapar:
- `my-postgres-db` isminde bir PostgreSQL container'ı yoksa oluşturur ve 5432 portuna map eder.
- Uvicorn ile FastAPI'yi `127.0.0.1:8080` üzerinde başlatır.

Tarayıcıdan doğrulayın:
- http://127.0.0.1:8080/docs

> Not: İlk sefer semantik arama modelinin (all-MiniLM-L6-v2) inmesi zaman alabilir.

---

## Rollere Göre Akış

### 1) Normal Kullanıcı
- Kayıt: `POST /auth/register`
- Giriş (token): `POST /auth/login` (Form-Data: `username`, `password`)
- Profil: `GET /users/me` (Auth gerekli)
- Kayıtlı Etkinliklerim: `GET /users/me/events` (Auth gerekli)
- Etkinliğe kayıt: `POST /events/{event_id}/register` (Auth gerekli)
- Etkinlik kaydını iptal: `DELETE /events/{event_id}/register` (Auth gerekli)

### 2) Admin
- Admin olmak için (geçici):
```powershell
docker exec my-postgres-db psql -U postgres -d turkiye_db -c "UPDATE users SET is_admin = true WHERE email = 'admin@example.com';"
```
- Belediye oluştur: `POST /admin/councils`
- Etkinlik oluştur: `POST /admin/events`
- Burs oluştur: `POST /admin/scholarships`

### 3) Council (Belediye Hesabı)
1) Admin bir belediye oluşturur: `POST /admin/councils`
2) Council kullanıcı kaydı: `POST /auth/register-council` (body'de `council_id` zorunlu)
3) Giriş ve token al: `POST /auth/login`
4) Kendi etkinliğini yönet:
   - Oluştur: `POST /councils/me/events`
   - Sil: `DELETE /councils/me/events/{event_id}`

---

## Endpoint Özeti

### Public
- `GET /events/` — Tüm etkinlikler (organizator nested gelir)
- `GET /events/{event_id}` — Tek etkinlik
- `GET /scholarships/` — Tüm burslar (council nested gelir)
- `GET /councils/` — Tüm belediyeler
- `GET /councils/{council_id}/events` — Belediyenin etkinlikleri
- `POST /search/` — Semantik arama `{ "query": "...", "top_k": 5 }`

### Auth (JWT)
- `POST /auth/register` — Normal kayıt
- `POST /auth/login` — Token al (form-encoded: `username`, `password`)
- `POST /auth/register-council` — Council bağlı kullanıcı kaydı (is_council=true)

### User
- `GET /users/me`
- `GET /users/me/events`

### Council (Auth: Council)
- `POST /councils/me/events`
- `DELETE /councils/me/events/{event_id}`

### Admin (Auth: Admin)
- `POST /admin/councils`
- `POST /admin/events`
- `POST /admin/scholarships`

---

## Veri Modelleri (Özet)
- EventRead: `id, event_name, event_date, event_location, event_category, event_description?, event_limit?, event_price, organizator: CouncilRead`
- ScholarshipRead: `id, title, description, deadline, application_url, council: CouncilRead`
- CouncilRead: `id, council_name, city`
- UserRead: `id, email, user_name, user_surname, user_city, is_admin, is_council, council_id?`

> Not: Nested şemalar sayesinde ek org bilgileri tek çağrıda döner (N+1 yok).

---

## V1.1 Şema Güncellemeleri (Var olan DB için)
Mevcut veritabanında aşağıdaki ALTER komutlarını çalıştırın:
```powershell
docker exec my-postgres-db psql -U postgres -d turkiye_db -c "ALTER TABLE users ADD COLUMN IF NOT EXISTS is_council boolean NOT NULL DEFAULT false;"
docker exec my-postgres-db psql -U postgres -d turkiye_db -c "ALTER TABLE users ADD COLUMN IF NOT EXISTS council_id integer;"
docker exec my-postgres-db psql -U postgres -d turkiye_db -c "ALTER TABLE users ADD CONSTRAINT IF NOT EXISTS users_council_id_fkey FOREIGN KEY (council_id) REFERENCES councils(id) ON DELETE SET NULL;"
docker exec my-postgres-db psql -U postgres -d turkiye_db -c "ALTER TABLE events ADD COLUMN IF NOT EXISTS event_description text;"
```

---

## Sık Karşılaşılan Sorunlar

- "password authentication failed for user 'postgres'"
  - `.env` ile container şifresi uyumlu olmalı (varsayılan `postgres`).
  - Gerekirse container ve volume'u temiz kurun:
    ```powershell
    docker stop my-postgres-db
    docker rm -v my-postgres-db
    docker run --name my-postgres-db -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=turkiye_db -e POSTGRES_HOST_AUTH_METHOD=trust -p 5432:5432 -d postgres:15
    ```
  - `POSTGRES_HOST=127.0.0.1` kullanın.

- 5432 port çakışması
  - `netstat -ano | findstr :5432` ile kontrol edin.
  - Gerekirse host portunu değiştirin: `-p 5433:5432` ve `.env`'de `POSTGRES_PORT=5433`.

- PowerShell script çalışmıyor
  - Geçici olarak:
    ```powershell
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
    ```

- Model indirme (sentence-transformers)
  - İlk aramada internet gerekir ve indirme sürebilir.

---

## Proje Yapısı (Özet)
```
backend/
  app/
    core/ (config, db, security)
    models/ (user, council, event, scholarship, registration)
    routers/ (auth, users, events, councils, scholarships, admin, chatbot)
    schemas/ (pydantic şemaları)
    services/ (search_service)
  requirements.txt
  start.ps1
.env.example
```

---

## Geliştirme İpuçları
- Swagger üzerinden hızlı test yapın (Authorize → Bearer <TOKEN>)
- Frontend için nested şemalar ile tek istekle yeterli veri döner.
- `.gitignore` secrets ve yerel ortamları dışarıda tutar (commit etmeyin): `backend/.env`, `env_undp/`, `node_modules/` vb.

---

## Lisans
Bu depo içeriği proje sahibine aittir. Gerektiğinde lisans bilgisi eklenecektir.
