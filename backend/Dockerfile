FROM golang:1.24.1 AS builder

WORKDIR /app
COPY . . 
RUN go mod tidy
RUN GOOS=linux GOARCH=amd64 go build -o api .  # Compila para Linux

FROM alpine:latest

RUN apk add --no-cache libc6-compat

WORKDIR /root/

COPY --from=builder /app/api /root/api  

EXPOSE 1000
CMD ["./api"]