# Etapa de construcción
FROM golang:1.24.1 AS builder

WORKDIR /app
COPY . . 
RUN go mod tidy
RUN GOOS=linux GOARCH=amd64 go build -o api .  # Compila para Linux

# Etapa de ejecución
FROM alpine:latest
WORKDIR /root/

# Copia el binario desde la fase de construcción al contenedor
COPY --from=builder /app/api /root/api  

EXPOSE 1000
CMD ["./api"]  # Ejecuta el binario en la ubicación correcta
