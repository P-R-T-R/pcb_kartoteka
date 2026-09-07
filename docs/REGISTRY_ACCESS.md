# Доступ к Docker-образам

Стабильные образы доступны публично в GitHub Container Registry:

- `ghcr.io/p-r-t-r/pcb-kartoteka-backend-stable`
- `ghcr.io/p-r-t-r/pcb-kartoteka-frontend-stable`

Для скачивания не нужны аккаунт GitHub, токен или `docker login`.
Репозиторий исходников и образы кандидатов RC остаются приватными.
Публичное скачивание не меняет условия лицензии приложения.

После настройки `.env` по `docs/RELEASE.md` проверьте выбранные образы:

```sh
docker compose config --images
docker compose pull
```

Оба имени должны содержать `-stable`, утвержденную версию и точный digest.
Тег `latest` не используется. Данные и пароли установки остаются в локальном
`.env` и базе; не добавляйте их в Git или сообщения.

## Обновление с 0.7.0

Старые имена без `-stable` больше не обновляются. Замените в существующем
`.env` пять значений из актуального `.env.example`: `APP_VERSION`,
`BACKEND_IMAGE`, `FRONTEND_IMAGE`, `BACKEND_DIGEST`, `FRONTEND_DIGEST`.
Сохраните остальные настройки. `git pull` не обновляет ваш `.env`.
В следующих релизах имена сохраняются, меняются версия и оба digest.

Если Docker сообщает ошибку авторизации, проверьте имена образов и старые
сохраненные учетные данные GHCR. Для независимой проверки публичного доступа:

```sh
anonymous_config="$(mktemp -d)"
docker --config "$anonymous_config" pull ghcr.io/p-r-t-r/pcb-kartoteka-backend-stable:0.8.1
docker --config "$anonymous_config" pull ghcr.io/p-r-t-r/pcb-kartoteka-frontend-stable:0.8.1
rmdir "$anonymous_config"
```

При недоступности пакетов сообщите владельцу продукта. Не заменяйте их старыми
образами без суффикса и не выполняйте запуск обновления после неудачного pull.
