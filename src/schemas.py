from pydantic import BaseModel, ConfigDict

class CreateBook(BaseModel):
    title: str
    author: str
    year: int

class BookOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    title: str
    author: str
    year: int
