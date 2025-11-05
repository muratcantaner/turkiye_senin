from pydantic import BaseModel, ConfigDict
from typing import List
from app.schemas.event import EventRead


class SearchRequest(BaseModel):
    query: str
    top_k: int = 5


class SearchResponse(BaseModel):
    query: str
    results: List[EventRead]
    
    model_config = ConfigDict(from_attributes=True)
