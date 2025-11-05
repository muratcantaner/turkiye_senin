from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.orm import relationship
from app.core.db import Base


class Scholarship(Base):
    """
    Scholarship model for educational funding opportunities.
    """
    __tablename__ = "scholarships"
    
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(String, nullable=False)
    deadline = Column(Date, nullable=False)
    application_url = Column(String, nullable=False)
    
    # Foreign Keys
    council_id = Column(Integer, ForeignKey("councils.id"), nullable=False)
    
    # Relationships
    council = relationship("Council", back_populates="scholarships")
    
    def __repr__(self):
        return f"<Scholarship(id={self.id}, title='{self.title}', deadline='{self.deadline}')>"
