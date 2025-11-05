from pydantic import BaseModel, ConfigDict
from datetime import date


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
    council_id: int
    
    model_config = ConfigDict(from_attributes=True)
