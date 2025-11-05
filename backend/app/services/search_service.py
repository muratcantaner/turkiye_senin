from typing import List, Dict, Optional

import numpy as np
import faiss
from sentence_transformers import SentenceTransformer
from sqlalchemy.orm import Session, selectinload

from app.models.event import Event


_MODEL: Optional[SentenceTransformer] = None
_INDEX: Optional[faiss.IndexFlatIP] = None
_ID_MAP: List[int] = []
_CORPUS_COUNT: int = 0
_DIM: int = 384  # all-MiniLM-L6-v2 embedding size


def _get_model() -> SentenceTransformer:
    global _MODEL
    if _MODEL is None:
        _MODEL = SentenceTransformer("all-MiniLM-L6-v2")
    return _MODEL


def _fetch_events(db: Session) -> List[Event]:
    return db.query(Event).all()


def _build_index(db: Session) -> None:
    global _INDEX, _ID_MAP, _CORPUS_COUNT

    events = _fetch_events(db)
    _ID_MAP = [e.id for e in events]

    if not events:
        _INDEX = faiss.IndexFlatIP(_DIM)
        _CORPUS_COUNT = 0
        return

    texts: List[str] = []
    for e in events:
        parts = [e.event_name or "", e.event_category or "", e.event_location or ""]
        # event_description may be None (optional)
        if getattr(e, "event_description", None):
            parts.append(e.event_description)
        texts.append(" \n ".join(parts))

    model = _get_model()
    emb = model.encode(texts, convert_to_numpy=True, normalize_embeddings=True)
    emb = emb.astype("float32")

    # FAISS inner-product index; embeddings are normalized so IP == cosine
    _INDEX = faiss.IndexFlatIP(emb.shape[1])
    _INDEX.add(emb)
    _CORPUS_COUNT = len(events)


def search(query: str, db: Session, k: int = 5) -> List[Event]:
    """
    Perform semantic search over Event entries stored in DB.
    Returns a list of Event ORM objects ordered by similarity.
    """
    global _INDEX, _ID_MAP, _CORPUS_COUNT

    # (Re)build index if needed
    total = db.query(Event).count()
    if _INDEX is None or total != _CORPUS_COUNT:
        _build_index(db)

    if _CORPUS_COUNT == 0:
        return []

    model = _get_model()
    q = model.encode([query], convert_to_numpy=True, normalize_embeddings=True).astype("float32")
    D, I = _INDEX.search(q, min(k, _CORPUS_COUNT))
    idxs = I[0].tolist()
    ids = [ _ID_MAP[i] for i in idxs if 0 <= i < len(_ID_MAP) ]

    if not ids:
        return []

    # Fetch and preserve ranking order
    rows = db.query(Event).options(selectinload(Event.organizator)).filter(Event.id.in_(ids)).all()
    by_id: Dict[int, Event] = {r.id: r for r in rows}
    ordered: List[Event] = [by_id[i] for i in ids if i in by_id]
    return ordered
