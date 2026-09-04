# Утвержденный релиз

Version: `0.8.1`

Published from source commit:

`bfdfbb121039dcd18d022f25d942d0ddf7dc0ff5`

Утвержденные private stable images:

- Backend: `ghcr.io/p-r-t-r/pcb-kartoteka-backend-stable:0.8.1@sha256:fd13402e596bd47cdd0098682a872e271bc0ef7b7ad5a95794eea67b4aa1095c`
- Frontend: `ghcr.io/p-r-t-r/pcb-kartoteka-frontend-stable:0.8.1@sha256:85a812da6d2ce0c4c7472e34ca130e73eca26050dfcd2fdb1bf1b373d5a8d457`

Образы прошли тесты приложения, проверку содержимого, сканирование
HIGH/CRITICAL-уязвимостей, приемку на тестовом адресе и развертывание на
production владельца. Стабильные теги получены копированием утвержденного RC
без пересборки, поэтому digest совпадают с проверенным кандидатом.

Пакеты остаются private. Для скачивания требуется выданный компании доступ и
собственный токен только с `read:packages`; порядок описан в
`docs/REGISTRY_ACCESS.md`. Не заменяйте эту версию тегом `latest`.
