#!/bin/sh
set -e

echo "Starting all binaries..."

# Запуск Telegram-бота
./target/release/bot &

# Запуск sync worker
./target/release/sync &

# Запуск deliver worker
./target/release/deliver &

# Ждём завершения всех процессов
wait
