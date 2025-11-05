from pydantic import BaseModel, ConfigDict
from datetime import date
from app.schemas.council import CouncilRead


class ScholarshipBase(BaseModel):
    """Base schema for Scholarship with common fields"""
    title: str
    description: str
    deadline: date
    application_url: str


class ScholarshipCreate(ScholarshipBase):
    """Schema for creating a new scholarship"""
    council_id: int


class ScholarshipRead(ScholarshipBase):
    """Schema for reading scholarship data"""
    id: int
    council: CouncilRead
    
    model_config = ConfigDict(from_attributes=True)
