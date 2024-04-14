server {
        client_max_body_size 64M;
        server_name docvalide.com www.docvalide.com;

        location / {
                proxy_pass             http://127.0.0.1:3000;
                proxy_read_timeout     60;
                proxy_connect_timeout  60;
                proxy_redirect         off;

                # Allow the use of websockets
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
        }


    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/docvalide.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/docvalide.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}
server {
    if ($host = www.docvalide.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = docvalide.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


        listen 80;
        server_name docvalide.com www.docvalide.com;
    return 404; # managed by Certbot




}