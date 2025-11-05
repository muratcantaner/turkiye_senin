from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.orm import relationship
from app.core.db import Base


class User(Base):
    """
    User model for authentication and profile management.
    """
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    user_name = Column(String, nullable=False)
    user_surname = Column(String, nullable=False)
    user_city = Column(String, nullable=True)
    is_admin = Column(Boolean, default=False, nullable=False)
    
    # Relationships
    registrations = relationship("Registration", back_populates="user", cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<User(id={self.id}, email='{self.email}', name='{self.user_name} {self.user_surname}')>"
