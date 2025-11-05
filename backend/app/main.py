from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.db import engine, Base
from app.routers import auth, users, events, councils, scholarships, admin

# Create database tables
Base.metadata.create_all(bind=engine)

# Initialize FastAPI application
app = FastAPI(
    title="Türkiye Senin API",
    description="API for managing municipal events, scholarships, and user registrations",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router)
app.include_router(users.router)
app.include_router(events.router)
app.include_router(councils.router)
app.include_router(scholarships.router)
app.include_router(admin.router)


@app.get("/")
def root():
    """
    Root endpoint - Health check
    """
    return {
        "message": "Türkiye Senin API is running",
        "version": "1.0.0",
        "docs": "/docs",
        "redoc": "/redoc"
    }