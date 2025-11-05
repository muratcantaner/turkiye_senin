from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from app.core.db import get_db
from app.core.security import get_current_council_user
from app.models.council import Council
from app.models.event import Event
from app.models.user import User
from app.schemas.council import CouncilRead
from app.schemas.event import EventRead, EventCreateCouncil


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


@router.post("/me/events", response_model=EventRead, status_code=status.HTTP_201_CREATED)
def create_event_for_council(
    event_data: EventCreateCouncil,
    current_user: User = Depends(get_current_council_user),
    db: Session = Depends(get_db)
):
    # current_user.council_id must be set by council registration
    council = db.query(Council).filter(Council.id == current_user.council_id).first()
    if not council:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Council not found for current user")

    new_event = Event(
        event_name=event_data.event_name,
        event_date=event_data.event_date,
        event_location=event_data.event_location,
        event_category=event_data.event_category,
        event_description=event_data.event_description,
        event_limit=event_data.event_limit,
        event_price=event_data.event_price,
        organizator_id=current_user.council_id,
    )

    db.add(new_event)
    db.commit()
    db.refresh(new_event)

    return new_event


@router.delete("/me/events/{event_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_event_for_council(
    event_id: int,
    current_user: User = Depends(get_current_council_user),
    db: Session = Depends(get_db)
):
    event = db.query(Event).filter(Event.id == event_id, Event.organizator_id == current_user.council_id).first()
    if not event:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Event not found or not owned by council")

    db.delete(event)
    db.commit()

    return None
