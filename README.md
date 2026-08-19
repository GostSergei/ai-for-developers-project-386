# Календарь звонков

Сервис бронирования слотов для встреч. Гость выбирает тип события, открывает календарь на 14 дней и бронирует свободный слот без регистрации. Владелец календаря создаёт типы событий и просматривает встречи (начиная с сегодняшнего дня, включая уже прошедшие сегодня).

## Документация

- [API-контракт](docs/api-contract.md) — эндпоинты, модели данных и правила бронирования;
- [Пользовательские сценарии](docs/user-scenarios.md) — основные сценарии для проверки (покрыты e2e-тестами);
- `main.tsp` — TypeSpec-спецификация (компилируется в OpenAPI).

Компиляция спецификации:

```
npm install --save-dev @typespec/compiler @typespec/http @typespec/openapi3
npx tsp compile main.tsp --emit @typespec/openapi3
```

## Запуск (фронт + бэк)

Бэкенд (FastAPI, порт 8000):

```
cd backend
python -m venv .venv
.venv/bin/pip install -r requirements.txt
.venv/bin/uvicorn app.main:app --port 8000
```

Фронтенд (Vite, порт 5173):

```
cd frontend
npm ci
npm run dev
```

Откройте http://localhost:5173. Фронтенд по умолчанию обращается к `http://localhost:8000`
(переопределяется через `VITE_API_BASE_URL`). Prism-mock на базе спецификации опционален:

```
npm run mock   # Prism на порту 4010
```

## Тесты

- Бэкенд (юнит + API): `cd backend && .venv/bin/python -m pytest tests -q`
- Фронтенд (vitest, с MSW-моками): `cd frontend && npm test`
- Интеграционные (Playwright, реальный стек фронт + бэк):

```
cd frontend
npm install -D @playwright/test
npx playwright install chromium
npm run test:e2e
```

`npm run test:e2e` сам поднимает FastAPI (чистое YAML-хранилище) и сборку фронта
(vite preview); адрес API подставляется через `VITE_API_BASE_URL=http://localhost:8000`.

### Playwright MCP

Для интерактивного браузерного тестирования через агента в проект добавлен
[Playwright MCP](https://github.com/microsoft/playwright-mcp) (см.
`.opencode/opencode.json`). После перезапуска opencode агент получает
инструменты управления браузером (`browser_navigate`, `browser_click` и т.д.).
Требуется установленный Chromium:

```
npx playwright install chromium
```

## CI (GitHub Actions)

- `.github/workflows/ci.yml` — бэкенд (pytest), фронтенд (typecheck + lint +
  vitest с компиляцией TypeSpec) и интеграционные e2e-тесты (Playwright).
- `.github/workflows/commitlint.yml` — проверка Conventional Commits в PR.
- `.github/workflows/release-please.yml` — автоматический release-PR и релизы
  на основе Conventional Commits.

## Формат коммитов (Conventional Commits)

Все коммиты (в том числе автоматические, сделанные агентом) следуют
[Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <описание>

[optional body]
```

Типы: `feat` (новая функциональность → minor), `fix` (исправление → patch),
`chore`, `docs`, `test`, `ci`, `refactor`, `style`. При наличии `feat!`/`BREAKING CHANGE`
версия растёт major. История коммитов анализируется `release-please`, поэтому
нарушение формата ломает автоматический релиз.

### Hexlet tests and linter status:
[![Actions Status](https://github.com/GostSergei/ai-for-developers-project-386/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/GostSergei/ai-for-developers-project-386/actions)
