from pydantic import BaseModel, ConfigDict
from typing import Optional


class UserBase(BaseModel):
    """Base schema for User with common fields"""
    email: str
    user_name: str
    user_surname: str
    user_city: Optional[str] = None


class UserCreate(UserBase):
    """Schema for creating a new user (includes password)"""
    password: str


class CouncilUserCreate(UserBase):
    password: str
    council_id: int


class UserUpdate(BaseModel):
    """Schema for updating user information"""
    user_name: Optional[str] = None
    user_surname: Optional[str] = None
    user_city: Optional[str] = None


class UserRead(UserBase):
    """Schema for reading user data (excludes password)"""
    id: int
    is_admin: bool
    is_council: bool
    council_id: Optional[int] = None
    
    model_config = ConfigDict(from_attributes=True)
