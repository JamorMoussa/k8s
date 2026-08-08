from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import select

from src.schemas import CreateBook, BookOut
from src import models
from src.db import get_db

book_router = APIRouter(prefix="/api/v1/book")


@book_router.post("/create", response_model=BookOut)
def create(book: CreateBook, session=Depends(get_db)):

    book = models.Book(**book.model_dump())

    session.add(book)
    session.commit()
    session.refresh(book)

    return book


@book_router.get("/books/{book_id}", response_model=BookOut)
def get_book(book_id: int, session=Depends(get_db)):
    book = session.get(models.Book, book_id)

    if book is None:
        raise HTTPException(status_code=404, detail="Book not found")

    return book


@book_router.get("/books", response_model=list[BookOut])
def get_books(session = Depends(get_db)):
    return session.query(models.Book).offset(0).limit(10).all()
