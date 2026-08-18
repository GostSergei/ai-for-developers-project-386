# Календарь звонков

Сервис бронирования слотов для встреч. Гость выбирает тип события, открывает календарь на 14 дней и бронирует свободный слот без регистрации. Владелец календаря создаёт типы событий и просматривает предстоящие встречи.

## Документация

- [API-контракт](docs/api-contract.md) — эндпоинты, модели данных и правила бронирования;
- `main.tsp` — TypeSpec-спецификация (компилируется в OpenAPI).

Компиляция спецификации:

```
npm install --save-dev @typespec/compiler @typespec/http @typespec/openapi3
npx tsp compile main.tsp --emit @typespec/openapi3
```

### Hexlet tests and linter status:
[![Actions Status](https://github.com/GostSergei/ai-for-developers-project-386/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/GostSergei/ai-for-developers-project-386/actions)
