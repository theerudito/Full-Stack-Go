# Usar una imagen de Go compatible con la versión de tu proyecto
FROM golang:1.24.1

WORKDIR /app

COPY . .

RUN go mod tidy

RUN go build -o api .

EXPOSE 1000

CMD ["./api"]

