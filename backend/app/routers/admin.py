from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.db import get_db
from app.core.security import get_current_admin_user
from app.models.user import User
from app.models.council import Council
from app.models.event import Event
from app.models.scholarship import Scholarship
from app.schemas.council import CouncilCreate, CouncilRead
from app.schemas.event import EventCreate, EventRead
from app.schemas.scholarship import ScholarshipCreate, ScholarshipRead


router = APIRouter(
    prefix="/admin",
    tags=["Admin"],
    dependencies=[Depends(get_current_admin_user)]
)


@router.post("/councils", response_model=CouncilRead, status_code=status.HTTP_201_CREATED)
def create_council(
    council_data: CouncilCreate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    """
    Create a new council (Admin only).
    
    - **council_name**: Name of the municipal council (must be unique)
    - **city**: City where the council operates
    
    Requires admin authentication.
    """
    # Check if council name already exists
    existing_council = db.query(Council).filter(
        Council.council_name == council_data.council_name
    ).first()
    
    if existing_council:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Council with name '{council_data.council_name}' already exists"
        )
    
    # Create new council
    new_council = Council(
        council_name=council_data.council_name,
        city=council_data.city
    )
    
    db.add(new_council)
    db.commit()
    db.refresh(new_council)
    
    return new_council


@router.post("/events", response_model=EventRead, status_code=status.HTTP_201_CREATED)
def create_event(
    event_data: EventCreate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    """
    Create a new event (Admin only).
    
    - **event_name**: Name of the event
    - **event_date**: Date and time of the event
    - **event_location**: Location where the event will take place
    - **event_category**: Category/type of the event
    - **event_limit**: Maximum number of participants (optional, null = unlimited)
    - **event_price**: Ticket price (default: 0.0 for free events)
    - **organizator_id**: ID of the organizing council
    
    Requires admin authentication.
    """
    # Verify that the organizing council exists
    council = db.query(Council).filter(Council.id == event_data.organizator_id).first()
    if not council:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Council with ID {event_data.organizator_id} not found"
        )
    
    # Create new event
    new_event = Event(
        event_name=event_data.event_name,
        event_date=event_data.event_date,
        event_location=event_data.event_location,
        event_category=event_data.event_category,
        event_description=event_data.event_description,
        event_limit=event_data.event_limit,
        event_price=event_data.event_price,
        organizator_id=event_data.organizator_id
    )
    
    db.add(new_event)
    db.commit()
    db.refresh(new_event)
    
    return new_event


@router.post("/scholarships", response_model=ScholarshipRead, status_code=status.HTTP_201_CREATED)
def create_scholarship(
    scholarship_data: ScholarshipCreate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    """
    Create a new scholarship (Admin only).
    
    - **title**: Scholarship title
    - **description**: Detailed description of the scholarship
    - **deadline**: Application deadline date
    - **application_url**: URL where users can apply
    - **council_id**: ID of the council offering the scholarship
    
    Requires admin authentication.
    """
    # Verify that the council exists
    council = db.query(Council).filter(Council.id == scholarship_data.council_id).first()
    if not council:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Council with ID {scholarship_data.council_id} not found"
        )
    
    # Create new scholarship
    new_scholarship = Scholarship(
        title=scholarship_data.title,
        description=scholarship_data.description,
        deadline=scholarship_data.deadline,
        application_url=scholarship_data.application_url,
        council_id=scholarship_data.council_id
    )
    
    db.add(new_scholarship)
    db.commit()
    db.refresh(new_scholarship)
    
    return new_scholarship
