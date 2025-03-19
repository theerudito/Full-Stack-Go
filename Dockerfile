# Etapa de construcción
FROM golang:1.24.1 AS builder

WORKDIR /app
COPY . . 
RUN go mod tidy
RUN go build -o api .  

# Etapa de ejecución
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/api .  
EXPOSE 1000
CMD ["./api"]
