from sqlalchemy import Column, Integer, ForeignKey, UniqueConstraint
from sqlalchemy.orm import relationship
from app.core.db import Base


class Registration(Base):
    """
    Registration model for many-to-many relationship between users and events.
    A user can register for multiple events, and an event can have multiple users.
    """
    __tablename__ = "registrations"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    event_id = Column(Integer, ForeignKey("events.id"), nullable=False)
    
    # Relationships
    user = relationship("User", back_populates="registrations")
    event = relationship("Event", back_populates="registrations")
    
    # Ensure a user can only register once for each event
    __table_args__ = (
        UniqueConstraint('user_id', 'event_id', name='unique_user_event_registration'),
    )
    
    def __repr__(self):
        return f"<Registration(id={self.id}, user_id={self.user_id}, event_id={self.event_id})>"
