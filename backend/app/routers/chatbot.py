from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.db import get_db
from app.services.search_service import search
from app.schemas.chatbot import SearchRequest, SearchResponse

router = APIRouter(prefix="/search", tags=["Search & AI"])


@router.post("/", response_model=SearchResponse)
def semantic_search_events(
    request: SearchRequest,
    db: Session = Depends(get_db)
):
    matched_events = search(query=request.query, db=db, k=request.top_k)
    return SearchResponse(query=request.query, results=matched_events)
