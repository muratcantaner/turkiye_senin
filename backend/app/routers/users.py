from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List

from app.core.db import get_db
from app.core.security import get_current_user
from app.models.user import User
from app.schemas.user import UserRead
from app.schemas.event import EventRead


router = APIRouter(prefix="/users", tags=["Users"])


@router.get("/me", response_model=UserRead)
def get_current_user_profile(current_user: User = Depends(get_current_user)):
    """
    Get the current authenticated user's profile.
    
    Requires authentication token in the Authorization header.
    """
    return current_user


@router.get("/me/events", response_model=List[EventRead])
def get_current_user_events(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Get all events that the current user has registered for.
    
    Returns a list of events with their details including:
    - Event information (name, date, location, category, price)
    - Organizer (council) information
    
    Requires authentication token in the Authorization header.
    """
    # Get events through the user's registrations relationship
    events = [registration.event for registration in current_user.registrations]
    return events
