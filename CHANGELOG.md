# Changelog

## [1.3.0](https://github.com/GostSergei/ai-for-developers-project-386/compare/v1.2.0...v1.3.0) (2026-08-28)


### Features

* **api:** добавить ограничения длины и формата полей в контракт ([bbaf1dc](https://github.com/GostSergei/ai-for-developers-project-386/commit/bbaf1dcd97d9648a0bcde84c1737c8eb290b0105))
* **backend:** ограничить длину полей брони и размер тела запроса ([cc0d7f9](https://github.com/GostSergei/ai-for-developers-project-386/commit/cc0d7f959bdfbb4b62a5ba3b9a5c782024398453))
* **frontend:** зеркалить лимиты полей в MSW-хендлерах ([243f247](https://github.com/GostSergei/ai-for-developers-project-386/commit/243f2474fd245d9973cf1698cde4bf7dfa7bb66b))


### Bug Fixes

* **api:** зафиксировать локальную семантику времени вместо utcDateTime ([815c96f](https://github.com/GostSergei/ai-for-developers-project-386/commit/815c96f7441609d90376a76c0f9294080fc3aebf))
* **api:** описать 400 BadRequestError у availability, day slots и создания типа события ([54e6c5a](https://github.com/GostSergei/ai-for-developers-project-386/commit/54e6c5aa7af307022bc6f3580fa9a4a6e690f1d3))
* **backend:** сделать проверку пересечения и запись брони атомарными ([ed81eac](https://github.com/GostSergei/ai-for-developers-project-386/commit/ed81eac551100c57e3c0742296f7e605eb7d25be))
* **docker:** запускать uvicorn как PID 1 для graceful shutdown ([ec45599](https://github.com/GostSergei/ai-for-developers-project-386/commit/ec45599f9f21c8ed3b9fc3610ce2f774c49e6d3b))
* устранить расхождения контракта и гонку при бронировании ([79b427b](https://github.com/GostSergei/ai-for-developers-project-386/commit/79b427b23c2e239259a0e37cd1c308395a53f7e7))

## [1.2.0](https://github.com/GostSergei/ai-for-developers-project-386/compare/v1.1.0...v1.2.0) (2026-08-20)


### Features

* seed default event types on first start ([20a9fbc](https://github.com/GostSergei/ai-for-developers-project-386/commit/20a9fbce10f2e05701852fedb55e744e9775376b))
* seed default event types on first start ([020cc6a](https://github.com/GostSergei/ai-for-developers-project-386/commit/020cc6a5847cbf24fe47ee554e45e553c93bb767))

## [1.1.0](https://github.com/GostSergei/ai-for-developers-project-386/compare/v1.0.0...v1.1.0) (2026-08-20)


### Features

* containerize app with Docker and compose, rework Makefile ([3334a99](https://github.com/GostSergei/ai-for-developers-project-386/commit/3334a9912912f9f3c822370f5694b6c2a5aa7978))


### Bug Fixes

* fix compose port mapping (container always on 8000, host PORT) ([6b1e072](https://github.com/GostSergei/ai-for-developers-project-386/commit/6b1e072ec98034b4b76b0d06f5c13c4bfdb269d4))
* stop browser cache from serving HTML to API requests ([814c8d5](https://github.com/GostSergei/ai-for-developers-project-386/commit/814c8d5308525972ea3b65e8cccb682a2aaa2e91))

## 1.0.0 (2026-08-19)


### Features

* **admin:** show all meetings from today including past ones ([cfb5c45](https://github.com/GostSergei/ai-for-developers-project-386/commit/cfb5c45665a804a95da5d4a0d9b7858cf24d966b))
* **admin:** use date-key aria-labels in date pickers ([84eabef](https://github.com/GostSergei/ai-for-developers-project-386/commit/84eabef8512a267224eb5d57b832ac518b4c93ba))
* **frontend:** point API client at the real backend ([a54635e](https://github.com/GostSergei/ai-for-developers-project-386/commit/a54635ecedb6a57af039862c3b5223e6b6cceccd))


### Bug Fixes

* **ci:** use .mjs extension for commitlint config ([bcc1fae](https://github.com/GostSergei/ai-for-developers-project-386/commit/bcc1fae2060092b2294761c29bb85d83ed143719))
* exclude guest slots that exceed working hours or overlap longer meetings ([f6f9200](https://github.com/GostSergei/ai-for-developers-project-386/commit/f6f9200a603131e2bbec3d87f4980fd917aef91f))
