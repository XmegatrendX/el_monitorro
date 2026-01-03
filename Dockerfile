# ---- Build stage ----
FROM rust:1.72 as builder

# Устанавливаем системные зависимости для Rust (OpenSSL, pkg-config)
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копируем исходники
COPY . .

# Собираем release-бинарники
RUN cargo build --release

# ---- Final stage ----
FROM debian:bullseye-slim

# Устанавливаем зависимости для запуска бинарников (если нужны)
RUN apt-get update && apt-get install -y \
    libssl1.1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копируем бинарники из builder
COPY --from=builder /app/target/release/bot ./bot
COPY --from=builder /app/target/release/sync ./sync
COPY --from=builder /app/target/release/deliver ./deliver

# Копируем entrypoint
COPY entrypoint.sh .

# Делаем entrypoint исполняемым
RUN chmod +x entrypoint.sh

# Запуск всех бинарников при старте контейнера
ENTRYPOINT ["./entrypoint.sh"]
