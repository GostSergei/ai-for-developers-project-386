SHELL := /bin/bash

BACKEND_PORT ?= 8000
FRONTEND_PORT ?= 5173
LOG_DIR := .run

.PHONY: start stop restart status logs

## start: запустить бэкенд и фронтенд в фоне (предварительно останавливая текущие)
start: stop
	@mkdir -p $(LOG_DIR)
	@echo "==> Starting backend on :$(BACKEND_PORT)"
	@setsid bash -c 'cd backend && exec .venv/bin/python -m uvicorn app.main:app --port $(BACKEND_PORT)' </dev/null >$(LOG_DIR)/backend.log 2>&1 &
	@echo "==> Starting frontend on :$(FRONTEND_PORT)"
	@setsid bash -c 'if [ -d "$$HOME/.nvm" ]; then . "$$HOME/.nvm/nvm.sh"; fi; cd frontend && exec npm run dev -- --port $(FRONTEND_PORT) --strictPort' </dev/null >$(LOG_DIR)/frontend.log 2>&1 &
	@echo "==> Backend:  http://localhost:$(BACKEND_PORT)"
	@echo "==> Frontend: http://localhost:$(FRONTEND_PORT)"
	@echo "==> Logs:     $(LOG_DIR)/backend.log, $(LOG_DIR)/frontend.log"
	@echo "==> Done. Use 'make status' to verify."

## stop: остановить текущие бэкенд и фронтенд
stop:
	@echo "==> Stopping frontend (vite)..."
	@-pkill -f '[v]ite --port $(FRONTEND_PORT)' 2>/dev/null; pkill -f '[n]pm exec vite' 2>/dev/null || true
	@echo "==> Stopping backend (uvicorn)..."
	@-pkill -f '[u]vicorn app.main:app' 2>/dev/null || true
	@echo "==> Done."

## restart: перезапустить проект
restart: start

## status: показать запущенные процессы проекта
status:
	@echo "==> Backend on :$(BACKEND_PORT)"
	@ps -eo pid,args | grep -E "uvicorn app.main:app --port $(BACKEND_PORT)$$" | grep -v grep || echo "    not running"
	@echo "==> Frontend on :$(FRONTEND_PORT)"
	@ps -eo pid,args | grep -E "vite --port $(FRONTEND_PORT)" | grep -v grep || echo "    not running"

## logs: показать последние строки логов
logs:
	@tail -n 30 $(LOG_DIR)/backend.log 2>/dev/null || echo "no backend log"
	@echo "---"
	@tail -n 30 $(LOG_DIR)/frontend.log 2>/dev/null || echo "no frontend log"
