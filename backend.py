from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy import create_engine, Column, Integer, String, Boolean, Float, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from pydantic import BaseModel, EmailStr
import jwt
from datetime import datetime, timedelta
from typing import Optional, List
import re
from auth import get_password_hash, get_current_user, verify_password
from email_service import send_verification_email
from models import RideRequest, ChatMessage, Review
import secrets

# Initialize FastAPI app
app = FastAPI(title="GC Rides Backend")

# Database configuration
SQLALCHEMY_DATABASE_URL = "sqlite:///./gcrides.db"  # Using SQLite for development
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoload=True, bind=engine)
Base = declarative_base()

# JWT Configuration
SECRET_KEY = "your-secret-key-here"  # Change this in production
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# Email validation regex for GCSU
GCSU_EMAIL_REGEX = r"^[a-zA-Z0-9._%+-]+@bobcats\.gcsu\.edu$"

# OAuth2 scheme for token authentication
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Database Models
class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    first_name = Column(String)
    last_name = Column(String)
    hashed_password = Column(String)
    is_verified = Column(Boolean, default=False)
    is_driver = Column(Boolean, default=False)
    profile_picture = Column(String, nullable=True)
    rating = Column(Float, default=0.0)
    rides_completed = Column(Integer, default=0)

class Driver(Base):
    __tablename__ = "drivers"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    vehicle_make = Column(String)
    vehicle_model = Column(String)
    seat_capacity = Column(Integer)
    payment_preferences = Column(String)
    graduation_year = Column(Integer)
    is_active = Column(Boolean, default=False)

# Pydantic Models for Request/Response
class UserCreate(BaseModel):
    email: EmailStr
    password: str
    first_name: str
    last_name: str

class UserResponse(BaseModel):
    id: int
    email: str
    first_name: str
    last_name: str
    is_verified: bool
    is_driver: bool
    rating: float
    
    class Config:
        orm_mode = True

# Helper functions
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def verify_gcsu_email(email: str) -> bool:
    return bool(re.match(GCSU_EMAIL_REGEX, email))

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

# API Endpoints
@app.post("/users/", response_model=UserResponse)
async def create_user(user: UserCreate, db: Session = Depends(get_db)):
    if not verify_gcsu_email(user.email):
        raise HTTPException(
            status_code=400,
            detail="Sorry, this app is only available for GC Students at this moment."
        )
    
    # Check if user already exists
    db_user = db.query(User).filter(User.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Create new user
    new_user = User(
        email=user.email,
        first_name=user.first_name,
        last_name=user.last_name,
        hashed_password=user.password  # Note: Implement proper password hashing!
    )
    
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

# Create database tables
Base.metadata.create_all(bind=engine)

# Add new Pydantic models
class DriverCreate(BaseModel):
    vehicle_make: str
    vehicle_model: str
    seat_capacity: int
    payment_preferences: str
    graduation_year: int

class RideRequestCreate(BaseModel):
    pickup_location: str
    destination: str
    party_size: int

class ChatMessageCreate(BaseModel):
    content: str
    is_ride_request: bool = False

# Add new endpoints
@app.post("/verify-email/{token}")
async def verify_email(token: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.verification_token == token).first()
    if not user:
        raise HTTPException(status_code=400, detail="Invalid verification token")
    
    user.is_verified = True
    user.verification_token = None
    db.commit()
    return {"message": "Email verified successfully"}

@app.post("/drivers/")
async def register_as_driver(
    driver_data: DriverCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    if not current_user.is_verified:
        raise HTTPException(status_code=400, detail="Please verify your email first")
    
    new_driver = Driver(
        user_id=current_user.id,
        **driver_data.dict()
    )
    
    current_user.is_driver = True
    db.add(new_driver)
    db.commit()
    return {"message": "Successfully registered as driver"}

@app.post("/ride-requests/")
async def create_ride_request(
    request: RideRequestCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    new_request = RideRequest(
        rider_id=current_user.id,
        status="pending",
        **request.dict()
    )
    db.add(new_request)
    db.commit()
    return new_request

@app.post("/chat/messages/")
async def send_message(
    message: ChatMessageCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    new_message = ChatMessage(
        sender_id=current_user.id,
        **message.dict()
    )
    db.add(new_message)
    db.commit()
    return new_message

@app.get("/drivers/active/")
async def get_active_drivers(db: Session = Depends(get_db)):
    return db.query(Driver).filter(Driver.is_active == True).all()

@app.post("/rides/{ride_id}/complete")
async def complete_ride(
    ride_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    ride = db.query(RideRequest).filter(RideRequest.id == ride_id).first()
    if not ride:
        raise HTTPException(status_code=404, detail="Ride not found")
    
    if ride.rider_id != current_user.id and ride.driver_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized")
    
    ride.status = "completed"
    ride.completed_at = datetime.utcnow()
    db.commit()
    return {"message": "Ride completed successfully"}

@app.post("/reviews/")
async def create_review(
    ride_id: int,
    rating: float,
    comment: str = None,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    ride = db.query(RideRequest).filter(RideRequest.id == ride_id).first()
    if not ride:
        raise HTTPException(status_code=404, detail="Ride not found")
    
    reviewed_id = ride.driver_id if current_user.id == ride.rider_id else ride.rider_id
    
    new_review = Review(
        ride_id=ride_id,
        reviewer_id=current_user.id,
        reviewed_id=reviewed_id,
        rating=rating,
        comment=comment
    )
    db.add(new_review)
    db.commit()
    return new_review

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
