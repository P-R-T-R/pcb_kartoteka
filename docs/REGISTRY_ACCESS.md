# Доступ к Docker-образам

Готовые образы PCB Kartoteka хранятся в приватном GitHub Container Registry:

- `ghcr.io/p-r-t-r/pcb-kartoteka-backend-stable`
- `ghcr.io/p-r-t-r/pcb-kartoteka-frontend-stable`

Исходный код и образы не публикуются для анонимного скачивания. До установки
владелец продукта предоставляет GitHub-пользователю компании право чтения этих
двух пакетов. Компания создает собственный Personal Access Token (classic)
только с разрешением `read:packages`.

Войдите в registry интерактивно, не записывая токен в команду или историю:

```sh
read -rsp "GHCR token: " GHCR_TOKEN; echo
printf '%s' "$GHCR_TOKEN" | docker login ghcr.io -u CLIENT_GITHUB_LOGIN --password-stdin
unset GHCR_TOKEN
```

Проверьте доступ без запуска сервиса:

```sh
docker pull ghcr.io/p-r-t-r/pcb-kartoteka-backend-stable:0.8.1
docker pull ghcr.io/p-r-t-r/pcb-kartoteka-frontend-stable:0.8.1
```

Не добавляйте токен в `.env`, Compose, Git, документацию, тикеты или сообщения.
На постоянном сервере настройте поддерживаемый Docker credential helper. Для
разовой установки после скачивания можно выполнить `docker logout ghcr.io`;
запущенные контейнеры продолжат работать, но следующее обновление снова
потребует входа.

Используйте только версию и точные digest из `docs/RELEASE.md`. Тег `latest` не
используется. Если доступ больше не нужен или токен мог быть раскрыт, отзовите
токен в GitHub и сообщите владельцу продукта для снятия доступа к пакетам.
