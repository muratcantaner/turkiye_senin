from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session, selectinload
from typing import List

from app.core.db import get_db
from app.core.security import get_current_user
from app.models.user import User
from app.models.event import Event
from app.models.registration import Registration
from app.schemas.event import EventRead
from app.schemas.registration import RegistrationRead


router = APIRouter(prefix="/events", tags=["Events"])


@router.get("/", response_model=List[EventRead])
def get_all_events(db: Session = Depends(get_db)):
    """
    Get all events (public endpoint - no authentication required).
    
    Returns a list of all events with their details including organizer information.
    """
    events = db.query(Event).options(selectinload(Event.organizator)).all()
    return events


@router.get("/{event_id}", response_model=EventRead)
def get_event_by_id(event_id: int, db: Session = Depends(get_db)):
    """
    Get a single event by its ID (public endpoint).
    
    - **event_id**: The ID of the event to retrieve
    
    Returns event details including organizer information.
    """
    event = db.query(Event).options(selectinload(Event.organizator)).filter(Event.id == event_id).first()
    
    if not event:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Event with ID {event_id} not found"
        )
    
    return event


@router.post("/{event_id}/register", response_model=RegistrationRead, status_code=status.HTTP_201_CREATED)
def register_for_event(
    event_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Register the current user for an event.
    
    - **event_id**: The ID of the event to register for
    
    Requires authentication. Checks:
    - Event exists
    - User is not already registered
    - Event has not reached its participant limit
    """
    # Check if event exists
    event = db.query(Event).filter(Event.id == event_id).first()
    if not event:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Event with ID {event_id} not found"
        )
    
    # Check if user is already registered
    existing_registration = db.query(Registration).filter(
        Registration.user_id == current_user.id,
        Registration.event_id == event_id
    ).first()
    
    if existing_registration:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="You are already registered for this event"
        )
    
    # Check if event is full
    if event.is_full:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Event is full (limit: {event.event_limit} participants)"
        )
    
    # Create new registration
    new_registration = Registration(
        user_id=current_user.id,
        event_id=event_id
    )
    
    db.add(new_registration)
    db.commit()
    db.refresh(new_registration)
    
    return new_registration


@router.delete("/{event_id}/register", status_code=status.HTTP_204_NO_CONTENT)
def unregister_from_event(
    event_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Unregister the current user from an event.
    
    - **event_id**: The ID of the event to unregister from
    
    Requires authentication. Returns 204 No Content on success.
    """
    # Check if event exists
    event = db.query(Event).filter(Event.id == event_id).first()
    if not event:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Event with ID {event_id} not found"
        )
    
    # Check if user is registered
    registration = db.query(Registration).filter(
        Registration.user_id == current_user.id,
        Registration.event_id == event_id
    ).first()
    
    if not registration:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="You are not registered for this event"
        )
    
    # Delete registration
    db.delete(registration)
    db.commit()
    
    return None
