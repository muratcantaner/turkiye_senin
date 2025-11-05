from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from app.core.db import get_db
from app.models.council import Council
from app.schemas.council import CouncilRead
from app.schemas.event import EventRead


router = APIRouter(prefix="/councils", tags=["Councils"])


@router.get("/", response_model=List[CouncilRead])
def get_all_councils(db: Session = Depends(get_db)):
    """
    Get all councils (public endpoint - no authentication required).
    
    Returns a list of all municipal councils with their information.
    """
    councils = db.query(Council).all()
    return councils


@router.get("/{council_id}/events", response_model=List[EventRead])
def get_council_events(council_id: int, db: Session = Depends(get_db)):
    """
    Get all events organized by a specific council (public endpoint).
    
    - **council_id**: The ID of the council
    
    Returns a list of events organized by the specified council.
    """
    # Check if council exists
    council = db.query(Council).filter(Council.id == council_id).first()
    if not council:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Council with ID {council_id} not found"
        )
    
    # Return council's events through the relationship
    return council.events
