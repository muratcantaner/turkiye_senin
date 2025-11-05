from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.core.db import Base


class Event(Base):
    """
    Event model for activities organized by councils.
    """
    __tablename__ = "events"
    
    id = Column(Integer, primary_key=True, index=True)
    event_name = Column(String, nullable=False)
    event_date = Column(DateTime, nullable=False)
    event_location = Column(String, nullable=False)
    event_category = Column(String, nullable=False)
    event_description = Column(String, nullable=True)
    event_limit = Column(Integer, nullable=True)  # Max participants (None = unlimited)
    event_price = Column(Float, default=0.0, nullable=False)
    
    # Foreign Keys
    organizator_id = Column(Integer, ForeignKey("councils.id"), nullable=False)
    
    # Relationships
    organizator = relationship("Council", back_populates="events")
    registrations = relationship("Registration", back_populates="event", cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<Event(id={self.id}, name='{self.event_name}', date='{self.event_date}')>"
    
    @property
    def current_participants(self):
        """Get the current number of registered participants"""
        return len(self.registrations)
    
    @property
    def is_full(self):
        """Check if the event has reached its participant limit"""
        if self.event_limit is None:
            return False
        return self.current_participants >= self.event_limit
