# Türkiye Senin Backend API

A professional FastAPI backend for managing municipal events, scholarships, and user registrations.

## Features

- **User Authentication**: JWT-based authentication with secure password hashing
- **Event Management**: Browse, register, and manage event participation
- **Council Management**: Municipal councils can organize events and scholarships
- **Scholarship System**: Browse and apply for educational scholarships
- **Admin Panel**: Administrative endpoints for creating councils, events, and scholarships
- **AI Integration**: FAISS-powered semantic search for events (see `chatbot_agent.py`)

## Project Structure

```
backend/
├── app/
│   ├── core/
│   │   ├── config.py          # Application settings
│   │   ├── db.py              # Database connection
│   │   └── security.py        # Authentication & authorization
│   ├── models/
│   │   ├── user.py            # User model
│   │   ├── council.py         # Council model
│   │   ├── event.py           # Event model
│   │   ├── scholarship.py     # Scholarship model
│   │   └── registration.py    # Registration model (many-to-many)
│   ├── schemas/
│   │   ├── token.py           # JWT token schemas
│   │   ├── user.py            # User schemas
│   │   ├── council.py         # Council schemas
│   │   ├── event.py           # Event schemas
│   │   ├── scholarship.py     # Scholarship schemas
│   │   └── registration.py    # Registration schemas
│   ├── routers/
│   │   ├── auth.py            # /auth - Registration & login
│   │   ├── users.py           # /users - User profile & events
│   │   ├── events.py          # /events - Event browsing & registration
│   │   ├── councils.py        # /councils - Council information
│   │   ├── scholarships.py    # /scholarships - Scholarship listings
│   │   └── admin.py           # /admin - Admin operations
│   └── main.py                # FastAPI application entry point
├── .env.example               # Environment variables template
├── requirements.txt           # Python dependencies
└── README.md                  # This file
```

## Setup Instructions

### 1. Prerequisites

- Python 3.10+
- PostgreSQL database (Docker recommended)
- Virtual environment activated

### 2. Start PostgreSQL Database

If you have Docker installed, start PostgreSQL:

```powershell
docker start my-postgres-db
```

Or if starting for the first time:

```powershell
docker run --name my-postgres-db -e POSTGRES_PASSWORD=sifrem123 -p 5432:5432 -d postgres
```

### 3. Create Environment File

Copy `.env.example` to `.env` and update values if needed:

```powershell
cp .env.example .env
```

### 4. Install Dependencies

```powershell
pip install -r requirements.txt
```

### 5. Run the Application

```powershell
cd backend
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at:
- **API**: http://localhost:8000
- **Interactive Docs (Swagger)**: http://localhost:8000/docs
- **Alternative Docs (ReDoc)**: http://localhost:8000/redoc

## API Endpoints

### Authentication (`/auth`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/auth/register` | Register a new user | No |
| POST | `/auth/login` | Login and receive JWT token | No |

### Users (`/users`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/users/me` | Get current user profile | Yes |
| GET | `/users/me/events` | Get user's registered events | Yes |

### Events (`/events`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/events/` | List all events | No |
| GET | `/events/{event_id}` | Get event details | No |
| POST | `/events/{event_id}/register` | Register for event | Yes |
| DELETE | `/events/{event_id}/register` | Unregister from event | Yes |

### Councils (`/councils`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/councils/` | List all councils | No |
| GET | `/councils/{council_id}/events` | Get council's events | No |

### Scholarships (`/scholarships`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/scholarships/` | List all scholarships | No |

### Admin (`/admin`)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/admin/councils` | Create a council | Yes (Admin) |
| POST | `/admin/events` | Create an event | Yes (Admin) |
| POST | `/admin/scholarships` | Create a scholarship | Yes (Admin) |

## Usage Examples

### 1. Register a User

```bash
curl -X POST "http://localhost:8000/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securepassword",
    "user_name": "Ahmet",
    "user_surname": "Yılmaz",
    "user_city": "Istanbul"
  }'
```

### 2. Login

```bash
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=user@example.com&password=securepassword"
```

Response:
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

### 3. Get Current User Profile

```bash
curl -X GET "http://localhost:8000/users/me" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 4. List All Events

```bash
curl -X GET "http://localhost:8000/events/"
```

### 5. Register for an Event

```bash
curl -X POST "http://localhost:8000/events/1/register" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## Database Models

### User
- `id`: Primary key
- `email`: Unique email address
- `hashed_password`: Bcrypt hashed password
- `user_name`: First name
- `user_surname`: Last name
- `user_city`: City (optional)
- `is_admin`: Admin flag

### Council
- `id`: Primary key
- `council_name`: Unique council name
- `city`: Operating city

### Event
- `id`: Primary key
- `event_name`: Event name
- `event_date`: Date and time
- `event_location`: Location
- `event_category`: Category/type
- `event_limit`: Max participants (nullable)
- `event_price`: Ticket price
- `organizator_id`: Foreign key to Council

### Scholarship
- `id`: Primary key
- `title`: Scholarship title
- `description`: Description
- `deadline`: Application deadline
- `application_url`: Application URL
- `council_id`: Foreign key to Council

### Registration
- `id`: Primary key
- `user_id`: Foreign key to User
- `event_id`: Foreign key to Event
- Unique constraint on (user_id, event_id)

## Creating an Admin User

After starting the application, you can manually create an admin user through the database or by registering a normal user and then updating the `is_admin` field:

```sql
UPDATE users SET is_admin = true WHERE email = 'admin@example.com';
```

## Development

### Running Tests

```powershell
pytest
```

### Database Migrations

The application automatically creates tables on startup using SQLAlchemy's `create_all()`. For production, consider using Alembic for migrations.

## Security Notes

- Change `SECRET_KEY` in `.env` for production
- Use HTTPS in production
- Limit CORS origins in production (update `allow_origins` in `main.py`)
- Never commit `.env` file to version control

## Troubleshooting

### Database Connection Issues

If you get database connection errors:
1. Ensure PostgreSQL is running: `docker ps`
2. Check database credentials in `.env`
3. Verify port 5432 is not in use

### Import Errors

If you get import errors, ensure you're in the correct directory:
```powershell
cd backend
python -m uvicorn app.main:app --reload
```

## License

MIT License
