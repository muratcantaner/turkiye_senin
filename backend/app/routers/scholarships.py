from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List

from app.core.db import get_db
from app.models.scholarship import Scholarship
from app.schemas.scholarship import ScholarshipRead


router = APIRouter(prefix="/scholarships", tags=["Scholarships"])


@router.get("/", response_model=List[ScholarshipRead])
def get_all_scholarships(db: Session = Depends(get_db)):
    """
    Get all scholarships (public endpoint - no authentication required).
    
    Returns a list of all available scholarships with:
    - Title and description
    - Application deadline
    - Application URL
    - Organizing council information
    """
    scholarships = db.query(Scholarship).all()
    return scholarships
