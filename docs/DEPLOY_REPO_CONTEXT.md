# PCB Kartoteka deploy repo context

Дата фиксации: 2026-08-05.

Это внешний репозиторий развертывания:

```text
https://github.com/P-R-T-R/pcb_kartoteka.git
```

Локально:

```text
C:\hub\work_ai\pcb_kart\pcb_kartoteka
```

## Назначение

Этот репозиторий нужен клиенту/DevOps для установки PCB Kartoteka на своем
сервере.

Он должен быть независим от исходников приложения.

## Что можно хранить

- Docker Compose файлы;
- nginx/reverse proxy templates;
- `.env.example`;
- документацию запуска;
- документацию обновления;
- документацию backup/restore;
- security checklist;
- ссылки на официальные Docker-образы;
- примеры команд.

## Что нельзя хранить

- исходники backend/frontend;
- реальные `.env`;
- пароли;
- токены;
- дампы баз;
- клиентские файлы;
- закрытую внутреннюю документацию разработки;
- любые данные первого клиента.

## Связь с продуктовой репой

Приватная продуктовая репа:

```text
https://github.com/P-R-T-R-AI/pcb_kartoteka_inner.git
```

Она собирает Docker-образы. Этот deploy-репозиторий должен только ссылаться на
готовые образы:

```yaml
backend:
  image: ghcr.io/<owner>/pcb-kartoteka-backend:${APP_VERSION}

frontend:
  image: ghcr.io/<owner>/pcb-kartoteka-frontend:${APP_VERSION}
```

Точные имена образов будут зафиксированы позже.

## Клиентская база

База первого клиента передается отдельным файлом вне git:

```text
pcb_client_initial_YYYY-MM-DD.sql.gz
```

В этот репозиторий можно положить только общую инструкцию восстановления без
самого дампа.

## Правило разработки

Сначала стабилизируется приватная inner-репа:

1. чинятся текущие GitHub issues;
2. добавляются тесты;
3. CI становится зеленым;
4. проверяется client-like установка.

Только потом этот deploy-репозиторий заполняется рабочими compose-файлами.
