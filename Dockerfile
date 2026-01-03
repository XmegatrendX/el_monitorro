# ---- Build stage ----
FROM rust:1.72 as builder

WORKDIR /app

COPY . .

# Собираем release-бинарники
RUN cargo build --release

# ---- Final stage ----
FROM debian:bullseye-slim

WORKDIR /app

# Копируем бинарники из билдера
COPY --from=builder /app/target/release/bot ./bot
COPY --from=builder /app/target/release/sync ./sync
COPY --from=builder /app/target/release/deliver ./deliver

# Копируем entrypoint
COPY entrypoint.sh .

# Делаем entrypoint исполняемым
RUN chmod +x entrypoint.sh

# Запуск при старте контейнера
ENTRYPOINT ["./entrypoint.sh"]
