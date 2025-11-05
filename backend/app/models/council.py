from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from app.core.db import Base


class Council(Base):
    """
    Council (Belediye) model for organizing events and scholarships.
    """
    __tablename__ = "councils"
    
    id = Column(Integer, primary_key=True, index=True)
    council_name = Column(String, unique=True, nullable=False)
    city = Column(String, nullable=False)
    
    # Relationships
    events = relationship("Event", back_populates="organizator", cascade="all, delete-orphan")
    scholarships = relationship("Scholarship", back_populates="council", cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<Council(id={self.id}, name='{self.council_name}', city='{self.city}')>"
