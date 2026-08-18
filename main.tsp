import "@typespec/http";

using TypeSpec.Http;

@service(#{ title: "Call Calendar API" })
namespace CallCalendar;

// ---------- Shared models ----------

@doc("Тип события: метка события с длительностью.")
model EventType {
  @doc("Задаётся владельцем, уникальная строка, не более 50 символов.")
  id: string;

  @doc("Название, не более 100 символов.")
  name: string;

  @doc("Описание, не более 1000 символов.")
  description?: string;

  @doc("Длительность в минутах, кратна 30.")
  duration: int32;
}

@doc("Тело запроса на создание типа события.")
model EventTypeInput {
  @doc("Уникальный идентификатор, задаётся владельцем.")
  id: string;

  name: string;
  description?: string;
  duration: int32;
}

@doc("Статус 30-минутного слота. Единый для гостя и владельца.")
enum SlotStatus {
  @doc("Слот свободен.")
  free,

  @doc("Слот занят бронью.")
  booked,
}

@doc("30-минутная ячейка сетки.")
model Slot {
  @doc("Начало ячейки, ISO 8601.")
  startsAt: utcDateTime;
  status: SlotStatus;
}

@doc("Слот с деталями брони (вид владельца).")
model AdminSlot {
  startsAt: utcDateTime;
  status: SlotStatus;
  booking?: BookingInfo;
}

@doc("Информация о брони внутри слота.")
model BookingInfo {
  id: int32;
  eventType: EventType;
  guestName: string;
  guestContact: string;
}

@doc("Бронирование.")
model Booking {
  id: int32;
  eventTypeId: string;
  eventTypeName: string;
  duration: int32;
  guestName: string;
  guestContact: string;
  startsAt: utcDateTime;

  @doc("Вычисляется как startsAt + duration.")
  endsAt: utcDateTime;
}

// ---------- Request/response DTOs ----------

@doc("Ответ: слоты за день для выбранного типа события (гость).")
model DaySlots {
  date: plainDate;
  eventType: EventType;
  slots: Slot[];
}

@doc("Ответ: все слоты и брони за день (владелец).")
model AdminDaySlots {
  date: plainDate;
  slots: AdminSlot[];
}

@doc("Список предстоящих встреч.")
model BookingsList {
  bookings: Booking[];
}

@doc("Проверка доступности слота.")
model AvailabilityRequest {
  @doc("Время начала, формат HH:MM.")
  time: string;
  eventTypeId: string;
}

enum AvailabilityReason {
  @doc("Слот занят.")
  booked,

  @doc("Дата вне окна 14 дней.")
  "out-of-window",

  @doc("Встреча выходит за рабочие часы 08:00–20:00.")
  "out-of-hours",

  @doc("Время не попадает на границу сетки 30 минут.")
  "invalid-grid",

  @doc("Время уже наступило.")
  "already-passed",
}

model AvailabilityResponse {
  available: boolean;
  reason?: AvailabilityReason;
}

@doc("Создание бронирования.")
model BookingRequest {
  @doc("Время начала, формат HH:MM.")
  time: string;
  eventTypeId: string;
  guestName: string;
  guestContact: string;
}

// ---------- Errors ----------

@error
model NotFoundError {
  @statusCode status: 404;
  error: string;
}

@error
model ConflictError {
  @statusCode status: 409;
  error: string;
}

@error
model ValidationError {
  @statusCode status: 422;
  errors: ValidationErrorItem[];
}

model ValidationErrorItem {
  field: string;
  message: string;
}

@error
model BadRequestError {
  @statusCode status: 400;
  error: string;
}

@doc("Ответ 201 Created: бронирование.")
model BookingCreated {
  @statusCode status: 201;
  ...Booking;
}

@doc("Ответ 201 Created: тип события.")
model EventTypeCreated {
  @statusCode status: 201;
  ...EventType;
}

// ---------- Common endpoints ----------

@route("/event-types")
@doc("Список типов событий: доступен гостю и владельцу.")
namespace EventTypes {
  @get
  @doc("Вернуть все типы событий.")
  op list(): EventType[];
}

// ---------- Guest endpoints ----------

@doc("Гостевые endpoints: просмотр и бронирование слотов.")
namespace Guest {
  @route("/guest/{date}")
  @get
  @doc("Слоты за день для выбранного типа события.")
  op daySlots(
    @path date: plainDate,
    @query eventType: string,
  ): DaySlots | NotFoundError;

  @route("/guest/{date}/availability")
  @post
  @doc("Проверка доступности слота без создания брони.")
  op availability(
    @path date: plainDate,
    @body body: AvailabilityRequest,
  ): AvailabilityResponse | NotFoundError;

  @route("/guest/{date}/booking")
  @post
  @doc("Создание бронирования.")
  op createBooking(
    @path date: plainDate,
    @body body: BookingRequest,
  ): BookingCreated | NotFoundError | ConflictError | ValidationError | BadRequestError;
}

// ---------- Owner endpoints ----------

@doc("Endpoints владельца календаря.")
namespace Admin {
  @route("/admin/event-types")
  @post
  @doc("Создать тип события.")
  op createEventType(
    @body body: EventTypeInput,
  ): EventTypeCreated | ConflictError | ValidationError;

  @route("/admin/{date}")
  @get
  @doc("Все слоты за день со всеми типами и бронями.")
  op daySlots(
    @path date: plainDate,
  ): AdminDaySlots | NotFoundError;

  @route("/admin")
  @get
  @doc("Предстоящие встречи: все брони всех типов, startsAt >= now, по возрастанию.")
  op upcoming(): BookingsList;
}
