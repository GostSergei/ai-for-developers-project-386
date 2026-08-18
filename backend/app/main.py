import os
from datetime import date, datetime

from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from starlette.exceptions import HTTPException as StarletteHTTPException

from app import services
from app.schemas import (
    AdminDaySlots,
    AvailabilityRequest,
    AvailabilityResponse,
    Booking,
    BookingRequest,
    BookingsList,
    DaySlots,
    EventType,
    EventTypeInput,
)
from app.store import DEFAULT_DATA_FILE, Store


def create_app(
    store: Store | None = None,
    now_provider=None,
) -> FastAPI:
    app = FastAPI(title="Call Calendar API", version="1.0.0")
    app.state.store = store or Store(
        data_file=os.environ.get("DATA_FILE", DEFAULT_DATA_FILE)
    )
    app.state.now_provider = now_provider or datetime.now

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @app.exception_handler(RequestValidationError)
    async def on_request_validation_error(request: Request, exc: RequestValidationError):
        return JSONResponse(status_code=400, content={"error": "Invalid request"})

    @app.exception_handler(StarletteHTTPException)
    async def on_http_error(request: Request, exc: StarletteHTTPException):
        if isinstance(exc.detail, dict):
            return JSONResponse(status_code=exc.status_code, content=exc.detail)
        return JSONResponse(status_code=exc.status_code, content={"error": str(exc.detail)})

    @app.get(
        "/event-types",
        response_model=list[EventType],
        response_model_exclude_none=True,
    )
    def list_event_types():
        return list(app.state.store.event_types.values())

    @app.get(
        "/guest/{date}",
        response_model=DaySlots,
        response_model_exclude_none=True,
    )
    def guest_day_slots(date: date, eventType: str):
        store = app.state.store
        now = app.state.now_provider()
        return services.get_day_slots(store, date, eventType, now)

    @app.post(
        "/guest/{date}/availability",
        response_model=AvailabilityResponse,
        response_model_exclude_none=True,
    )
    def guest_availability(date: date, body: AvailabilityRequest):
        store = app.state.store
        now = app.state.now_provider()
        return services.availability(store, date, body, now)

    @app.post(
        "/guest/{date}/booking",
        response_model=Booking,
        response_model_exclude_none=True,
        status_code=201,
    )
    def guest_create_booking(date: date, body: BookingRequest):
        store = app.state.store
        now = app.state.now_provider()
        return services.build_booking(store, date, body, now)

    @app.post(
        "/admin/event-types",
        response_model=EventType,
        response_model_exclude_none=True,
        status_code=201,
    )
    def admin_create_event_type(body: EventTypeInput):
        return services.create_event_type(app.state.store, body)

    @app.get(
        "/admin/{date}",
        response_model=AdminDaySlots,
        response_model_exclude_none=True,
    )
    def admin_day_slots(date: date):
        store = app.state.store
        now = app.state.now_provider()
        return services.get_admin_day_slots(store, date, now)

    @app.get(
        "/admin",
        response_model=BookingsList,
        response_model_exclude_none=True,
    )
    @app.get(
        "/admin/",
        response_model=BookingsList,
        response_model_exclude_none=True,
        include_in_schema=False,
    )
    def admin_upcoming():
        store = app.state.store
        now = app.state.now_provider()
        return BookingsList(bookings=services.get_upcoming(store, now))

    return app


app = create_app()


if __name__ == "__main__":
    import uvicorn

    port = int(os.environ.get("PORT", "8000"))
    uvicorn.run("app.main:app", host="0.0.0.0", port=port)