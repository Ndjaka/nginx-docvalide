server {
    server_name www.test-api.docvalide.com test-api.docvalide.com;

        location / {
         proxy_pass http://localhost:8083/;
         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_set_header X-Forwarded-Proto $scheme;
         proxy_set_header X-Forwarded-Port $server_port;
    }


    listen [::]:443 ssl; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/www.test-api.docvalide.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/www.test-api.docvalide.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}

server {
    if ($host = test-api.docvalide.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = www.test-api.docvalide.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    listen [::]:80;
    server_name www.test-api.docvalide.com test-api.docvalide.com;
    return 404; # managed by Certbot




}