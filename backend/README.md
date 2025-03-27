Nginx Go + Postgres SQL + Docker + Docker-Compose + Ubuntu

crear el archivo de Dockerfile

```bash
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
```

crear el archivo de docker-compose.yml

```bash
services:

  api:
    build:
      context: .
      dockerfile: ./Dockerfile
    ports:
      - "1000:1000"
    environment:
      ENVIRONMENT: production
      DATABASE_URL: postgres://postgres:1020@db:5432/Ejemplo?sslmode=disable
    depends_on:
      - db
    networks:
      - red
    restart: always

  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: 1020
      POSTGRES_DB: Ejemplo
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - red
    restart: always

volumes:
  pgdata:

networks:
  red:
    driver: bridge
```

crear el archivo de init.sql

```bash
-- Crear base de datos
CREATE DATABASE Ejemplo;

-- Conectarse a la base de datos
\c Ejemplo;

-- Crear tabla de personajes
CREATE TABLE
  personajes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    clan VARCHAR(100),
    edad INT
  );

-- Insertar algunos personajes de ejemplo
INSERT INTO
  personajes (nombre, clan, edad)
VALUES
  ('Naruto Uzumaki', 'Uzumaki', 17),
  ('Sasuke Uchiha', 'Uchiha', 17),
  ('Sakura Haruno', 'Haruno', 17),
  ('Kakashi Hatake', 'Hatake', 29),
  ('Itachi Uchiha', 'Uchiha', 21),
  ('Gaara', 'Kazekage', 17);
```

crear el archivo .env

```bash
POSTGRES_USER=postgres
POSTGRES_PASSWORD=1020
POSTGRES_DB=Ejemplo
DATABASE_URL=postgres://postgres:1020@db:5432/Ejemplo?sslmode=disable
ENVIRONMENT=production
```

levantar el contenedor

```bash
docker-compose up -d
```

detener el contenedor

```bash
docker-compose down
```

verificar la configuracion de nginx

```bash
sudo nginx -t
```

ver el mensaje output

```bash
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

crear el archivo de configuracion para nginx

```bash
sudo nano /etc/nginx/sites-available/tu-sitio.com
```

```bash
server {
listen 80;
server_name tu-sitio.com;

    location / {
        proxy_pass http://localhost:puerto; # ip y puerto del servidor
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Redirige tráfico HTTP a HTTPS
    return 301 https://$server_name$request_uri;
}
```

crear un enlace simbolico

```bash
sudo ln -s /etc/nginx/sites-available/tu-sitio.com /etc/nginx/sites-enabled/
```

verificar la configuracion de nginx

```bash
sudo nginx -t
```

ver el mensaje output

```bash
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

reiniciar el servicio de nginx

```bash
sudo systemctl restart nginx
```

Usar Certbot para obtener los certificados SSL

```bash
sudo certbot --nginx -d tu-dominio.com
```

llenar los datos solicitados

Verificar la configuración de Nginx

```bash
sudo nginx -t
```

mensaje de salida:

```bash
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Reiniciar Nginx

```bash
sudo systemctl restart nginx
```

Renovar los certificados automáticamente

```bash
sudo certbot renew
```

Verifica que la renovación se haya realizado correctamente:

```bash
sudo systemctl reload nginx
```

Configura la renovación automáticamente:

```bash
sudo systemctl enable certbot.timer
```

primero se configura el servidor HTTP y luego el servidor HTTPS

```bash
server {
listen 443 ssl;
server_name tu-sitio.com;

    ssl_certificate /etc/letsencrypt/live/tu-sitio.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tu-sitio.com/privkey.pem;

    location / {
        proxy_pass http://localhost:puerto; # ip y puerto del servidor
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

}
```
