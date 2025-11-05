from pydantic import BaseModel, ConfigDict


class RegistrationBase(BaseModel):
    """Base schema for Registration with common fields"""
    user_id: int
    event_id: int


class RegistrationCreate(BaseModel):
    """Schema for creating a new registration (event_id will come from path)"""
    pass


class RegistrationRead(RegistrationBase):
    """Schema for reading registration data"""
    id: int
    
    model_config = ConfigDict(from_attributes=True)
