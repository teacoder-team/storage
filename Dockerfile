# Этап 1: Сборка
FROM golang:1.23 AS builder

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем go.mod и go.sum для кэширования зависимостей
COPY go.mod go.sum ./

# Загружаем все зависимости
RUN go mod download

# Копируем все файлы проекта в рабочую директорию контейнера
COPY . .

# Собираем исполняемый файл
RUN go build -o /go-app cmd/main.go

# Этап 2: Запуск
FROM alpine:latest

# Устанавливаем рабочую директорию для приложения
WORKDIR /root/

# Копируем скомпилированный бинарный файл из стадии сборки
COPY --from=builder /go-app .

# Экспонируем порт, на котором приложение будет слушать
EXPOSE 14704

# Команда для запуска приложения
CMD ["./go-app"]