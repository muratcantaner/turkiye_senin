from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import Optional
from app.schemas.council import CouncilRead


class EventBase(BaseModel):
    """Base schema for Event with common fields"""
    event_name: str
    event_date: datetime
    event_location: str
    event_category: str
    event_description: Optional[str] = None
    event_limit: Optional[int] = None
    event_price: float = 0.0


class EventCreate(EventBase):
    """Schema for creating a new event"""
    organizator_id: int


class EventCreateCouncil(EventBase):
    pass


class EventRead(EventBase):
    """Schema for reading event data"""
    id: int
    organizator: CouncilRead
    
    model_config = ConfigDict(from_attributes=True)
