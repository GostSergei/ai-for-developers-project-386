.PHONY: start stop restart

start:
	@mkdir -p .run
	@nohup backend/.venv/bin/python -m uvicorn app.main:app --app-dir backend --port 8000 </dev/null > .run/backend.log 2>&1 &
	@nohup npm run --prefix frontend dev -- --port 5173 </dev/null > .run/frontend.log 2>&1 &
	@echo "Started: http://localhost:5173 (front), http://localhost:8000 (api)"

stop:
	@-pkill -f '[u]vicorn app.main:app' || true
	@-pkill -f '[v]ite --port 5173' || true

restart: stop start