# app.py
from fastapi import FastAPI, APIRouter
from fastapi.middleware.cors import CORSMiddleware

from routers import customers, vehicles, bookings, schedule, stats


# Create API instance
api = FastAPI(
    title="Kalendar API",
    description="Backend API service for Kalendar",
    version="1.0.0",
    contact={
        "name": "Tem Tamre",
        "url": "https://ttamre.github.io/",
        "email": "temtamre@gmail.com"
    }
)

# Set permissions
api.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "https://kalendar.ca"],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PATCH", "DELETE"],
    allow_headers=["*"],
)

# Join routers into master API router and add to API instance
api_router = APIRouter(prefix="/api")
api_router.include_router(customers.router)
api_router.include_router(vehicles.router)
api_router.include_router(bookings.router)
api_router.include_router(schedule.router)
api_router.include_router(stats.router)
api.include_router(api_router)


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(api, host="0.0.0.0", port=5000)