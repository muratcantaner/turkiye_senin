# Turkiye Senin Backend - Quick Start Script
# This script helps you start the development server

Write-Host "Starting Turkiye Senin Backend API..." -ForegroundColor Cyan
Write-Host ""

# Check if virtual environment is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "WARNING: Virtual environment not detected!" -ForegroundColor Yellow
    Write-Host "Please activate your virtual environment first:" -ForegroundColor Yellow
    Write-Host "  .\env_undp\Scripts\Activate.ps1" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "Virtual environment active: $env:VIRTUAL_ENV" -ForegroundColor Green

# Check if .env exists
if (-not (Test-Path ".env")) {
    Write-Host "WARNING: .env file not found!" -ForegroundColor Yellow
    Write-Host "Creating .env from .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "Created .env file. Please review and update if needed." -ForegroundColor Green
    Write-Host ""
}

# Check if PostgreSQL is running
Write-Host "Checking PostgreSQL database..." -ForegroundColor Cyan
$dockerRunning = docker ps --filter "name=my-postgres-db" --format "{{.Names}}" 2>$null

if ($dockerRunning -eq "my-postgres-db") {
    Write-Host "PostgreSQL is running" -ForegroundColor Green
} else {
    Write-Host "PostgreSQL container not running" -ForegroundColor Yellow
    Write-Host "Starting PostgreSQL container..." -ForegroundColor Yellow
    
    # Try to start existing container
    docker start my-postgres-db 2>$null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Creating new PostgreSQL container..." -ForegroundColor Yellow
        docker run --name my-postgres-db -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=turkiye_db -e POSTGRES_HOST_AUTH_METHOD=trust -p 5432:5432 -d postgres:15
    }
    
    Write-Host "PostgreSQL started" -ForegroundColor Green
    Write-Host "Waiting for database to be ready..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
}

Write-Host ""
Write-Host "Starting FastAPI server..." -ForegroundColor Cyan
Write-Host "   API: http://localhost:8080" -ForegroundColor White
Write-Host "   Docs (Swagger): http://localhost:8080/docs" -ForegroundColor White
Write-Host "   Docs (ReDoc): http://localhost:8080/redoc" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
Write-Host ""

# Start the server
uvicorn app.main:app --reload --host 127.0.0.1 --port 8080
