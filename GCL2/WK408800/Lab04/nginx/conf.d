server {
    listen 443 ssl;
    server_name 192.168.68.120;

    ssl_certificate /etc/ssl/mycert.crt;
    ssl_certificate_key /etc/ssl/mycert.key;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass http://jenkins:8080;
        proxy_read_timeout 90;
    }
}
