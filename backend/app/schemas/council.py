from pydantic import BaseModel, ConfigDict


class CouncilBase(BaseModel):
    """Base schema for Council with common fields"""
    council_name: str
    city: str


class CouncilCreate(CouncilBase):
    """Schema for creating a new council"""
    pass


class CouncilRead(CouncilBase):
    """Schema for reading council data"""
    id: int
    
    model_config = ConfigDict(from_attributes=True)
