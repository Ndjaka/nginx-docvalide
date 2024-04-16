#server {
#     server_name application.docvalide.com www.application.docvalide.com;

#     root /var/www/app.docvalide.com/public_html;

#     index index.html index.htm;

     location / {
          try_files $uri $uri/ =404;
     }

    listen [::]:443 ssl; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/application.docvalide.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/application.docvalide.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}
server {
    if ($host = www.application.docvalide.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = application.docvalide.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


     listen 80;
     listen [::]:80;
     server_name application.docvalide.com www.application.docvalide.com;
    return 404; # managed by Certbot




}