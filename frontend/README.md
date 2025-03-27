Alojar un sitio web React en un servidor Ubuntu con Nginx

Instalar Nginx en Ubuntu

```bash
sudo apt update
sudo apt install nginx
```

Instalar Certbot

```bash
sudo apt install certbot python3-certbot-nginx
```

Verificar Estado de Nginx

```bash
sudo systemctl status nginx
```

Verificar la configuración de Nginx

```bash
sudo nginx -t
```

mensaje de salida:

```bash
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

crear el directorio para archivos estáticos en /var/www/tu-dominio.com

```bash
sudo mkdir -p /var/www/tu-dominio.com
```

copiar los archivos estáticos a /var/www/tu-dominio.com

```bash
sudo cp -r /home/ubuntu/tu-dominio.com/build/* /var/www/tu-dominio.com/
```

Crea un archivo de configuración en /etc/nginx/sites-available/tu-dominio.com

```bash
sudo nano /etc/nginx/sites-available/tu-dominio.com
```

Ejemplo:

```bash
server {
    listen 80;
    listen [::]:80;

    server_name tu-dominio.com;

    root /var/www/tu-dominio.com;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

Verificar la configuración de Nginx

```bash
sudo nginx -t
```

mensaje de salida:

```bash
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

crear un enlace simbólico en /etc/nginx/sites-enabled/

```bash
sudo ln -s /etc/nginx/sites-available/tu-dominio.com /etc/nginx/sites-enabled/
```

Verificar la configuración de Nginx

```bash
sudo nginx -t
```

mensaje de salida:

```bash
nginx: configuration file /etc/nginx/nginx.conf test is successful
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
